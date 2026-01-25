import SwiftUI
import UIKit

struct HumanBodyView: View {
    @Binding var selectedMuscle: MuscleGroup?
    @State private var showingBack = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "figure.arms.open")
                        .foregroundColor(.cyan)
                    Text("Bikel Chart")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Front / Back Toggle
                HStack(spacing: 0) {
                    Button(action: { 
                        withAnimation { showingBack = false }
                        HapticManager.shared.impact()
                    }) {
                        Text("Front")
                            .font(.system(size: 13, weight: .bold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(!showingBack ? Color.cyan : Color.white.opacity(0.1))
                            .foregroundColor(!showingBack ? .black : .white)
                    }
                    .cornerRadius(8, corners: [.topLeft, .bottomLeft])
                    
                    Button(action: { 
                        withAnimation { showingBack = true }
                        HapticManager.shared.impact()
                    }) {
                        Text("Back")
                            .font(.system(size: 13, weight: .bold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(showingBack ? Color.cyan : Color.white.opacity(0.1))
                            .foregroundColor(showingBack ? .black : .white)
                    }
                    .cornerRadius(8, corners: [.topRight, .bottomRight])
                }
            }
            .padding(.horizontal)
            
            ZStack(alignment: .bottomTrailing) {
                // Centered Silhouette
                HStack {
                    Spacer()
                    GeometricSilhouette(showingBack: showingBack, selectedMuscle: $selectedMuscle)
                        .frame(width: 200, height: 400) // Slightly larger
                    Spacer()
                }
                
                // Compact Exercise Box (Side Small Box)
                if let muscle = selectedMuscle {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 6) {
                            Circle().fill(muscleColor(muscle)).frame(width: 8, height: 8)
                            Text(muscle.displayName)
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(.white)
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(exercisesFor(muscle), id: \.self) { exercise in
                                    Text("• \(exercise)")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.9))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        .frame(maxHeight: 120)
                        
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "play.fill").font(.caption2)
                                Text("Start").font(.caption2).fontWeight(.bold)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.cyan)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(12)
                    .frame(width: 140)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
                    .shadow(radius: 10)
                    .padding(16)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .frame(height: 420)
        }
        .padding(.vertical)
    }
    
    func muscleColor(_ muscle: MuscleGroup) -> Color {
        switch muscle {
        case .chest: return .red
        case .shoulders: return .orange
        case .arms: return .yellow
        case .core: return .green
        case .legs: return .blue
        case .back: return .red
        case .traps: return .purple
        case .forearms: return .yellow
        case .glutes: return .pink
        case .hamstrings: return .indigo
        case .calves: return .blue
        }
    }
    
    func exercisesFor(_ muscle: MuscleGroup) -> [String] {
        switch muscle {
        case .chest: return ["Incline Bench", "Flyes", "Push-ups"]
        case .shoulders: return ["Military Press", "Lat Raises", "Face Pulls"]
        case .arms: return ["Bicep Curls", "Tricep Ext", "Hammer Curls"]
        case .core: return ["Planks", "Crunches", "Leg Raises"]
        case .legs: return ["Squats", "Lunges", "Hack Squat"]
        case .back: return ["Pull Ups", "Rows", "Deadlifts"]
        case .traps: return ["Shrugs", "Upright Row", "Face Pulls"]
        case .forearms: return ["Wrist Curls", "Farmers Walk"]
        case .glutes: return ["Hip Thrusts", "Glute Bridge", "Kickbacks"]
        case .hamstrings: return ["Leg Curls", "RDL", "Nordics"]
        case .calves: return ["Calf Raises", "Seated Calf Raise"]
        }
    }
}

// MARK: - GEOMETRIC SHAPES
// Using raw polygons for a robotic/geometric look

struct GeometricSilhouette: View {
    let showingBack: Bool
    @Binding var selectedMuscle: MuscleGroup?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Base Wireframe
                GeometricBaseShape()
                    .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                    .background(GeometricBaseShape().fill(Color.black.opacity(0.5)))
                
