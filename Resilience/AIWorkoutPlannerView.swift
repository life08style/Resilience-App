import SwiftUI

struct AIWorkoutPlannerView: View {
    @State private var goal = "" 
    @State private var duration = 4.0
    @State private var workoutsPerWeek = 3.0
    @State private var isGenerating = false
    @State private var generatedPlan: AIWorkoutPlan?
    @State private var showError = false
    @State private var errorMessage = ""
    
    // Computed property to satisfy legacy uses if any
    private var userGoal: String {
        get { goal }
        set { goal = newValue }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("AI Workout Planner")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Personalized plans powered by Gemini")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top)
                
                // Input Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("What is your primary fitness goal?")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    TextField("e.g., Build muscle, Run a marathon...", text: $goal)
                        .padding()
                        .background(Color(UIColor.systemGray6).opacity(0.2))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                    
                    Button(action: generatePlan) {
                        HStack {
                            if isGenerating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "wand.and.stars")
                                Text("Generate Plan")
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(goal.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(16)
                    }
                    .disabled(goal.isEmpty || isGenerating)
                }
                .padding()
                .background(Color(UIColor.systemGray6).opacity(0.1))
                .cornerRadius(20)
                .padding(.horizontal)
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding()
                }
                
                // Result Section
                if let plan = generatedPlan {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Your Custom Plan")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        PlanSummaryCard(plan: plan)
                        
                        Text("Weekly Schedule")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        ForEach(plan.weeklySchedule, id: \.day) { day in
                            DayPlanRow(day: day)
                        }
                    }
                    .padding()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.bottom)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationTitle("Planner")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func generatePlan() {
        isGenerating = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isGenerating = false
            generatedPlan = AIWorkoutPlan(
                id: UUID(),
                planName: "\(goal) Accelerator",
                goal: goal,
                durationWeeks: Int(duration),
                workoutsPerWeek: Int(workoutsPerWeek),
                workoutDurationMinutes: 45,
                weeklySchedule: [
                    WeeklyWorkout(day: "Monday", workoutName: "Full Body Strength", exercises: [], notes: ""),
                    WeeklyWorkout(day: "Wednesday", workoutName: "HIIT Cardio", exercises: [], notes: ""),
                    WeeklyWorkout(day: "Friday", workoutName: "Lower Body Power", exercises: [], notes: "")
                ],
                isActive: true,
                startDate: Date()
            )
        }
    }
}

struct PlanSummaryCard: View {
    let plan: AIWorkoutPlan
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(plan.planName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
            }
            
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Duration")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(plan.durationWeeks) weeks")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading) {
                    Text("Frequency")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(plan.workoutsPerWeek) / week")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading) {
                    Text("Goal")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(plan.goal)
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.15))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct DayPlanRow: View {
    let day: WeeklyWorkout
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(day.day)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text(day.workoutName)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.1))
        .cornerRadius(12)
    }
}
