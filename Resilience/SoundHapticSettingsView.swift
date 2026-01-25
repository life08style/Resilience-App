import SwiftUI

struct SoundHapticSettingsView: View {
    @ObservedObject var settings = UserSettings.shared
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Sounds & Haptics")
                        .font(DesignSystem.Fonts.titleLarge())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Audio Section
                    VStack(alignment: .leading, spacing: 20) {
                        Label {
                            Text("Volume")
                                .font(.headline)
                                .foregroundColor(.white)
                        } icon: {
                            Image(systemName: "speaker.wave.3.fill")
                                .foregroundColor(.purple)
                        }
                        
                        VStack(spacing: 8) {
                            Slider(value: $settings.soundVolume, in: 0...1)
                                .accentColor(.purple)
                            
                            HStack {
                                Image(systemName: "speaker.fill")
                                Spacer()
                                Image(systemName: "speaker.wave.3.fill")
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // Haptics Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("PHYSICAL FEEDBACK")
                            .font(.caption2.bold())
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        HStack {
                            Image(systemName: "hand.tap.fill")
                                .foregroundColor(.blue)
                                .frame(width: 32)
                            
                            VStack(alignment: .leading) {
                                Text("Haptic Feedback")
                                    .foregroundColor(.white)
                                Text("Subtle vibrations for interactions")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $settings.hapticsEnabled)
                                .labelsHidden()
                                .tint(.blue)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(20)
                        .padding(.horizontal)
                    }
                    
                    // Focus Mode Sounds
                    VStack(alignment: .leading, spacing: 16) {
                        Text("FOCUS MODE ALERTS")
                            .font(.caption2.bold())
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        HStack {
                            Text("Amber Alert Sound")
                                .foregroundColor(.white)
                            Spacer()
                            Text("Critical Alert").foregroundColor(.red).font(.caption.bold())
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(20)
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    SoundHapticSettingsView()
}