                // Muscle Polygons
                Group {
                    if !showingBack {
                        // FRONT
                        // Traps (Triangle)
                        MusclePolygon(points: [
                            CGPoint(x: 0.35, y: 0.18), CGPoint(x: 0.65, y: 0.18), CGPoint(x: 0.5, y: 0.25)
                        ], muscle: .traps, selected: $selectedMuscle, color: .purple)
                        
                        // Chest (Hexagon-ish)
                        MusclePolygon(points: [
                            CGPoint(x: 0.2, y: 0.22), CGPoint(x: 0.8, y: 0.22),
                            CGPoint(x: 0.7, y: 0.35), CGPoint(x: 0.3, y: 0.35)
                        ], muscle: .chest, selected: $selectedMuscle, color: .red)

                        // Shoulders (Hexagons)
                        MusclePolygon(points: [
                            CGPoint(x: 0.1, y: 0.2), CGPoint(x: 0.2, y: 0.18), CGPoint(x: 0.2, y: 0.28), CGPoint(x: 0.1, y: 0.25)
                        ], muscle: .shoulders, selected: $selectedMuscle, color: .orange)
                        
                        MusclePolygon(points: [
                            CGPoint(x: 0.9, y: 0.2), CGPoint(x: 0.8, y: 0.18), CGPoint(x: 0.8, y: 0.28), CGPoint(x: 0.9, y: 0.25)
                        ], muscle: .shoulders, selected: $selectedMuscle, color: .orange)

                        // Abs (Grid)
                        MusclePolygon(points: [
                            CGPoint(x: 0.35, y: 0.36), CGPoint(x: 0.65, y: 0.36),
                            CGPoint(x: 0.60, y: 0.55), CGPoint(x: 0.40, y: 0.55)
                        ], muscle: .core, selected: $selectedMuscle, color: .green)
                        
                        // Quads (Diamonds)
                        MusclePolygon(points: [
                            CGPoint(x: 0.5, y: 0.55), CGPoint(x: 0.25, y: 0.55),
                            CGPoint(x: 0.3, y: 0.8), CGPoint(x: 0.45, y: 0.65)
                        ], muscle: .legs, selected: $selectedMuscle, color: .blue)
                        
                         MusclePolygon(points: [
                            CGPoint(x: 0.5, y: 0.55), CGPoint(x: 0.75, y: 0.55),
                            CGPoint(x: 0.7, y: 0.8), CGPoint(x: 0.55, y: 0.65)
                        ], muscle: .legs, selected: $selectedMuscle, color: .blue)

                    } else {
                        // BACK
                        // Lats (Triangle Wings)
                        MusclePolygon(points: [
                            CGPoint(x: 0.5, y: 0.5), CGPoint(x: 0.25, y: 0.25), CGPoint(x: 0.75, y: 0.25)
                        ], muscle: .back, selected: $selectedMuscle, color: .red)
                        
                        // Glutes (Squares)
                         MusclePolygon(points: [
                            CGPoint(x: 0.35, y: 0.5), CGPoint(x: 0.5, y: 0.5), CGPoint(x: 0.5, y: 0.6), CGPoint(x: 0.35, y: 0.6)
                        ], muscle: .glutes, selected: $selectedMuscle, color: .pink)
                        
                         MusclePolygon(points: [
                            CGPoint(x: 0.5, y: 0.5), CGPoint(x: 0.65, y: 0.5), CGPoint(x: 0.65, y: 0.6), CGPoint(x: 0.5, y: 0.6)
                        ], muscle: .glutes, selected: $selectedMuscle, color: .pink)
                    }
                }
            }
        }
    }
}

struct MusclePolygon: View {
    let points: [CGPoint]
    let muscle: MuscleGroup
    @Binding var selected: MuscleGroup?
    let color: Color
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let convertedPoints = points.map { CGPoint(x: $0.x * w, y: $0.y * h) }
            
            Path { path in
                path.addLines(convertedPoints)
                path.closeSubpath()
            }
            .fill(color.opacity(selected == muscle ? 1.0 : 0.4))
            .overlay(
                 Path { path in
                    path.addLines(convertedPoints)
                    path.closeSubpath()
                }.stroke(Color.white, lineWidth: selected == muscle ? 2 : 1)
            )
            .shadow(color: color.opacity(0.8), radius: selected == muscle ? 10 : 0)
            .onTapGesture {
                selected = (selected == muscle) ? nil : muscle
                HapticManager.shared.impact()
            }
        }
    }
}

struct GeometricBaseShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Simple angular outline
        let w = rect.width
        let h = rect.height
        
        // Head
        path.move(to: CGPoint(x: w*0.45, y: h*0.05))
        path.addLine(to: CGPoint(x: w*0.55, y: h*0.05))
        path.addLine(to: CGPoint(x: w*0.55, y: h*0.15))
        path.addLine(to: CGPoint(x: w*0.45, y: h*0.15))
        path.closeSubpath()
        
        // Shoulders to Hips
        path.move(to: CGPoint(x: w*0.2, y: h*0.18))
        path.addLine(to: CGPoint(x: w*0.8, y: h*0.18))
        path.addLine(to: CGPoint(x: w*0.7, y: h*0.5)) // Hips
        path.addLine(to: CGPoint(x: w*0.3, y: h*0.5)) // Hips
        path.closeSubpath()
        
        // Legs
        path.move(to: CGPoint(x: w*0.3, y: h*0.5))
        path.addLine(to: CGPoint(x: w*0.2, y: h*0.9))
        path.addLine(to: CGPoint(x: w*0.4, y: h*0.9))
        path.addLine(to: CGPoint(x: w*0.5, y: h*0.55)) // Crotch
        path.addLine(to: CGPoint(x: w*0.6, y: h*0.9))
        path.addLine(to: CGPoint(x: w*0.8, y: h*0.9))
        path.addLine(to: CGPoint(x: w*0.7, y: h*0.5))
        
        return path
    }
}

extension Path {
    mutating func addConvexPolygon(points: [CGPoint]) {
        guard points.count > 1 else { return }
        move(to: points[0])
        for i in 1..<points.count {
            addLine(to: points[i])
        }
        closeSubpath()
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

