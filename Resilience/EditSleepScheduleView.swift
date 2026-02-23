import SwiftUI
import SwiftData

// MARK: - 5-Minute Interval Time Picker

struct FiveMinuteTimePicker: View {
    @Binding var selectedHour: Int    // 1–12
    @Binding var selectedMinute: Int  // 0, 5, 10, …, 55
    @Binding var isAM: Bool
    
    private let hours = Array(1...12)
    private let minutes = stride(from: 0, to: 60, by: 5).map { $0 }
    
    var body: some View {
        HStack(spacing: 0) {
            // Hour wheel
            Picker("Hour", selection: $selectedHour) {
                ForEach(hours, id: \.self) { h in
                    Text("\(h)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .tag(h)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 70, height: 160)
            .clipped()
            
            Text(":")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 2)
            
            // Minute wheel (5-min intervals)
            Picker("Minute", selection: $selectedMinute) {
                ForEach(minutes, id: \.self) { m in
                    Text(String(format: "%02d", m))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .tag(m)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 70, height: 160)
            .clipped()
            
            // AM/PM wheel
            Picker("Period", selection: $isAM) {
                Text("AM").tag(true)
                Text("PM").tag(false)
            }
            .pickerStyle(.wheel)
            .frame(width: 65, height: 160)
            .clipped()
        }
        .padding(.vertical, 4)
    }
    
    /// Convert picker state to a Date (today + hour/min)
    static func toDate(hour: Int, minute: Int, isAM: Bool) -> Date {
        var h = hour
        if !isAM && h != 12 { h += 12 }
        if isAM && h == 12 { h = 0 }
        
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = h
        components.minute = minute
        components.second = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    /// Extract picker state from a Date
    static func fromDate(_ date: Date) -> (hour: Int, minute: Int, isAM: Bool) {
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        // Snap minute to nearest 5
        let snappedMinute = (minute / 5) * 5
        
        let isAM = hour < 12
        if hour == 0 { hour = 12 }
        else if hour > 12 { hour -= 12 }
        
        return (hour, snappedMinute, isAM)
    }
}

// MARK: - Edit Sleep Schedule View

struct EditSleepScheduleView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var schedule: SleepSchedule? // If nil, we're creating a new one
    
    @State private var name: String = ""
    @State private var isEnabled: Bool = true
    
    // Bedtime picker state
    @State private var bedHour: Int = 10
    @State private var bedMinute: Int = 0
    @State private var bedIsAM: Bool = false // 10 PM default
    
    // Wake time picker state
    @State private var wakeHour: Int = 7
    @State private var wakeMinute: Int = 0
    @State private var wakeIsAM: Bool = true // 7 AM default
    
    // Days
    @State private var selectedDays: Set<String> = []
    
    // Alarm sound
    @State private var alarmSoundId: String = "default"
    @State private var showSoundPicker: Bool = false
    
    // Active wakeup
    @State private var offTaskType: String = "none"
    @State private var taskDifficulty: String = "medium"
    
    // Advanced
    @State private var useSmartAlarm = false
    @State private var syncToCalendar = false
    
    let daysOfWeek = [
        ("S", "Sun"), ("M", "Mon"), ("T", "Tue"), ("W", "Wed"),
        ("T", "Thu"), ("F", "Fri"), ("S", "Sat")
    ]
    
    var sleepDurationText: String {
        let bed = FiveMinuteTimePicker.toDate(hour: bedHour, minute: bedMinute, isAM: bedIsAM)
        var wake = FiveMinuteTimePicker.toDate(hour: wakeHour, minute: wakeMinute, isAM: wakeIsAM)
        
        if wake <= bed { wake = wake.addingTimeInterval(24 * 3600) }
        
        let diff = Calendar.current.dateComponents([.hour, .minute], from: bed, to: wake)
        return "\(diff.hour ?? 0)h \(diff.minute ?? 0)m"
    }
    
    var selectedSoundName: String {
        SoundManager.alarmSounds.first(where: { $0.id == alarmSoundId })?.name ?? "Classic Alarm"
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
                    Text(schedule == nil ? "New Alarm" : "Edit Alarm")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    
                    Button(action: saveSchedule) {
                        Text("Save")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                LinearGradient(colors: [Color.indigo, Color.purple], startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(20)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Schedule Name
                        sectionContainer(title: "Alarm Name", icon: "tag.fill", color: .indigo) {
                            TextField("e.g., Weekday Alarm", text: $name)
                                .padding()
                                .background(Color.white.opacity(0.06))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        
                        // Wake Time (main alarm time)
                        sectionContainer(title: "Wake Up Time", icon: "sunrise.fill", color: .orange) {
                            VStack(spacing: 12) {
                                FiveMinuteTimePicker(
                                    selectedHour: $wakeHour,
                                    selectedMinute: $wakeMinute,
                                    isAM: $wakeIsAM
                                )
                                .frame(maxWidth: .infinity)
                                
                                // Quick jump buttons
                                HStack(spacing: 8) {
                                    quickTimeButton("6:00 AM", hour: 6, minute: 0, isAM: true, isWake: true)
                                    quickTimeButton("7:00 AM", hour: 7, minute: 0, isAM: true, isWake: true)
                                    quickTimeButton("8:00 AM", hour: 8, minute: 0, isAM: true, isWake: true)
                                    quickTimeButton("9:00 AM", hour: 9, minute: 0, isAM: true, isWake: true)
                                }
                            }
                        }
                        
                        // Bedtime
                        sectionContainer(title: "Bedtime", icon: "moon.fill", color: .indigo) {
                            VStack(spacing: 12) {
                                FiveMinuteTimePicker(
                                    selectedHour: $bedHour,
                                    selectedMinute: $bedMinute,
                                    isAM: $bedIsAM
                                )
                                .frame(maxWidth: .infinity)
                                
                                // Sleep duration badge
                                HStack {
                                    Image(systemName: "bed.double.fill")
                                        .foregroundColor(.indigo)
                                    Text("Sleep Duration: \(sleepDurationText)")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color.indigo.opacity(0.15))
                                .cornerRadius(10)
                            }
                        }
                        
                        // Active Days
                        sectionContainer(title: "Repeat", icon: "calendar", color: .blue) {
                            VStack(spacing: 12) {
                                HStack(spacing: 8) {
                                    ForEach(daysOfWeek, id: \.1) { day in
                                        Button(action: {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                if selectedDays.contains(day.1) {
                                                    selectedDays.remove(day.1)
                                                } else {
                                                    selectedDays.insert(day.1)
                                                }
                                            }
                                            HapticManager.shared.impact(style: .light)
                                        }) {
                                            Text(day.0)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .frame(width: 38, height: 38)
                                                .background(
                                                    selectedDays.contains(day.1)
                                                    ? LinearGradient(colors: [.blue, .indigo], startPoint: .top, endPoint: .bottom)
                                                    : LinearGradient(colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                                                )
                                                .foregroundColor(.white)
                                                .clipShape(Circle())
                                                .scaleEffect(selectedDays.contains(day.1) ? 1.05 : 1.0)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Quick select buttons
                                HStack(spacing: 8) {
                                    quickDayButton("Weekdays") {
                                        selectedDays = Set(["Mon", "Tue", "Wed", "Thu", "Fri"])
                                    }
                                    quickDayButton("Weekends") {
                                        selectedDays = Set(["Sat", "Sun"])
                                    }
                                    quickDayButton("Every Day") {
                                        selectedDays = Set(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"])
                                    }
                                }
                            }
                        }
                        
                        // Alarm Sound
                        sectionContainer(title: "Alarm Sound", icon: "speaker.wave.2.fill", color: .purple) {
                            Button(action: {
                                showSoundPicker = true
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(selectedSoundName)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("Tap to change")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    
                                    // Preview button
                                    Button(action: {
                                        SoundManager.shared.playSoundPreview(named: alarmSoundId)
                                        HapticManager.shared.impact(style: .light)
                                    }) {
                                        Image(systemName: "play.circle.fill")
                                            .font(.system(size: 32))
                                            .foregroundColor(.purple)
                                    }
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white.opacity(0.04))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                                )
                            }
                        }
                        
                        // Active Wakeup
                        sectionContainer(title: "Active Wakeup", icon: "brain.head.profile", color: .orange) {
                            VStack(spacing: 16) {
                                Text("Require solving a challenge before dismissing the alarm — great for heavy sleepers!")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack(spacing: 12) {
                                    TaskOptionButton(title: "None", icon: "bell.slash", isSelected: offTaskType == "none") {
                                        withAnimation { offTaskType = "none" }
                                        HapticManager.shared.impact(style: .light)
                                    }
                                    TaskOptionButton(title: "Math", icon: "plus.forwardslash.minus", isSelected: offTaskType == "math") {
                                        withAnimation { offTaskType = "math" }
                                        HapticManager.shared.impact(style: .light)
                                    }
                                    TaskOptionButton(title: "Typing", icon: "keyboard", isSelected: offTaskType == "typing") {
                                        withAnimation { offTaskType = "typing" }
                                        HapticManager.shared.impact(style: .light)
                                    }
                                }
                                
                                if offTaskType != "none" {
                                    VStack(spacing: 10) {
                                        Text("Difficulty")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        HStack(spacing: 8) {
                                            DifficultyButton(title: "Easy", isSelected: taskDifficulty == "easy") {
                                                taskDifficulty = "easy"
                                                HapticManager.shared.impact(style: .light)
                                            }
                                            DifficultyButton(title: "Medium", isSelected: taskDifficulty == "medium") {
                                                taskDifficulty = "medium"
                                                HapticManager.shared.impact(style: .light)
                                            }
                                            DifficultyButton(title: "Hard", isSelected: taskDifficulty == "difficult") {
                                                taskDifficulty = "difficult"
                                                HapticManager.shared.impact(style: .light)
                                            }
                                        }
                                        
                                        // Preview of what the challenge looks like
                                        if offTaskType == "math" {
                                            HStack(spacing: 8) {
                                                Image(systemName: "info.circle")
                                                    .foregroundColor(.orange.opacity(0.7))
                                                Text(mathPreviewText)
                                                    .font(.caption2)
                                                    .foregroundColor(.orange.opacity(0.7))
                                            }
                                            .padding(8)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.orange.opacity(0.08))
                                            .cornerRadius(8)
                                        } else if offTaskType == "typing" {
                                            HStack(spacing: 8) {
                                                Image(systemName: "info.circle")
                                                    .foregroundColor(.orange.opacity(0.7))
                                                Text("You'll need to type a motivational sentence to dismiss")
                                                    .font(.caption2)
                                                    .foregroundColor(.orange.opacity(0.7))
                                            }
                                            .padding(8)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.orange.opacity(0.08))
                                            .cornerRadius(8)
                                        }
                                    }
                                    .transition(.move(edge: .top).combined(with: .opacity))
                                }
                            }
                        }
                        
                        // Advanced
                        sectionContainer(title: "Advanced", icon: "gearshape.fill", color: .gray) {
                            VStack(spacing: 16) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Smart Alarm")
                                            .foregroundColor(.white)
                                        Text("Triggers randomly within 30 min before set time")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Toggle("", isOn: $useSmartAlarm)
                                        .labelsHidden()
                                        .tint(.indigo)
                                }
                                
                                Divider().background(Color.gray.opacity(0.3))
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Sync to Calendar")
                                            .foregroundColor(.white)
                                        Text("Add sleep blocks to your daily calendar")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Toggle("", isOn: $syncToCalendar)
                                        .labelsHidden()
                                        .tint(.indigo)
                                }
                            }
                        }
                        
                        // Delete button (only for existing schedules)
                        if schedule != nil {
                            Button(action: deleteSchedule) {
                                HStack {
                                    Image(systemName: "trash.fill")
                                    Text("Delete Alarm")
                                }
                                .font(.headline)
                                .foregroundColor(.red)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        
                        Spacer().frame(height: 40)
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showSoundPicker) {
            AlarmSoundsView(selectedSoundId: $alarmSoundId)
        }
        .onAppear(perform: loadInitialData)
    }
    
    // MARK: - Helper Views
    
    private var mathPreviewText: String {
        switch taskDifficulty {
        case "easy": return "e.g. \"3 + 5 = ?\" — simple single-digit addition"
        case "difficult": return "e.g. \"37 + 48 = ?\" — harder double-digit math"
        default: return "e.g. \"12 + 19 = ?\" — moderate addition problems"
        }
    }
    
    func sectionContainer<Content: View>(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 14))
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            content()
        }
        .padding()
        .background(Color.white.opacity(0.03))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.06), lineWidth: 1))
    }
    
    func quickTimeButton(_ label: String, hour: Int, minute: Int, isAM: Bool, isWake: Bool) -> some View {
        let isActive = isWake
            ? (wakeHour == hour && wakeMinute == minute && wakeIsAM == isAM)
            : (bedHour == hour && bedMinute == minute && bedIsAM == isAM)
        
        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                if isWake {
                    wakeHour = hour
                    wakeMinute = minute
                    wakeIsAM = isAM
                } else {
                    bedHour = hour
                    bedMinute = minute
                    bedIsAM = isAM
                }
            }
            HapticManager.shared.impact(style: .light)
        }) {
            Text(label)
                .font(.caption2)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(isActive ? Color.orange.opacity(0.3) : Color.white.opacity(0.06))
                .foregroundColor(isActive ? .orange : .gray)
                .cornerRadius(8)
        }
    }
    
    func quickDayButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
            HapticManager.shared.impact(style: .light)
        }) {
            Text(label)
                .font(.caption2)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.06))
                .foregroundColor(.gray)
                .cornerRadius(8)
        }
    }
    
    // MARK: - Logic
    
    func loadInitialData() {
        if let schedule = schedule {
            name = schedule.name
            isEnabled = schedule.isEnabled
            offTaskType = schedule.offTaskType
            taskDifficulty = schedule.taskDifficulty
            alarmSoundId = schedule.alarmSound
            useSmartAlarm = schedule.useSmartAlarm
            syncToCalendar = schedule.syncToCalendar
            selectedDays = Set(schedule.days)
            
            // Load bedtime
            let bed = FiveMinuteTimePicker.fromDate(schedule.bedtime)
            bedHour = bed.hour
            bedMinute = bed.minute
            bedIsAM = bed.isAM
            
            // Load wake time
            let wake = FiveMinuteTimePicker.fromDate(schedule.wakeTime)
            wakeHour = wake.hour
            wakeMinute = wake.minute
            wakeIsAM = wake.isAM
        }
    }
    
    func saveSchedule() {
        let bedtime = FiveMinuteTimePicker.toDate(hour: bedHour, minute: bedMinute, isAM: bedIsAM)
        let wakeTime = FiveMinuteTimePicker.toDate(hour: wakeHour, minute: wakeMinute, isAM: wakeIsAM)
        let finalDays = Array(selectedDays)
        
        if let existing = schedule {
            existing.name = name.isEmpty ? "My Alarm" : name
            existing.bedtime = bedtime
            existing.wakeTime = wakeTime
            existing.days = finalDays
            existing.isEnabled = isEnabled
            existing.offTaskType = offTaskType
            existing.taskDifficulty = taskDifficulty
            existing.alarmSound = alarmSoundId
            existing.useSmartAlarm = useSmartAlarm
            existing.syncToCalendar = syncToCalendar
            
            // Reschedule notification
            if existing.isEnabled {
                AlarmManager.shared.scheduleAlarm(for: existing)
            } else {
                AlarmManager.shared.cancelAlarm(for: existing)
            }
        } else {
            let newSchedule = SleepSchedule(
                name: name.isEmpty ? "My Alarm" : name,
                bedtime: bedtime,
                wakeTime: wakeTime,
                days: finalDays,
                isEnabled: isEnabled,
                offTaskType: offTaskType,
                taskDifficulty: taskDifficulty,
                alarmSound: alarmSoundId,
                useSmartAlarm: useSmartAlarm,
                syncToCalendar: syncToCalendar
            )
            modelContext.insert(newSchedule)
            
            if isEnabled {
                AlarmManager.shared.scheduleAlarm(for: newSchedule)
            }
        }
        
        HapticManager.shared.notification(type: .success)
        dismiss()
    }
    
    func deleteSchedule() {
        if let schedule = schedule {
            AlarmManager.shared.cancelAlarm(for: schedule)
            modelContext.delete(schedule)
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
            .background(
                isSelected
                ? LinearGradient(colors: [.orange, .red.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                : LinearGradient(colors: [Color.gray.opacity(0.12), Color.gray.opacity(0.08)], startPoint: .top, endPoint: .bottom)
            )
            .foregroundColor(isSelected ? .white : .gray)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.orange.opacity(0.5) : Color.clear, lineWidth: 1)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
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
                .background(isSelected ? Color.orange : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.orange.opacity(0.5) : Color.clear, lineWidth: 1)
                )
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
