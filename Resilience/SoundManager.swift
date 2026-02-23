import Foundation
import Combine
import AVFoundation
import AudioToolbox

class SoundManager: ObservableObject {
    
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    private var streamPlayer: AVPlayer?
    private var silentPlayer: AVAudioPlayer?
    private var vibrationTimer: Timer?
    @Published var isAlarmPlaying = false
    
    /// Catalog of alarm sounds with URLs for streaming preview
    static let alarmSounds: [(id: String, name: String, url: String, description: String)] = [
        ("default", "Classic Alarm", "https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg", "Traditional alarm clock sound"),
        ("beep", "Digital Beep", "https://actions.google.com/sounds/v1/alarms/digital_watch_alarm_long.ogg", "Sharp digital beeping"),
        ("bugle", "Military Bugle", "https://actions.google.com/sounds/v1/alarms/bugle_tune.ogg", "Wake up soldier!"),
        ("rooster", "Rooster", "https://actions.google.com/sounds/v1/animals/rooster_crow.ogg", "Natural rooster crow"),
        ("spaceship", "Spaceship Alarm", "https://actions.google.com/sounds/v1/alarms/spaceship_alarm.ogg", "Futuristic spaceship alert"),
        ("meditation", "Meditation Bell", "https://actions.google.com/sounds/v1/alarms/meditation_bell.ogg", "Gentle bell sound"),
        ("chime", "Wind Chimes", "https://actions.google.com/sounds/v1/alarms/chime_bell.ogg", "Peaceful chimes"),
        ("trumpet", "Trumpet Fanfare", "https://actions.google.com/sounds/v1/alarms/trumpet_fanfare.ogg", "Royal wake up call"),
        ("birdsong", "Birds Chirping", "https://actions.google.com/sounds/v1/animals/birds_chirping.ogg", "Morning birds singing"),
        ("siren", "Emergency Siren", "https://actions.google.com/sounds/v1/alarms/siren.ogg", "Loud emergency alert"),
        ("gong", "Temple Gong", "https://actions.google.com/sounds/v1/alarms/gong.ogg", "Deep resonant gong")
    ]
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    // MARK: - Sound Preview
    
    func playSoundPreview(named soundId: String) {
        stopPreview()
        
        guard let sound = SoundManager.alarmSounds.first(where: { $0.id == soundId }),
              let url = URL(string: sound.url) else {
            // Fallback to system sound
            AudioServicesPlaySystemSound(1057)
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        streamPlayer = AVPlayer(playerItem: playerItem)
        streamPlayer?.play()
        
        // Stop after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.stopPreview()
        }
    }
    
    func stopPreview() {
        streamPlayer?.pause()
        streamPlayer = nil
    }
    
    // MARK: - Alarm Playback
    
    func playAlarm(named soundId: String) {
        stopPreview()
        isAlarmPlaying = true
        
        // Set audio session to high priority
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
        
        // Try streaming the alarm sound
        if let sound = SoundManager.alarmSounds.first(where: { $0.id == soundId }),
           let url = URL(string: sound.url) {
            let playerItem = AVPlayerItem(url: url)
            streamPlayer = AVPlayer(playerItem: playerItem)
            streamPlayer?.play()
            
            // Loop the alarm sound
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: playerItem,
                queue: .main
            ) { [weak self] _ in
                self?.streamPlayer?.seek(to: .zero)
                self?.streamPlayer?.play()
            }
        } else {
            // Fallback: system sound
            AudioServicesPlaySystemSound(1005)
        }
        
        // Start vibration loop
        startVibrationLoop()
    }
    
    func stopAlarm() {
        isAlarmPlaying = false
        streamPlayer?.pause()
        streamPlayer = nil
        audioPlayer?.stop()
        audioPlayer = nil
        stopVibrationLoop()
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    // MARK: - Vibration
    
    private func startVibrationLoop() {
        vibrationTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        // First vibration immediately
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    private func stopVibrationLoop() {
        vibrationTimer?.invalidate()
        vibrationTimer = nil
    }
    
    // MARK: - Silent Mode (for keeping app alive in background)
    
    func startSilentMode() {
        print("Starting silent mode for alarm monitoring...")
    }
    
    func stopSilentMode() {
        print("Stopping silent mode.")
        audioPlayer?.stop()
    }
}
