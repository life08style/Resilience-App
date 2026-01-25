import SwiftUI
import SwiftData

struct EditSleepScheduleView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var schedule: SleepSchedule? // If nil, we're creating a new one
    
    @State private var name: String = ""
    @State private var bedtime: Date = Date()
    @State private var wakeTime: Date = Date()
    @State private var selectedDays: Set<String> = []
    @State private var isEnabled: Bool = true
    
    // Feature Toggles & New Properties
    @State private var offTaskType: String = "none"
    @State private var taskDifficulty: String = "medium"
    @State private var alarmSound: String = "Default"
    @State private var useSmartAlarm = false
    @State private var syncToCalendar = false
    
    let daysOfWeek = [
        ("S", "Sun"), ("M", "Mon"), ("T", "Tue"), ("W", "Wed"), 
        ("T", "Thu"), ("F", "Fri"), ("S", "Sat")
    ]
    
    var sleepDuration: String {
        let diff = Calendar.current.dateComponents([.hour, .minute], from: bedtime, to: wakeTime)
        var hour = diff.hour ?? 0
        var minute = diff.minute ?? 0
        
        if hour < 0 { hour += 24 }
        if minute < 0 {
            hour -= 1
            minute += 60
        }
        
        return "\(hour)h \(minute)m"
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.gray)
                    
                    Spacer()
                    Text(schedule == nil ? "New Schedule" : "Edit Schedule")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    
                    Button(action: saveSchedule) {
                        Text("Save")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Basic Settings
                        sectionContainer(title: "Basic Settings", icon: "moon.fill", color: .blue) {
                            VStack(alignment: .leading, spacing: 12) {
                                TextField("Schedule Name (e.g., Weekdays)", text: $name)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                                
                                Toggle("Enabled", isOn: $isEnabled)
                                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                            }
                        }
                        
                        // Times
                        sectionContainer(title: "Sleep Times", icon: "clock.fill", color: .blue) {
                            VStack(spacing: 16) {
                                HStack {
                                    timePicker(label: "Bedtime", selection: $bedtime)
                                    Spacer()
                                    timePicker(label: "Wake Up", selection: $wakeTime)
                                }
                                
                                Text("Duration: \(sleepDuration)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        
                        // Days (Highlight in Blue)
                        sectionContainer(title: "Active Days", icon: "calendar", color: .blue) {
                            HStack(spacing: 8) {
                                ForEach(daysOfWeek, id: \.1) { day in
                                    Button(action: {
                                        if selectedDays.contains(day.1) {
                                            selectedDays.remove(day.1)
                                        } else {
                                            selectedDays.insert(day.1)
                                        }
                                    }) {
                                        Text(day.0)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .frame(width: 36, height: 36)
                                            .background(selectedDays.contains(day.1) ? Color.blue : Color.gray.opacity(0.2))
                                            .foregroundColor(.white)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        // Alarm Tasks (Single Line, Blue Selection)
                        sectionContainer(title: "Alarm-Off Task", icon: "target", color: .blue) {
                            VStack(spacing: 16) {
                                HStack(spacing: 12) {
                                    TaskOptionButton(title: "None", icon: "bell.slash", isSelected: offTaskType == "none") {
                                        offTaskType = "none"
                                    }
                                    TaskOptionButton(title: "Math", icon: "plus.forwardslash.minus", isSelected: offTaskType == "math") {
                                        offTaskType = "math"
                                    }
                                    TaskOptionButton(title: "Typing", icon: "keyboard", isSelected: offTaskType == "typing") {
                                        offTaskType = "typing"
                                    }
                                }
                                
                                if offTaskType != "none" {
                                    HStack(spacing: 8) {
                                        DifficultyButton(title: "Easy", isSelected: taskDifficulty == "easy") {
                                            taskDifficulty = "easy"
                                        }
                                        DifficultyButton(title: "Medium", isSelected: taskDifficulty == "medium") {
                                            taskDifficulty = "medium"
                                        }
                                        DifficultyButton(title: "Difficult", isSelected: taskDifficulty == "difficult") {
                                            taskDifficulty = "difficult"
                                        }
                                    }
                                    .transition(.move(edge: .top).combined(with: .opacity))
                                }
                            }
                        }
                        
                        // Sound Selection (2s Demo)
                        sectionContainer(title: "Alarm Sound", icon: "speaker.wave.2.fill", color: .blue) {
                            VStack(spacing: 10) {
                                ForEach(["Classic", "Birdsong", "Digital", "Zen"], id: \.self) { sound in
                                    SoundOptionButton(title: sound, isSelected: alarmSound == sound) {
                                        alarmSound = sound
                                        SoundManager.shared.playSoundPreview(named: sound)
                                    }
                                }
                            }
                        }
                        
                        // Extra Features
                        sectionContainer(title: "Advanced", icon: "sparkles", color: .blue) {
                            VStack(spacing: 16) {
                                Toggle("Smart Alarm", isOn: $useSmartAlarm)
                                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                                
                                if useSmartAlarm {
                                    Text("Alarm will trigger randomly within 30 mins before set time.")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                        .transition(.opacity)
                                }
                                
                                Divider().background(Color.gray.opacity(0.3))
                                
                                Toggle("Sync to Calendar", isOn: $syncToCalendar)
                                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear(perform: loadInitialData)
    }
    
    // MARK: - Helper Views
    
    func sectionContainer<Content: View>(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            content()
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.05), lineWidth: 1))
    }
    
    func timePicker(label: String, selection: Binding<Date>) -> some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            DatePicker("", selection: selection, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .colorScheme(.dark)
        }
    }
    
    // MARK: - Logic
    
    func loadInitialData() {
        if let schedule = schedule {
            name = schedule.name
            bedtime = schedule.bedtime
            wakeTime = schedule.wakeTime
            selectedDays = Set(schedule.days)
            isEnabled = schedule.isEnabled
            offTaskType = schedule.offTaskType
            taskDifficulty = schedule.taskDifficulty
            alarmSound = schedule.alarmSound
            useSmartAlarm = schedule.useSmartAlarm
            syncToCalendar = schedule.syncToCalendar
        }
    }
    
    func saveSchedule() {
        let finalDays = Array(selectedDays)
        
        if let existing = schedule {
            existing.name = name
            existing.bedtime = bedtime
            existing.wakeTime = wakeTime
            existing.days = finalDays
            existing.isEnabled = isEnabled
            existing.offTaskType = offTaskType
            existing.taskDifficulty = taskDifficulty
            existing.alarmSound = alarmSound
            existing.useSmartAlarm = useSmartAlarm
            existing.syncToCalendar = syncToCalendar
        } else {
            let newSchedule = SleepSchedule(
                name: name.isEmpty ? "New Schedule" : name,
                bedtime: bedtime,
                wakeTime: wakeTime,
                days: finalDays,
                isEnabled: isEnabled,
                offTaskType: offTaskType,
                taskDifficulty: taskDifficulty,
                alarmSound: alarmSound,
                useSmartAlarm: useSmartAlarm,
                syncToCalendar: syncToCalendar
            )
            modelContext.insert(newSchedule)
        }
        
        if syncToCalendar {
            // Logic to sync with CalendarView events (simplified)
            print("Syncing sleep blocks to calendar...")
        }
        
        dismiss()
    }
}

// MARK: - Subviews

struct TaskOptionButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .white : .gray)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
            )
        }
    }
}

struct DifficultyButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(8)
        }
    }
}

struct SoundOptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(isSelected ? .white : .gray)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
            )
        }
    }
}
