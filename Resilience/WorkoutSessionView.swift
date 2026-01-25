import SwiftUI
import SwiftData
import Combine

struct WorkoutSessionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var sessionDuration: TimeInterval = 0
    @State private var isPaused = false
    @State private var currentExerciseIndex = 0
    @State private var exercises: [WorkoutExercise] = [
        WorkoutExercise(exerciseId: "1", setsAndReps: "3x10", restTime: 60, setType: "Normal"),
        WorkoutExercise(exerciseId: "2", setsAndReps: "3x12", restTime: 45, setType: "Normal"),
        WorkoutExercise(exerciseId: "3", setsAndReps: "3x15", restTime: 30, setType: "Normal")
    ]
    // Mock exercise names for display
    let exerciseNames = ["Bench Press", "Incline Dumbbell Press", "Cable Flyes"]
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar: Timer and Controls
            HStack {
                VStack(alignment: .leading) {
                    Text("Chest Day")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(formatDuration(sessionDuration))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .monospacedDigit()
                }
                
                Spacer()
                
                Button(action: { 
                    isPaused.toggle() 
                    HapticManager.shared.impact(style: .medium)
                }) {
                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(isPaused ? DesignSystem.Colors.success : DesignSystem.Colors.warning)
                        .clipShape(Circle())
                }
                
                Button(action: {
                    HapticManager.shared.notification(type: .success)
                    finishWorkout()
                }) {
                    Text("Finish")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(DesignSystem.Colors.error)
                        .cornerRadius(20)
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6).opacity(0.2))
            
            // Current Exercise View
            ScrollView {
                VStack(spacing: 24) {
                    // Exercise Header
                    HStack {
                        Text(exerciseNames[currentExerciseIndex])
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Sets List
                    VStack(spacing: 12) {
                        ForEach(0..<3) { setIndex in
                            SetRow(setNumber: setIndex + 1, target: "10 reps", prev: "100kg x 10")
                        }
                    }
                    .padding(.horizontal)
                    
                    // Navigation
                    HStack {
                        Button(action: { if currentExerciseIndex > 0 { currentExerciseIndex -= 1 } }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Previous")
                            }
                            .foregroundColor(currentExerciseIndex > 0 ? .white : .gray)
                        }
                        .disabled(currentExerciseIndex == 0)
                        
                        Spacer()
                        
                        Button(action: { if currentExerciseIndex < exercises.count - 1 { currentExerciseIndex += 1 } }) {
                            HStack {
                                Text("Next Exercise")
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(currentExerciseIndex < exercises.count - 1 ? .white : .gray)
                        }
                        .disabled(currentExerciseIndex == exercises.count - 1)
                    }
                    .padding()
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onReceive(timer) { _ in
            if !isPaused {
                sessionDuration += 1
            }
        }
    }
    
    func formatDuration(_ totalSeconds: TimeInterval) -> String {
        let hours = Int(totalSeconds) / 3600
        let minutes = Int(totalSeconds) / 60 % 60
        let seconds = Int(totalSeconds) % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func finishWorkout() {
        let session = WorkoutSession(
            workoutId: "mock_workout_id",
            workoutName: "Chest Day",
            dateCompleted: Date(),
            exercisesCompleted: [], // Would populate with actual data
            totalVolume: 5000,
            durationMinutes: sessionDuration / 60,
            status: "completed"
        )
        modelContext.insert(session)
        dismiss()
    }
}

struct SetRow: View {
    let setNumber: Int
    let target: String
    let prev: String
    @State private var weight = ""
    @State private var reps = ""
    @State private var isCompleted = false
    
    var body: some View {
        HStack(spacing: 12) {
            Text("\(setNumber)")
                .font(.headline)
                .foregroundColor(.gray)
                .frame(width: 24)
            
            VStack(alignment: .leading) {
                Text("Previous")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(prev)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .frame(width: 80, alignment: .leading)
            
            TextField("kg", text: $weight)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .padding(8)
                .background(Color(UIColor.systemGray6).opacity(0.3))
                .cornerRadius(8)
                .foregroundColor(.white)
                .frame(width: 70)
            
            TextField("reps", text: $reps)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .padding(8)
                .background(Color(UIColor.systemGray6).opacity(0.3))
                .cornerRadius(8)
                .foregroundColor(.white)
                .frame(width: 60)
            
            Button(action: { isCompleted.toggle() }) {
                Image(systemName: isCompleted ? "checkmark.square.fill" : "square")
                    .font(.title2)
                    .foregroundColor(isCompleted ? .green : .gray)
            }
        }
        .padding()
        .background(isCompleted ? Color.green.opacity(0.1) : Color(UIColor.systemGray6).opacity(0.1))
        .cornerRadius(12)
    }
}
