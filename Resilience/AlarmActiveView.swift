import SwiftUI

struct AlarmActiveView: View {
    let schedule: SleepSchedule
    @Environment(\.dismiss) var dismiss
    
    @State private var mathProblem: String = ""
    @State private var mathAnswer: Int = 0
    @State private var userInput: String = ""
    @State private var typingTarget: String = ""
    @State private var isCompleted: Bool = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.3
    @State private var shakeOffset: CGFloat = 0
    @State private var wrongAnswer: Bool = false
    @State private var slideOffset: CGFloat = 0
    @State private var slideCompleted: Bool = false
    
    private let slideThreshold: CGFloat = 200
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                colors: [Color.black, Color(red: 0.15, green: 0, blue: 0), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // Pulsing glow
            Circle()
                .fill(Color.red.opacity(glowOpacity))
                .frame(width: 300, height: 300)
                .blur(radius: 100)
                .scaleEffect(pulseScale)
            
            VStack(spacing: 32) {
                Spacer()
                
                // Alarm icon
                Image(systemName: "alarm.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                    .scaleEffect(pulseScale)
                    .shadow(color: .red.opacity(0.6), radius: 20)
                
                // WAKE UP header
                Text("WAKE UP!")
                    .font(.system(size: 52, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
                    )
                    .scaleEffect(pulseScale)
                
                // Current time
                Text(currentTimeString)
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                
                // Schedule name
                if !schedule.name.isEmpty {
                    Text(schedule.name)
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
                
                // Challenge area
                if schedule.offTaskType == "math" {
                    mathTaskView
                } else if schedule.offTaskType == "typing" {
                    typingTaskView
                } else {
                    slideToDismissView
                }
                
                // Dismiss button (only shown after puzzle solved)
                if isCompleted {
                    Button(action: {
                        AlarmManager.shared.dismissAlarm()
                        dismiss()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                            Text("ALARM DISMISSED")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(colors: [.green, .green.opacity(0.7)], startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(16)
                        .shadow(color: .green.opacity(0.5), radius: 10, y: 4)
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                // Snooze button (always available)
                if !isCompleted {
                    Button(action: {
                        AlarmManager.shared.snoozeAlarm()
                        dismiss()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "zzz")
                            Text("Snooze 5 min")
                                .fontWeight(.medium)
                        }
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.5))
                        .padding()
                    }
                }
                
                Spacer().frame(height: 20)
            }
            .padding()
        }
        .onAppear {
            generateTask()
            startPulseAnimation()
            // Sound is started by AlarmManager, but ensure it's playing
            if !SoundManager.shared.isAlarmPlaying {
                SoundManager.shared.playAlarm(named: schedule.alarmSound)
            }
        }
        .interactiveDismissDisabled(!isCompleted && schedule.offTaskType != "none")
    }
    
    // MARK: - Current Time
    
    private var currentTimeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
    
    // MARK: - Math Task
    
    var mathTaskView: some View {
        VStack(spacing: 20) {
            Text("Solve to dismiss")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            // Math problem display
            Text(mathProblem)
                .font(.system(size: 56, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .offset(x: shakeOffset)
            
            // Answer input
            TextField("?", text: $userInput)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .padding()
                .frame(height: 70)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(wrongAnswer ? Color.red.opacity(0.15) : Color.white.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(wrongAnswer ? Color.red.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 2)
                        )
                )
                .foregroundColor(.white)
                .onChange(of: userInput) { _, newValue in
                    if let answer = Int(newValue) {
                        if answer == mathAnswer {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                isCompleted = true
                                wrongAnswer = false
                            }
                            SoundManager.shared.stopAlarm()
                            HapticManager.shared.notification(type: .success)
                        } else if newValue.count >= String(mathAnswer).count {
                            // Wrong answer shake
                            wrongAnswer = true
                            HapticManager.shared.notification(type: .error)
                            withAnimation(.spring(response: 0.1, dampingFraction: 0.2)) {
                                shakeOffset = 15
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.spring(response: 0.1, dampingFraction: 0.2)) {
                                    shakeOffset = -15
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.spring(response: 0.1, dampingFraction: 0.5)) {
                                    shakeOffset = 0
                                }
                            }
                            // Clear after shake
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                userInput = ""
                                wrongAnswer = false
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
        }
        .padding()
        .background(Color.white.opacity(0.03))
        .cornerRadius(24)
        .padding(.horizontal)
    }
    
    // MARK: - Typing Task
    
    var typingTaskView: some View {
        VStack(spacing: 20) {
            Text("Type exactly to dismiss")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            // Target sentence
            Text(typingTarget)
                .font(.body)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.08))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
            
            // Progress indicator
            if !userInput.isEmpty {
                let progress = min(Double(userInput.count) / Double(typingTarget.count), 1.0)
                ProgressView(value: progress)
                    .tint(matchesSoFar ? .green : .red)
                    .animation(.easeInOut, value: progress)
            }
            
            // Input field
            TextField("Type here...", text: $userInput)
                .multilineTextAlignment(.center)
                .font(.body)
                .padding()
                .background(Color.white.opacity(0.08))
                .cornerRadius(12)
                .foregroundColor(.white)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onChange(of: userInput) { _, newValue in
                    if newValue.lowercased() == typingTarget.lowercased() {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            isCompleted = true
                        }
                        SoundManager.shared.stopAlarm()
                        HapticManager.shared.notification(type: .success)
                    }
                }
        }
        .padding()
        .background(Color.white.opacity(0.03))
        .cornerRadius(24)
        .padding(.horizontal)
    }
    
    private var matchesSoFar: Bool {
        typingTarget.lowercased().hasPrefix(userInput.lowercased())
    }
    
    // MARK: - Slide to Dismiss (no puzzle)
    
    var slideToDismissView: some View {
        ZStack(alignment: .leading) {
            // Track
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.white.opacity(0.06))
                .frame(height: 70)
                .overlay(
                    Text("Slide to dismiss →")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.3))
                )
            
            // Thumb
            Circle()
                .fill(
                    LinearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "alarm.fill")
                        .foregroundColor(.white)
                        .font(.title3)
                )
                .shadow(color: .red.opacity(0.4), radius: 8)
                .offset(x: slideOffset + 5)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.width > 0 {
                                slideOffset = min(value.translation.width, slideThreshold)
                            }
                        }
                        .onEnded { value in
                            if slideOffset >= slideThreshold {
                                withAnimation {
                                    slideCompleted = true
                                    isCompleted = true
                                }
                                SoundManager.shared.stopAlarm()
                                HapticManager.shared.notification(type: .success)
                                // Auto dismiss after a moment
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    AlarmManager.shared.dismissAlarm()
                                    dismiss()
                                }
                            } else {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    slideOffset = 0
                                }
                            }
                        }
                )
        }
        .padding(.horizontal, 30)
    }
    
    // MARK: - Animations
    
    func startPulseAnimation() {
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.15
            glowOpacity = 0.6
        }
    }
    
    // MARK: - Task Generation
    
    func generateTask() {
        if schedule.offTaskType == "math" {
            let difficulty = schedule.taskDifficulty.lowercased()
            let a: Int
            let b: Int
            
            switch difficulty {
            case "easy":
                a = Int.random(in: 1...10)
                b = Int.random(in: 1...10)
            case "difficult":
                a = Int.random(in: 10...50)
                b = Int.random(in: 10...50)
            default: // medium
                a = Int.random(in: 5...25)
                b = Int.random(in: 5...25)
            }
            
            mathProblem = "\(a) + \(b) ="
            mathAnswer = a + b
        } else if schedule.offTaskType == "typing" {
            let sentences = [
                "The early bird catches the worm.",
                "Consistency is the key to building real momentum.",
                "Success is not final, failure is not fatal.",
                "Wake up and crush your goals for today!",
                "Every day is a fresh start. Make it count.",
                "Discipline is doing it even when you do not feel like it.",
                "The only way to do great work is to love what you do.",
                "Rise and shine the world is waiting for you."
            ]
            typingTarget = sentences.randomElement() ?? "Wake up and seize the day!"
        }
    }
}
