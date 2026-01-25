import SwiftUI

struct WorkoutBuilderView: View {
    @State private var workoutName = ""
    @State private var selectedExercises: [String] = []
    @State private var showExercisePicker = false
    
    let muscleGroups = [
        "Chest": ["Pushups", "Bench Press", "Flyes"],
        "Back": ["Pullups", "Rows", "Lat Pulldown"],
        "Legs": ["Squats", "Lunges", "Leg Press"],
        "Core": ["Plank", "Crunches", "Leg Raises"]
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading) {
                    Text("Build Custom Workout")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Design your perfect routine")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Name Input
                TextField("Workout Name (e.g., Leg Day)", text: $workoutName)
                    .padding()
                    .background(Color(UIColor.systemGray6).opacity(0.2))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                // Selected Exercises List
                if !selectedExercises.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Exercises")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        ForEach(Array(selectedExercises.enumerated()), id: \.offset) { index, exercise in
                            HStack {
                                Text("\(index + 1).")
                                    .foregroundColor(.gray)
                                    .frame(width: 24)
                                Text(exercise)
                                    .foregroundColor(.white)
                                Spacer()
                                Button(action: { selectedExercises.remove(at: index) }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6).opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Add Button
                Button(action: { showExercisePicker = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Exercise")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                }
                .padding(.horizontal)
                
                // Save Button
                Button(action: saveWorkout) {
                    Text("Save Workout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .disabled(workoutName.isEmpty || selectedExercises.isEmpty)
                .opacity(workoutName.isEmpty || selectedExercises.isEmpty ? 0.5 : 1)
            }
            .padding(.vertical)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showExercisePicker) {
            ExercisePickerSheet(muscleGroups: muscleGroups) { exercise in
                selectedExercises.append(exercise)
                showExercisePicker = false
            }
        }
    }
    
    func saveWorkout() {
        // Save logic here
        print("Saved workout: \(workoutName) with \(selectedExercises.count) exercises")
    }
}

struct ExercisePickerSheet: View {
    let muscleGroups: [String: [String]]
    var onSelect: (String) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(muscleGroups.keys.sorted(), id: \.self) { group in
                    Section(header: Text(group)) {
                        ForEach(muscleGroups[group] ?? [], id: \.self) { exercise in
                            Button(action: { onSelect(exercise) }) {
                                Text(exercise)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Exercise")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
