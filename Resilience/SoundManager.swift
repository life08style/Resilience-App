import Foundation
import Combine
import AVFoundation

class SoundManager: ObservableObject {
    
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    private var silentPlayer: AVAudioPlayer?
    
    private init() {
        // Optionals are nil-initialized, so we can call methods now
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
    
    func playSoundPreview(named: String) {
        // Stop current playing sound if any
        audioPlayer?.stop()
        
        // Mock sound playback - In a real app, this would load a file
        // For now, we simulate with a 2-second timer or system sound if available
        print("Playing 2-second preview for: \(named)")
        
        // Example system sound (tink)
        AudioServicesPlaySystemSound(1057)
        
        // To simulate a 2-second duration, we could play a silent loop or just log
    }
    
    func startSilentMode() {
        print("Starting silent white noise mode...")
        // In a real app, you would play a very quiet or silent .wav file in a loop
        // audioPlayer = ... (play silent.wav in loop)
    }
    
    func stopSilentMode() {
        print("Stopping silent white noise mode.")
        audioPlayer?.stop()
    }
    
    func playAlarm(named: String) {
        print("TRIGGERING ALARM: \(named)")
        // Play alarm sound at high volume
        // audioPlayer = ... (play alarm.wav)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func stopAlarm() {
        audioPlayer?.stop()
    }
}
