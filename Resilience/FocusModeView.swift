import SwiftUI
import SwiftData
import UserNotifications
import Combine

struct FocusModeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    
    @Query(sort: \TodoItem.order) private var todos: [TodoItem]
    
    @State private var sessionDuration: Double = 25 // Minutes
    @State private var timeRemaining: TimeInterval = 25 * 60
    @State private var isActive = false
    @State private var showGiveUpAlert = false
    @State private var giveUpStep = 0
    @State private var showMusicSheet = false
    @State private var showAlertNotify = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Background
            DesignSystem.Colors.background.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                // Header
                headerView
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Timer Circle
                        timerSection
                        
                        // Tasks List
                        tasksSection
                        
                        // Music Access
                        musicAccessSection
                    }
                    .padding()
                }
                
                // Bottom Controls
                bottomControls
            }
        }
        .onAppear {
            requestNotificationPermission()
            resetTimer()
        }
        .onReceive(timer) { _ in
            if isActive && timeRemaining > 0 {
                timeRemaining -= 1
            } else if isActive && timeRemaining == 0 {
                isActive = false
                HapticManager.shared.notification(type: .success)
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if isActive && (newPhase == .background || newPhase == .inactive) {
                // User attempted to leave the app!
                triggerAmberAlert()
            }
        }
        // Comical Give Up Alerts
        .alert("Are you reaching for the chips?", isPresented: $showGiveUpAlert) {
            Button("I'm Staying", role: .cancel) { giveUpStep = 0 }
            Button("Yes, I'm weak", role: .destructive) {
                giveUpStep = 2
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showGiveUpAlert = true 
                }
            }
        } message: {
            Text("Your future self is watching. Don't let them down.")
        }
        // Second Alert (Simulated via overlay or subsequent state if possible)
        // Note: SwiftUI multiple alerts can be tricky, using a state machine for alerts.
        .overlay {
            if giveUpStep == 2 {
                Color.clear.alert("Weakness is not an option...", isPresented: .constant(true)) {
                    Button("I'll Win", role: .cancel) { giveUpStep = 0 }
                    Button("I'm a quitter", role: .destructive) {
                        giveUpStep = 3
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showGiveUpAlert = true
                        }
                    }
                } message: {
                    Text("Blu is crying. Do you really want to see a mascot cry?")
                }
            } else if giveUpStep == 3 {
                Color.clear.alert("Last chance to stay a winner!", isPresented: .constant(true)) {
                    Button("Finish Strong", role: .cancel) { giveUpStep = 0 }
                    Button("I Give Up", role: .destructive) {
                        isActive = false
                        dismiss()
                    }
                } message: {
                    Text("If you quit now, the ghosts of productivity will haunt you forever.")
                }
            }
        }
        .sheet(isPresented: $showMusicSheet) {
            NavigationView {
                MusicLibraryView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") { showMusicSheet = false }
                        }
                    }
            }
        }
    }
    
    // MARK: - Components
    
    private var headerView: some View {
        HStack {
            Button(action: { 
                if isActive {
                    showGiveUpAlert = true
                    giveUpStep = 1
                } else {
                    dismiss()
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("FOCUS MODE")
                .font(.headline)
                .tracking(2)
                .foregroundColor(.white)
            
            Spacer()
            
            Circle()
                .fill(isActive ? Color.green : Color.gray)
                .frame(width: 10, height: 10)
                .shadow(color: isActive ? .green : .clear, radius: 4)
        }
        .padding()
    }
    
    private var timerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 8)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining / (sessionDuration * 60)))
                    .stroke(
                        LinearGradient(colors: [.purple, .blue], startPoint: .top, endPoint: .bottom),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear, value: timeRemaining)
                
                VStack {
                    Text(formatTime(timeRemaining))
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Text(isActive ? "STAY FOCUSED" : "READY?")
                        .font(.caption)
                        .fontWeight(.black)
                        .foregroundColor(.gray)
                }
            }
            
            if !isActive {
                HStack {
                    Text("Duration:")
                        .foregroundColor(.gray)
                    Slider(value: $sessionDuration, in: 5...120, step: 5)
                        .accentColor(.purple)
                        .onChange(of: sessionDuration) { old, new in resetTimer() }
                    Text("\(Int(sessionDuration))m")
                        .foregroundColor(.white)
                        .bold()
                        .frame(width: 45)
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("CURRENT GOALS")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            if todos.isEmpty {
                Text("No tasks for today. Focus on the void.")
                    .font(.subheadline)
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                VStack(spacing: 12) {
                    ForEach(todos.prefix(isActive ? 3 : 10)) { todo in
                        HStack {
                            Button(action: { toggleTodo(todo) }) {
                                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(todo.isCompleted ? .green : .purple)
                            }
                            
                            Text(todo.text)
                                .strikethrough(todo.isCompleted)
                                .foregroundColor(todo.isCompleted ? .gray : .white)
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var musicAccessSection: some View {
        Button(action: { showMusicSheet = true }) {
            HStack {
                Image(systemName: "music.note.list")
                Text("Select Focus Music")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(16)
            .foregroundColor(.white)
        }
    }
    
    private var bottomControls: some View {
        Group {
            if !isActive {
                Button(action: {
                    isActive = true
                    HapticManager.shared.impact(style: .heavy)
                }) {
                    Text("START FLOW")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding()
                }
            } else {
                Text("SESSION IN PROGRESS")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
                    .padding()
            }
        }
    }
    
    // MARK: - Logic
    
    func formatTime(_ seconds: TimeInterval) -> String {
        let m = Int(seconds) / 60
        let s = Int(seconds) % 60
        return String(format: "%02d:%02d", m, s)
    }
    
    func resetTimer() {
        timeRemaining = sessionDuration * 60
    }
    
    func toggleTodo(_ todo: TodoItem) {
        todo.isCompleted.toggle()
        HapticManager.shared.impact(style: .light)
        try? modelContext.save()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error { print("Notification Error: \(error)") }
        }
    }
    
    func triggerAmberAlert() {
        // Since we can't play sound *immediately* from background without specific setups,
        // we use a critical notification or recurring alerts.
        let content = UNMutableNotificationContent()
        content.title = "🚨 AMBER ALERT: FOCUS BREACHED 🚨"
        content.body = "GET BACK INTO THE APP NOW! YOUR FOCUS IS AT RISK!"
        content.sound = .defaultCritical // Use a loud sound if possible
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
        // In a real device scenario, we'd also play a loop if we had background audio enabled.
        // For this app, we emphasize the notification.
    }
}

#Preview {
    FocusModeView()
}
