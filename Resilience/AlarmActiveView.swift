import SwiftUI

struct AlarmActiveView: View {
    let schedule: SleepSchedule
    @Environment(\.dismiss) var dismiss
    
    @State private var mathProblem: String = ""
    @State private var mathAnswer: Int = 0
    @State private var userInput: String = ""
    @State private var typingTarget: String = ""
    @State private var isCompleted: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Text("WAKE UP!")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundColor(.red)
                
                Text(schedule.name)
                    .font(.title2)
                    .foregroundColor(.white)
                
                if schedule.offTaskType == "math" {
                    mathTaskView
                } else if schedule.offTaskType == "typing" {
                    typingTaskView
                } else {
                    simpleDismissView
                }
                
                if isCompleted {
                    Button(action: {
                        SoundManager.shared.stopAlarm()
                        dismiss()
                    }) {
                        Text("DISMISS ALARM")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .onAppear {
            generateTask()
            SoundManager.shared.playAlarm(named: schedule.alarmSound)
        }
    }
    
    var mathTaskView: some View {
        VStack(spacing: 20) {
            Text("Solve this to dismiss:")
                .foregroundColor(.gray)
            
            Text(mathProblem)
                .font(.system(size: 64, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
            
            TextField("Answer", text: $userInput)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.title)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .foregroundColor(.white)
                .onChange(of: userInput) { _, newValue in
                    if Int(newValue) == mathAnswer {
                        isCompleted = true
                    }
                }
        }
    }
    
    var typingTaskView: some View {
        VStack(spacing: 20) {
            Text("Type exactly to dismiss:")
                .foregroundColor(.gray)
            
            Text(typingTarget)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            
            TextField("Type here...", text: $userInput)
                .multilineTextAlignment(.center)
                .font(.body)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .foregroundColor(.white)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onChange(of: userInput) { _, newValue in
                    if newValue.lowercased() == typingTarget.lowercased() {
                        isCompleted = true
                    }
                }
        }
    }
    
    var simpleDismissView: some View {
        Button(action: {
            isCompleted = true
        }) {
            Text("Tap to Dismiss")
                .foregroundColor(.gray)
        }
    }
    
    func generateTask() {
        if schedule.offTaskType == "math" {
            let difficulty = schedule.taskDifficulty.lowercased()
            let a: Int
            let b: Int
            
            if difficulty == "easy" {
                a = Int.random(in: 1...10)
                b = Int.random(in: 1...10)
            } else if difficulty == "difficult" {
                a = Int.random(in: 10...50)
                b = Int.random(in: 10...50)
            } else {
                a = Int.random(in: 5...25)
                b = Int.random(in: 5...25)
            }
            
            mathProblem = "\(a) + \(b) ="
            mathAnswer = a + b
        } else if schedule.offTaskType == "typing" {
            let sentences = [
                "The quick brown fox jumps over the lazy dog.",
                "Consistency is the key to building real momentum.",
                "Success is not final, failure is not fatal.",
                "Wake up and crush your goals for today!"
            ]
            typingTarget = sentences.randomElement() ?? "Consistency builds momentum."
        }
    }
}
