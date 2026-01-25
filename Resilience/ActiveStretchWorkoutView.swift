import SwiftUI

struct StretchStep: Identifiable {
    let id = UUID()
    let name: String
    let duration: Int // seconds
    let imageUrl: String?
}

struct ActiveStretchWorkoutView: View {
    let workout: StretchWorkout
    @Environment(\.presentationMode) var presentationMode
    
    // Mock steps
    let steps: [StretchStep] = [
        StretchStep(name: "Neck Roll", duration: 30, imageUrl: nil),
        StretchStep(name: "Shoulder Shrugs", duration: 45, imageUrl: nil),
        StretchStep(name: "Arm Circles", duration: 45, imageUrl: nil),
        StretchStep(name: "Torso Twist", duration: 60, imageUrl: nil)
    ]
    
    @State private var currentStepIndex = 0
    @State private var timeLeft: Int = 30
    @State private var isPaused = false
    @State private var isMuted = false
    @State private var timer: Timer?
    
    var currentStep: StretchStep {
        steps[currentStepIndex]
    }
    
    var progress: Double {
        Double(timeLeft) / Double(currentStep.duration)
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).opacity(0.1).edgesIgnoringSafeArea(.all)
                .background(Color.black)
            
            VStack {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    Text(workout.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    
                    Button(action: { isMuted.toggle() }) {
                        Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                
                Spacer()
                
                // Timer Circle
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                        .frame(width: 250, height: 250)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(progress))
                        .stroke(Color.teal, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .frame(width: 250, height: 250)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: timeLeft)
                    
                    VStack {
                        Text("\(timeLeft)")
                            .font(.system(size: 70, weight: .bold))
                            .foregroundColor(.white)
                        Text("seconds")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 40)
                
                Text(currentStep.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                // Image Placeholder
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.systemGray6).opacity(0.3))
                    .frame(height: 200)
                    .overlay(
                        VStack {
                            Image(systemName: "figure.flexibility")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("Demonstration")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    )
                    .padding(.horizontal)
                
                Spacer()
                
                // Controls
                HStack(spacing: 40) {
                    Button(action: skipPrevious) {
                        Image(systemName: "backward.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                    }
                    
                    Button(action: togglePause) {
                        Image(systemName: isPaused ? "play.fill" : "pause.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(Color.teal)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    
                    Button(action: skipNext) {
                        Image(systemName: "forward.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if !isPaused {
                if timeLeft > 0 {
                    timeLeft -= 1
                } else {
                    skipNext()
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func togglePause() {
        isPaused.toggle()
    }
    
    func skipNext() {
        if currentStepIndex < steps.count - 1 {
            currentStepIndex += 1
            timeLeft = steps[currentStepIndex].duration
        } else {
            // Workout Complete
            stopTimer()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func skipPrevious() {
        if currentStepIndex > 0 {
            currentStepIndex -= 1
            timeLeft = steps[currentStepIndex].duration
        } else {
            timeLeft = steps[0].duration
        }
    }
}
