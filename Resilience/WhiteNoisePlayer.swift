import SwiftUI
import AVFoundation

struct WhiteNoisePlayer: View {
    @Environment(\.dismiss) var dismiss
    @State private var activeSounds: Set<String> = []
    
    let sounds = [
        ("Ocean", "water.waves"),
        ("Rain", "cloud.rain.fill"),
        ("Thunder", "bolt.fill"),
        ("Wind", "wind"),
        ("Fire", "flame.fill"),
        ("Thunderstorm", "cloud.bolt.rain.fill"),
        // ("Noise", "waveform"), // Removed generic noise if needed, or keep
        ("Birds", "bird.fill"),
        ("Fan", "fan.fill")
    ]
    
    var body: some View {
        ZStack {
            // Space Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Stars (Mock)
            GeometryReader { geo in
                ForEach(0..<100) { i in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.2...0.8)))
                        .frame(width: 2, height: 2)
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: CGFloat.random(in: 0...geo.size.height)
                        )
                }
            }
            
            // Central Glowing Orb (Moon/Planet)
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .blur(radius: 50)
                
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 200, height: 200)
                    .blur(radius: 30)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 100, height: 100)
                    .blur(radius: 10)
            }
            .offset(y: -50)
            
            // Wooden Signs Deployment
            VStack {
                Spacer().frame(height: 80)
                
                HStack(spacing: 40) {
                    WoodenSignButton(title: "Ocean", icon: "water.waves", isActive: activeSounds.contains("Ocean")) { toggle("Ocean") }
                        .rotationEffect(.degrees(-5))
                    WoodenSignButton(title: "Rain", icon: "cloud.rain.fill", isActive: activeSounds.contains("Rain")) { toggle("Rain") }
                        .rotationEffect(.degrees(5))
                }
                
                Spacer().frame(height: 30)
                
                HStack(spacing: 60) {
                    WoodenSignButton(title: "Wind", icon: "wind", isActive: activeSounds.contains("Wind")) { toggle("Wind") }
                        .rotationEffect(.degrees(-10))
                }
                
                Spacer().frame(height: 20)
                
                HStack(spacing: 30) {
                    WoodenSignButton(title: "Thunder", icon: "bolt.fill", isActive: activeSounds.contains("Thunder")) { toggle("Thunder") }
                        .rotationEffect(.degrees(5))
                    WoodenSignButton(title: "Fire", icon: "flame.fill", isActive: activeSounds.contains("Fire")) { toggle("Fire") }
                        .rotationEffect(.degrees(-5))
                }
                
                Spacer().frame(height: 30)
                
                HStack(spacing: 40) {
                    WoodenSignButton(title: "Birds", icon: "bird.fill", isActive: activeSounds.contains("Birds")) { toggle("Birds") }
                        .rotationEffect(.degrees(8))
                    WoodenSignButton(title: "Fan", icon: "fan.fill", isActive: activeSounds.contains("Fan")) { toggle("Fan") }
                        .rotationEffect(.degrees(-3))
                }
                
                Spacer()
            }
            
            // Blu Mascot
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    BluMascotView(customization: BluStore.shared.customization, size: 100)
                        .padding()
                }
            }
            
            // Top Close Button
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding()
                }
                Spacer()
                
                Spacer()
            }
            // Stop sounds when the view is dismissed
            .onDisappear {
                WhiteNoiseEngine.shared.stopAll()
            }
            // Ensure sounds match active state if needed (optional re-sync logic could go here)
        }
        .navigationBarHidden(true)
    }
    
    func toggle(_ sound: String) {
        // Haptic Feedback
        HapticManager.shared.impact(style: .medium)
        
        // Sound Logic
        _ = WhiteNoiseEngine.shared.toggleSound(named: sound)
        
        // UI State Update
        if activeSounds.contains(sound) {
            activeSounds.remove(sound)
        } else {
            activeSounds.insert(sound)
        }
    }
}

struct WoodenSignButton: View {
    let title: String
    let icon: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Wooden Plaque Background
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.6, green: 0.4, blue: 0.2), Color(red: 0.4, green: 0.25, blue: 0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(red: 0.3, green: 0.15, blue: 0.05), lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 2, y: 2)
                
                // Content
                VStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(isActive ? .yellow : .white.opacity(0.9))
                        .shadow(color: isActive ? .orange : .clear, radius: 5)
                    
                    Text(title)
                        .font(.system(size: 14, weight: .bold, design: .serif))
                        .foregroundColor(Color(red: 0.95, green: 0.9, blue: 0.8))
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                }
                .padding(12)
            }
            .frame(width: 90, height: 70)
            .scaleEffect(isActive ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isActive)
        }
    }
}
