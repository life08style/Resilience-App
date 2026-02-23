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
    @Environment(\.dismiss) var dismiss
    @StateObject private var audioManager = AudioPlayerManager()
    @Binding var selectedSoundId: String
    
    let sounds: [AlarmSound] = SoundManager.alarmSounds.map {
        AlarmSound(id: $0.id, name: $0.name, url: $0.url, description: $0.description)
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.08))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    Text("Alarm Sounds")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Text("Done")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                LinearGradient(colors: [.purple, .indigo], startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(20)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Choose your alarm sound. Tap the play button to preview.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        ForEach(sounds) { sound in
                            Button(action: {
                                selectedSoundId = sound.id
                                HapticManager.shared.impact(style: .light)
                            }) {
                                HStack(spacing: 12) {
                                    // Selection indicator
                                    ZStack {
                                        Circle()
                                            .stroke(selectedSoundId == sound.id ? Color.purple : Color.gray.opacity(0.3), lineWidth: 2)
                                            .frame(width: 24, height: 24)
                                        
                                        if selectedSoundId == sound.id {
                                            Circle()
                                                .fill(Color.purple)
                                                .frame(width: 14, height: 14)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(sound.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text(sound.description)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    // Play button
                                    Button(action: {
                                        audioManager.play(url: sound.url, id: sound.id)
                                        HapticManager.shared.impact(style: .light)
                                    }) {
                                        Image(systemName: audioManager.playingSoundId == sound.id ? "pause.circle.fill" : "play.circle.fill")
                                            .font(.system(size: 34))
                                            .foregroundColor(audioManager.playingSoundId == sound.id ? .purple : .gray.opacity(0.6))
                                            .animation(.easeInOut(duration: 0.2), value: audioManager.playingSoundId)
                                    }
                                }
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(selectedSoundId == sound.id ? Color.purple.opacity(0.08) : Color.white.opacity(0.03))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(selectedSoundId == sound.id ? Color.purple.opacity(0.4) : Color.clear, lineWidth: 1)
                                        )
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .onDisappear {
            audioManager.stop()
        }
    }
}
