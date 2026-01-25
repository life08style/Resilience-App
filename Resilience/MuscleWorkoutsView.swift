import SwiftUI

struct MuscleWorkoutsView: View {
    let muscle: MuscleGroup
    var onClose: () -> Void
    
    // Mock Exercises for the muscle group
    var exercises: [Exercise] {
        WorkoutDatabase.shared.exercises.filter { $0.primaryMuscleGroup.lowercased() == muscle.rawValue }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(muscle.displayName)
                    .font(.title).bold()
                    .foregroundColor(.white)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.black.opacity(0.3))
            
            ScrollView {
                VStack(spacing: 16) {
                    if exercises.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "dumbbell")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No exercises found for \(muscle.displayName)")
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 40)
                    } else {
                        ForEach(exercises) { exercise in
                            ExerciseRow(exercise: exercise)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all))
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    
    var body: some View {
        HStack(spacing: 16) {
            // Thumbnail
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                if let thumb = exercise.thumbnailUrl {
                    AsyncImage(url: URL(string: thumb)) { img in
                        img.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
                } else {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .foregroundColor(.blue)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.exerciseName)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(exercise.primaryMuscleGroup)
                    .font(.caption)
                    .foregroundColor(.blue)
                
                if let equipment = exercise.requiredEquipment {
                    Text(equipment)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "plus.circle")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}

