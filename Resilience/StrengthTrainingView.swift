import SwiftUI

struct StrengthTrainingView: View {
    @State private var selectedDifficulty = "All"
    @State private var selectedDuration: Int? = nil
    @State private var selectedBodyPart = "All"
    @Environment(\.presentationMode) var presentationMode
    
    // Mock Data
    let workouts = [
        Workout(id: UUID(), workoutName: "Full Body Blast", description: "Build strength with Full Body Blast. This workout targets key muscle groups with compound movements.", category: "Full Body", exercises: [], estimatedDuration: "30 min"),
        Workout(id: UUID(), workoutName: "Upper Body Power", description: "Focus on chest, back, and arms for maximum hypertrophy.", category: "Upper Body", exercises: [], estimatedDuration: "45 min"),
        Workout(id: UUID(), workoutName: "Leg Day Destruction", description: "High volume leg workout to build mass and endurance.", category: "Lower Body", exercises: [], estimatedDuration: "60 min"),
        Workout(id: UUID(), workoutName: "Core Crusher", description: "Intense ab circuit for core stability.", category: "Core", exercises: [], estimatedDuration: "15 min")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero Header
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800")) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: { Color.gray }
                    .frame(height: 250)
                    .clipped()
                    .overlay(LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(.white)
                            .font(.subheadline)
                        }
                        .padding(.bottom, 20)
                        
                        Text("Build Strength")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        
                        Text("Targeted workouts for every muscle group")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    
                    // Ai Badge top right
                    VStack {
                        HStack {
                            Spacer()
                            VStack(alignment: .leading, spacing: 2) {
                                Text("AI-POWERED")
                                    .font(.caption2)
                                    .foregroundColor(.green)
                                Text("WORKOUT:")
                                    .font(.caption2)
                                    .foregroundColor(.green)
                                Text("MAX EFFORT")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            .padding(8)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(4)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.green, lineWidth: 1))
                            .padding()
                        }
                        Spacer()
                    }
                }
                
                // Filters
                VStack(alignment: .leading, spacing: 16) {
                    Text("FILTERS").font(.caption).fontWeight(.bold).foregroundColor(.white)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            Text("Difficulty").font(.caption).foregroundColor(.gray)
                            FilterChip(text: "Easy", isSelected: selectedDifficulty == "Easy") { selectedDifficulty = "Easy" }
                            FilterChip(text: "Medium", isSelected: selectedDifficulty == "Medium") { selectedDifficulty = "Medium" }
                            FilterChip(text: "Hard", isSelected: selectedDifficulty == "Hard") { selectedDifficulty = "Hard" }
                            FilterChip(text: "Expert", isSelected: selectedDifficulty == "Expert") { selectedDifficulty = "Expert" }
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            Text("Duration").font(.caption).foregroundColor(.gray)
                            FilterChip(text: "5 min", isSelected: selectedDuration == 5) { selectedDuration = 5 }
                            FilterChip(text: "15 min", isSelected: selectedDuration == 15) { selectedDuration = 15 }
                            FilterChip(text: "30 min", isSelected: selectedDuration == 30) { selectedDuration = 30 }
                            FilterChip(text: "1 hour", isSelected: selectedDuration == 60) { selectedDuration = 60 }
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            Text("Body Part").font(.caption).foregroundColor(.gray)
                            FilterChip(text: "Lower Body", isSelected: selectedBodyPart == "Lower Body") { selectedBodyPart = "Lower Body" }
                            FilterChip(text: "Arms & Abs", isSelected: selectedBodyPart == "Arms & Abs") { selectedBodyPart = "Arms & Abs" }
                            FilterChip(text: "Chest", isSelected: selectedBodyPart == "Chest") { selectedBodyPart = "Chest" }
                        }
                    }
                }
                .padding(.horizontal)
                
                // List
                VStack(alignment: .leading, spacing: 16) {
                    Text("AVAILABLE WORKOUTS").font(.caption).fontWeight(.bold).foregroundColor(.white)
                    
                    ForEach(workouts) { workout in
                        WorkoutDetailCard(workout: workout)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
    }
}

struct WorkoutDetailCard: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(workout.workoutName)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Divider().background(Color.white.opacity(0.2))
            
            Text(workout.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(spacing: 16) {
                Label("Intermediate", systemImage: "circle.fill")
                    .foregroundColor(.orange)
                Label(workout.estimatedDuration, systemImage: "clock")
                Label("6 rounds", systemImage: "arrow.triangle.2.circlepath")
                Label("Cardio", systemImage: "heart.fill")
                    .foregroundColor(.yellow)
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            HStack {
                Button(action: {}) {
                    Label("Schedule", systemImage: "calendar.badge.plus")
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Button(action: {}) {
                    Label("Start Now", systemImage: "play.fill")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.orange)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.15))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}
