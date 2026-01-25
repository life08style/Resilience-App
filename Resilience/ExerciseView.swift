import SwiftUI
import Charts

struct ExerciseView: View {
    @ObservedObject var settings = UserSettings.shared
    @State private var viewMode: Int = 0 // 0: Categories, 1: Body Map
    @State private var selectedMuscle: MuscleGroup? = nil
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            ZStack {
                ScrollView {
                    VStack(spacing: 24) {
                        // Hero Section
                        ZStack(alignment: .bottomLeading) {
                            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=1200")) { image in
                                image.resizable().aspectRatio(contentMode: .fill)
                            } placeholder: { Color.gray }
                            .frame(height: 200)
                            .clipped()
                            .overlay(LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom))
                            .cornerRadius(16)
                            
                            VStack(alignment: .leading) {
                                Text("Your Fitness Hub")
                                    .font(.title).bold()
                                Text("Choose your path to greatness")
                                    .font(.subheadline).foregroundColor(.gray)
                            }
                            .padding()
                        }
                        
                        // Categories
                        categoriesView
                        
                        Divider().background(Color.white.opacity(0.1))
                        
                        // Bikel Chart Section (Embedded at bottom as requested)
                        VStack(spacing: 24) {
                            HumanBodyView(selectedMuscle: $selectedMuscle)
                                .transition(.opacity)
                        }
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(24)
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
                
                // Side Drawer Overlay
                if let muscle = selectedMuscle {
                    ZStack {
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation { selectedMuscle = nil }
                            }
                        
                        HStack {
                            Spacer()
                            MuscleWorkoutsView(muscle: muscle, onClose: {
                                withAnimation { selectedMuscle = nil }
                            })
                            .frame(width: UIScreen.main.bounds.width * 0.85)
                            .background(Color(UIColor.systemGray6))
                            .transition(.move(edge: .trailing))
                        }
                    }
                    .zIndex(100)
                }
            }
        }
    }
    
    private var categoriesView: some View {
        VStack(spacing: 24) {
            // Progress Stats
            VStack(alignment: .leading) {
                Text("YOUR PROGRESS").font(.caption).fontWeight(.bold).foregroundColor(.gray)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    QuickStatCard(label: "Workouts", value: "12", icon: "dumbbell.fill", color: .red)
                    QuickStatCard(label: "Runs", value: "5", icon: "mappin.circle.fill", color: .teal)
                    QuickStatCard(label: "Streak", value: "3", icon: "flame.fill", color: .orange)
                    QuickStatCard(label: "Plans", value: "1", icon: "target", color: .purple)
                }
            }
            
            // Categories
            VStack(alignment: .leading) {
                Text("TRAINING CATEGORIES").font(.caption).fontWeight(.bold).foregroundColor(.gray)
                
                VStack(spacing: 16) {
                    // Running
                    NavigationLink(destination: RunningView()) {
                        ExerciseCategoryCard(title: "Running", image: "https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=800", color: .teal)
                    }
                    
                    // Strength
                    NavigationLink(destination: StrengthTrainingView()) {
                        ExerciseCategoryCard(title: "Strength", image: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800", color: .red)
                    }
                    
                    // Plyometrics & Agility
                    NavigationLink(destination: PlyometricsView()) {
                        ExerciseCategoryCard(title: "Plyometrics", subtitle: " & Agility", image: "https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?w=800", color: .orange)
                    }
                    
                    // Mindfulness & Recovery
                    NavigationLink(destination: MindfulnessView()) {
                        ExerciseCategoryCard(title: "Mindfulness", subtitle: " & Recovery", image: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800", color: .blue)
                    }
                }
            }
        }
    }
    
    // MARK: - Bikel Chart
    
    private var bikelHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("THE BIKEL CHART")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text("Muscle Groups & Exercises")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            Spacer()
            Image(systemName: "figure.strengthtraining.traditional")
                .foregroundColor(.blue)
                .font(.title2)
        }
    }
}

// MARK: - Components

struct QuickStatCard: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct ExerciseCategoryCard: View {
    let title: String
    var subtitle: String = ""
    let image: String
    let color: Color
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: image)) { img in
                img.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(height: 180) // Taller card
            .clipped()
            
            // Gradient Overlay
            LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}
