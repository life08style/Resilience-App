import SwiftUI
import SwiftData

struct SleepScheduleView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var schedules: [SleepSchedule]
    
    @State private var showEditSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sleep Schedule")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Consistent sleep fuels your day.")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top)
                
                // Next Sleep Target
                if let nextSleep = calculateNextSleep() {
                    VStack(spacing: 8) {
                        Text("Next Sleep")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text(formatTime(nextSleep))
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("in 4h 30m") // Mock countdown
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.systemGray6).opacity(0.15))
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
                
                // Schedules List
                VStack(spacing: 16) {
                    ForEach(schedules) { schedule in
                        SleepScheduleCard(schedule: schedule, onDelete: { id in
                            if let index = schedules.firstIndex(where: { $0.id == id }) {
                                modelContext.delete(schedules[index])
                            }
                        })
                    }
                }
                .padding(.horizontal)
                
                // Add Schedule Button
                Button(action: { showEditSheet = true }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Schedule")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(16)
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationTitle("Sleep")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showEditSheet) {
            EditSleepScheduleView()
        }
    }
    
    func calculateNextSleep() -> Date? {
        // Simplified logic: just return the bedtime of the first enabled schedule
        return schedules.first(where: { $0.isEnabled })?.bedtime
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct SleepScheduleCard: View {
    @Bindable var schedule: SleepSchedule
    var onDelete: (UUID) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                
                Toggle("", isOn: $schedule.isEnabled)
                    .labelsHidden()
                    .onChange(of: schedule.isEnabled) { oldValue, newValue in
                        if newValue {
                            NotificationManager.shared.scheduleSleepReminder(bedtime: schedule.bedtime)
                        }
                    }
            }
            
            HStack(spacing: 24) {
                TimeBox(icon: "moon.fill", title: "Bedtime", time: schedule.bedtime, color: .indigo)
                TimeBox(icon: "sun.max.fill", title: "Wake Up", time: schedule.wakeTime, color: .orange)
            }
            
            // Days
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text("Active Days")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            
            HStack {
                ForEach(["mon", "tue", "wed", "thu", "fri", "sat", "sun"], id: \.self) { day in
                    Text(day.prefix(1).uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .frame(width: 24, height: 24)
                        .background(schedule.days.contains(day) ? Color.blue : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            
            // Delete Action
            HStack {
                Spacer()
                Button(action: { onDelete(schedule.id) }) {
                    Label("Delete", systemImage: "trash")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.systemGray6).opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(schedule.isEnabled ? Color.indigo.opacity(0.3) : Color.clear, lineWidth: 1)
                )
        )
    }
}

struct TimeBox: View {
    let icon: String
    let title: String
    let time: Date
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(formatTime(time))
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
