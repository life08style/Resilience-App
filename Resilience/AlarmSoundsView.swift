import SwiftUI
import AVFoundation
import Combine

struct AlarmSound: Identifiable {
    let id: String
    let name: String
    let url: String
    let description: String
}

class AudioPlayerManager: ObservableObject {
    var audioPlayer: AVPlayer?
    @Published var playingSoundId: String?
    
    func play(url: String, id: String) {
        if playingSoundId == id {
            stop()
        } else {
            guard let soundURL = URL(string: url) else { return }
            let playerItem = AVPlayerItem(url: soundURL)
            audioPlayer = AVPlayer(playerItem: playerItem)
            audioPlayer?.play()
            playingSoundId = id
            
            // Reset when finished
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main) { [weak self] _ in
                self?.playingSoundId = nil
            }
        }
    }
    
    func stop() {
        audioPlayer?.pause()
        playingSoundId = nil
    }
}

struct AlarmSoundsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var audioManager = AudioPlayerManager()
    @Binding var selectedSoundId: String
    
    let sounds: [AlarmSound] = [
        AlarmSound(id: "default", name: "Classic Alarm", url: "https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg", description: "Traditional alarm clock sound"),
        AlarmSound(id: "beep", name: "Digital Beep", url: "https://actions.google.com/sounds/v1/alarms/digital_watch_alarm_long.ogg", description: "Sharp digital beeping"),
        AlarmSound(id: "bugle", name: "Military Bugle", url: "https://actions.google.com/sounds/v1/alarms/bugle_tune.ogg", description: "Wake up soldier!"),
        AlarmSound(id: "rooster", name: "Rooster", url: "https://actions.google.com/sounds/v1/animals/rooster_crow.ogg", description: "Natural rooster crow"),
        AlarmSound(id: "spaceship", name: "Spaceship Alarm", url: "https://actions.google.com/sounds/v1/alarms/spaceship_alarm.ogg", description: "Futuristic spaceship alert"),
        AlarmSound(id: "meditation", name: "Meditation Bell", url: "https://actions.google.com/sounds/v1/alarms/meditation_bell.ogg", description: "Gentle bell sound"),
        AlarmSound(id: "chime", name: "Wind Chimes", url: "https://actions.google.com/sounds/v1/alarms/chime_bell.ogg", description: "Peaceful chimes"),
        AlarmSound(id: "trumpet", name: "Trumpet Fanfare", url: "https://actions.google.com/sounds/v1/alarms/trumpet_fanfare.ogg", description: "Royal wake up call"),
        AlarmSound(id: "marimba", name: "Marimba", url: "https://actions.google.com/sounds/v1/alarms/marimba_phone.ogg", description: "Classic phone ringtone"),
        AlarmSound(id: "electronic", name: "Electronic", url: "https://actions.google.com/sounds/v1/alarms/electronic_beep.ogg", description: "Modern electronic tone"),
        AlarmSound(id: "doorbell", name: "Doorbell", url: "https://actions.google.com/sounds/v1/alarms/doorbell.ogg", description: "Classic doorbell chime"),
        AlarmSound(id: "cuckoo", name: "Cuckoo Clock", url: "https://actions.google.com/sounds/v1/alarms/cuckoo_clock.ogg", description: "Traditional cuckoo sound"),
        AlarmSound(id: "birdsong", name: "Birds Chirping", url: "https://actions.google.com/sounds/v1/animals/birds_chirping.ogg", description: "Morning birds singing"),
        AlarmSound(id: "siren", name: "Emergency Siren", url: "https://actions.google.com/sounds/v1/alarms/siren.ogg", description: "Loud emergency alert"),
        AlarmSound(id: "gong", name: "Temple Gong", url: "https://actions.google.com/sounds/v1/alarms/gong.ogg", description: "Deep resonant gong")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color(UIColor.systemGray6).opacity(0.5))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        Text("Alarm Sounds")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.indigo)
                                .cornerRadius(20)
                        }
                    }
                    .padding()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Choose your alarm sound. Tap to preview.")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            ForEach(sounds) { sound in
                                Button(action: {
                                    selectedSoundId = sound.id
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text(sound.name)
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                
                                                if selectedSoundId == sound.id {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(.indigo)
                                                }
                                            }
                                            Text(sound.description)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            audioManager.play(url: sound.url, id: sound.id)
                                        }) {
                                            Image(systemName: audioManager.playingSoundId == sound.id ? "pause.circle.fill" : "play.circle.fill")
                                                .font(.system(size: 32))
                                                .foregroundColor(audioManager.playingSoundId == sound.id ? .indigo : .gray)
                                        }
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedSoundId == sound.id ? Color.indigo.opacity(0.1) : Color(UIColor.systemGray6).opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(selectedSoundId == sound.id ? Color.indigo : Color.clear, lineWidth: 1)
                                            )
                                    )
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true)
            .onDisappear {
                audioManager.stop()
            }
        }
    }
}
