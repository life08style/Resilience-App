import SwiftUI
import SwiftData

struct SleepView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SleepSchedule.bedtime) private var schedules: [SleepSchedule]
    @StateObject private var alarmManager = AlarmManager.shared
    
    @State private var showEditSchedule = false
    @State private var showWhiteNoiseDetail = false
    @State private var showCustomizeAlarm = false
    @State private var whiteNoisePressed = false
    @State private var alarmPressed = false
    @State private var showAlarmActive = false
    
    // The first enabled schedule (or the first schedule if none are enabled)
    private var activeSchedule: SleepSchedule? {
        schedules.first(where: { $0.isEnabled }) ?? schedules.first
    }
    
    private var hasEnabledAlarm: Bool {
        schedules.contains(where: { $0.isEnabled })
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func alarmTypeLabel(for schedule: SleepSchedule) -> String {
        var parts: [String] = []
        
        // Sound name
        if let sound = SoundManager.alarmSounds.first(where: { $0.id == schedule.alarmSound }) {
            parts.append(sound.name)
        } else {
            parts.append("Classic Alarm")
        }
        
        // Active wakeup
        if schedule.offTaskType != "none" {
            parts.append(schedule.offTaskType.capitalized + " Challenge")
        }
        
        return parts.joined(separator: " · ")
    }
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            ScrollView {
                VStack(spacing: 24) {
                    // New Alarm Button
                    Button(action: {
                        showEditSchedule = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("New Alarm")
                                .fontWeight(.bold)
                        }
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .frame(height: 60)
                        .background(
                            LinearGradient(colors: [Color.indigo, Color.purple], startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .shadow(color: .purple.opacity(0.4), radius: 10, y: 4)
                    }
                    .sheet(isPresented: $showEditSchedule) {
                        EditSleepScheduleView()
                    }
                    
                    // Alarms List or Empty State
                    if schedules.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "alarm.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.purple)
                                .shadow(color: .purple.opacity(0.5), radius: 20)
                            
                            Text("No Alarms Set")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Create your first alarm to start waking up on time")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.vertical, 40)
                    } else {
                        ForEach(schedules) { schedule in
                            NavigationLink(destination: EditSleepScheduleView(schedule: schedule)) {
                                AlarmScheduleCard(schedule: schedule)
                            }
                        }
                    }
                    
                    // Sleep Features Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.purple)
                            Text("Sleep Features")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        
                        HStack(spacing: 16) {
                            // White Noise Card
                            NavigationLink(destination: WhiteNoisePlayer()) {
                                VStack(spacing: 6) {
                                    Image(systemName: "zzz")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 4)
                                    
                                    Text("White Noise")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text("Relaxing sounds for better sleep")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                        .multilineTextAlignment(.center)
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "hand.tap.fill")
                                            .font(.system(size: 9))
                                            .foregroundColor(.purple.opacity(0.6))
                                        Text("Hold for details")
                                            .font(.system(size: 9))
                                            .foregroundColor(.white.opacity(0.4))
                                    }
                                    .padding(.top, 2)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .frame(height: 160)
                                .background(Color(red: 0.2, green: 0.1, blue: 0.3))
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.purple.opacity(0.3), lineWidth: 1))
                                .scaleEffect(whiteNoisePressed ? 0.95 : 1.0)
                                .animation(.spring(response: 0.25, dampingFraction: 0.6), value: whiteNoisePressed)
                            }
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 0.5)
                                    .onChanged { _ in
                                        whiteNoisePressed = true
                                        HapticManager.shared.impact(style: .medium)
                                    }
                                    .onEnded { _ in
                                        whiteNoisePressed = false
                                        showWhiteNoiseDetail = true
                                    }
                            )
                            .sheet(isPresented: $showWhiteNoiseDetail) {
                                WhiteNoiseDetailSheet()
                            }
                            
                            // Sleep Stats
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "chart.bar.fill")
                                        .foregroundColor(.blue)
                                    Text("Sleep Stats")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                HStack(alignment: .bottom, spacing: 6) {
                                    ForEach(0..<5) { i in
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(i == 4 ? Color.blue : Color.blue.opacity(0.3))
                                            .frame(width: 8, height: CGFloat([20, 35, 25, 15, 40][i]))
                                    }
                                }
                                
                                HStack {
                                    Text("Avg: 7.5h")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            }
                            .padding()
                            .frame(width: 120, height: 160)
                            .background(Color(UIColor.systemGray6).opacity(0.1))
                            .cornerRadius(16)
                        }
                    }
                    
                    // Next Alarm Banner
                    if hasEnabledAlarm, let schedule = activeSchedule {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Image(systemName: "alarm.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 8)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Next Alarm")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text(formatTime(schedule.wakeTime))
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text(alarmTypeLabel(for: schedule))
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    if schedule.offTaskType != "none" {
                                        HStack(spacing: 4) {
                                            Image(systemName: "brain.head.profile")
                                                .font(.caption2)
                                            Text("Active Wakeup")
                                                .font(.caption2)
                                        }
                                        .foregroundColor(.orange)
                                    }
                                }
                            }
                            
                            // Test alarm button (for development)
                            Divider()
                                .background(Color.white.opacity(0.2))
                                .padding(.vertical, 10)
                            
                            Button(action: {
                                HapticManager.shared.impact(style: .heavy)
                                AlarmManager.shared.fireAlarm(schedule: schedule)
                                showAlarmActive = true
                            }) {
                                HStack {
                                    Image(systemName: "bell.and.waves.left.and.right.fill")
                                    Text("Test Alarm")
                                        .fontWeight(.semibold)
                                }
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(red: 0.1, green: 0.5, blue: 0.3), Color(red: 0.08, green: 0.4, blue: 0.25)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color.green.opacity(0.3), radius: 10, y: 4)
                        )
                    }
                    
                    Spacer().frame(height: 100)
                }
                .padding()
            }
        }
        .fullScreenCover(isPresented: $showAlarmActive) {
            if let schedule = alarmManager.firingSchedule ?? activeSchedule {
                AlarmActiveView(schedule: schedule)
            }
        }
        .onChange(of: alarmManager.alarmFiring) { _, newValue in
            if newValue {
                showAlarmActive = true
            }
        }
    }
}

