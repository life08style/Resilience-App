import SwiftUI

struct BluMascotView: View {
    let customization: BluCustomization
    var size: CGFloat = 100
    
    var body: some View {
        ZStack {
            // Base Body (Bear Shape)
            Circle()
                .fill(mascotColor)
                .frame(width: size, height: size)
            
            // Ears
            HStack(spacing: size * 0.6) {
                Circle()
                    .fill(mascotColor)
                    .frame(width: size * 0.3, height: size * 0.3)
                Circle()
                    .fill(mascotColor)
                    .frame(width: size * 0.3, height: size * 0.3)
            }
            .offset(y: -size * 0.4)
            
            // Face Area
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: size * 0.7, height: size * 0.6)
                .offset(y: size * 0.05)
            
            // Eyes
            HStack(spacing: size * 0.2) {
                eyeView
                eyeView
            }
            .offset(y: -size * 0.05)
            
            // Mouth (Expression)
            mouthView
                .offset(y: size * 0.15)
            
            // Accessories
            accessoryView
            
            // Outfit (Simplified overlay)
            outfitView
        }
        .frame(width: size, height: size)
    }
    
    var mascotColor: Color {
        switch customization.color {
        case "purple": return .purple
        case "green": return .green
        case "orange": return .orange
        case "pink": return .pink
        default: return .blue
        }
    }
    
    var eyeView: some View {
        Group {
            if customization.expression == "excited" {
                Text("🤩")
                    .font(.system(size: size * 0.2))
            } else if customization.expression == "focused" {
                Circle()
                    .fill(Color.black)
                    .frame(width: size * 0.1, height: size * 0.1)
                    .overlay(
                        Rectangle()
                            .fill(Color.black)
                            .frame(height: size * 0.02)
                            .offset(y: -size * 0.05)
                    )
            } else {
                Circle()
                    .fill(Color.black)
                    .frame(width: size * 0.1, height: size * 0.1)
            }
        }
    }
    
    var mouthView: some View {
        Group {
            if customization.expression == "happy" {
                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(Color.black, lineWidth: size * 0.03)
                    .frame(width: size * 0.2, height: size * 0.2)
            } else if customization.expression == "determined" {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: size * 0.2, height: size * 0.03)
            } else {
                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(Color.black, lineWidth: size * 0.03)
                    .frame(width: size * 0.15, height: size * 0.15)
            }
        }
    }
    
    @ViewBuilder
    var accessoryView: some View {
        if customization.accessory == "glasses" {
            Text("👓")
                .font(.system(size: size * 0.4))
                .offset(y: -size * 0.05)
        } else if customization.accessory == "crown" {
            Text("👑")
                .font(.system(size: size * 0.4))
                .offset(y: -size * 0.5)
        } else if customization.accessory == "headband" {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.red)
                .frame(width: size * 0.8, height: size * 0.1)
                .offset(y: -size * 0.3)
        }
    }
    
    @ViewBuilder
    var outfitView: some View {
        if customization.outfit == "superhero" {
            Image(systemName: "shield.fill")
                .font(.system(size: size * 0.3))
                .foregroundColor(.yellow)
                .offset(y: size * 0.3)
        } else if customization.outfit == "formal" {
            Text("👔")
                .font(.system(size: size * 0.3))
                .offset(y: size * 0.35)
        }
    }
}
