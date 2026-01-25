import SwiftUI
import SwiftData

struct SleepView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SleepSchedule.bedtime) private var schedules: [SleepSchedule]
    
    @State private var showEditSchedule = false
    @State private var isAlarmOn = false
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            ScrollView {
                VStack(spacing: 24) {
                    // Large "New Sleep Schedule" Button
                    Button(action: {
                        showEditSchedule = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("New Sleep Schedule")
                                .fontWeight(.bold)
                        }
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .frame(height: 60)
                        .background(
                            LinearGradient(colors: [Color(red: 0.2, green: 0.5, blue: 1.0), Color.purple], startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .purple.opacity(0.4), radius: 8, y: 4)
                    }
                    .sheet(isPresented: $showEditSchedule) {
                        EditSleepScheduleView()
                    }
                    
                    // Schedules List or Empty State
                    if schedules.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "moon.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.purple)
                            .shadow(color: .purple.opacity(0.5), radius: 20)
                            
                            Text("No Sleep Schedules")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Create your first schedule to start tracking your sleep")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.vertical, 40)
                    } else {
                        ForEach(schedules) { schedule in
                            NavigationLink(destination: EditSleepScheduleView(schedule: schedule)) {
                                CompactScheduleCard(schedule: schedule)
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
                            // White Noise Card (Large Left)
                            NavigationLink(destination: WhiteNoisePlayer()) {
                                VStack {
                                    Image(systemName: "zzz")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 8)
                                    
                                    Text("White Noise")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text("Relaxing sounds for better sleep")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                        .multilineTextAlignment(.center)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .frame(height: 160)
                                .background(Color(red: 0.2, green: 0.1, blue: 0.3)) // Dark Purple
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.purple.opacity(0.3), lineWidth: 1))
                            }
                            
                            // Sleep Stats (Small Right)
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
                                
                                // Mock Chart
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
                    
                    // Turn On Alarm Banner
                    HStack {
                        Image(systemName: "moon.zzz.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.trailing, 8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Turn On Alarm")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Turn this on to ensure your alarm triggers perfectly.")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $isAlarmOn)
                            .labelsHidden()
                            .onChange(of: isAlarmOn) { _, newValue in
                                if newValue {
                                    SoundManager.shared.startSilentMode()
                                } else {
                                    SoundManager.shared.stopSilentMode()
                                }
                            }
                    }
                    .padding()
                    .background(isAlarmOn ? Color.green : Color.blue)
                    .cornerRadius(16)
                    
                    Spacer().frame(height: 100)
                }
                .padding()
            }
        }
    }
}

struct CompactScheduleCard: View {
    @Bindable var schedule: SleepSchedule
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(schedule.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Toggle("", isOn: $schedule.isEnabled)
                    .labelsHidden()
            }
            
            HStack {
                Text("\(formatTime(schedule.bedtime)) → \(formatTime(schedule.wakeTime))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                HStack(spacing: 4) {
                    ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                        Text(day)
                            .font(.system(size: 10))
                            .frame(width: 20, height: 20)
                            .background(isSelected(day, for: schedule) ? Color.indigo : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(schedule.isEnabled ? Color.indigo.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 1)
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