// MARK: - Alarm Schedule Card

struct AlarmScheduleCard: View {
    @Bindable var schedule: SleepSchedule
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(schedule.name.isEmpty ? "Alarm" : schedule.name)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(formatTime(schedule.wakeTime))
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(schedule.isEnabled ? .white : .gray)
                }
                
                Spacer()
                
                Toggle("", isOn: $schedule.isEnabled)
                    .labelsHidden()
                    .tint(.indigo)
                    .onChange(of: schedule.isEnabled) { _, newValue in
                        if newValue {
                            AlarmManager.shared.scheduleAlarm(for: schedule)
                        } else {
                            AlarmManager.shared.cancelAlarm(for: schedule)
                        }
                    }
            }
            
            HStack {
                // Days
                HStack(spacing: 4) {
                    ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                        Text(day)
                            .font(.system(size: 10, weight: .bold))
                            .frame(width: 22, height: 22)
                            .background(isSelected(day, for: schedule) ? Color.indigo : Color.gray.opacity(0.2))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
                
                // Features badges
                HStack(spacing: 6) {
                    if schedule.offTaskType != "none" {
                        HStack(spacing: 3) {
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 9))
                            Text("Active")
                                .font(.system(size: 9, weight: .semibold))
                        }
                        .foregroundColor(.orange)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.orange.opacity(0.12))
                        .cornerRadius(6)
                    }
                    
                    if let sound = SoundManager.alarmSounds.first(where: { $0.id == schedule.alarmSound }) {
                        Text(sound.name)
                            .font(.system(size: 9))
                            .foregroundColor(.purple)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.purple.opacity(0.12))
                            .cornerRadius(6)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(schedule.isEnabled ? Color.indigo.opacity(0.3) : Color.gray.opacity(0.15), lineWidth: 1)
                )
        )
    }
    
    func isSelected(_ dayLetter: String, for schedule: SleepSchedule) -> Bool {
        return schedule.days.contains { $0.lowercased().starts(with: dayLetter.lowercased()) }
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
