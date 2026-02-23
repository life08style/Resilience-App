import SwiftUI

// MARK: - Models

struct ScreenTimeEntry: Identifiable {
    let id = UUID()
    let day: String
    let hours: Double
}

struct AppUsageItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let category: String
    let minutes: Int
    let isWaste: Bool
    let color: Color
}

// MARK: - TimeManagementView

struct TimeManagementView: View {
    @State private var tasks: [TodoItem] = [
        TodoItem(text: "Review project proposal", isCompleted: false, order: 0),
        TodoItem(text: "Email marketing team", isCompleted: true, order: 1),
        TodoItem(text: "Update website content", isCompleted: false, order: 2)
    ]
    @State private var newTaskText = ""
    @State private var focusDuration: Double = 25
    @State private var isFocusing = false
    @State private var selectedTab: Int = 0

    // Mock screen time data for the past 7 days
    let weeklyData: [ScreenTimeEntry] = [
        ScreenTimeEntry(day: "Mon", hours: 4.2),
        ScreenTimeEntry(day: "Tue", hours: 5.8),
        ScreenTimeEntry(day: "Wed", hours: 3.5),
        ScreenTimeEntry(day: "Thu", hours: 6.1),
        ScreenTimeEntry(day: "Fri", hours: 7.3),
        ScreenTimeEntry(day: "Sat", hours: 8.0),
        ScreenTimeEntry(day: "Sun", hours: 5.2),
    ]

    // Mock app usage – mix of useful and wasteful
    let appUsage: [AppUsageItem] = [
        AppUsageItem(name: "Instagram",   icon: "camera.filters",        category: "Social",        minutes: 97,  isWaste: true,  color: .pink),
        AppUsageItem(name: "TikTok",      icon: "music.note.tv",         category: "Entertainment", minutes: 83,  isWaste: true,  color: .red),
        AppUsageItem(name: "Safari",      icon: "safari",                category: "Productivity",  minutes: 55,  isWaste: false, color: .blue),
        AppUsageItem(name: "Twitter/X",   icon: "bird",                  category: "Social",        minutes: 48,  isWaste: true,  color: Color(red:0.1, green:0.5, blue:0.9)),
        AppUsageItem(name: "YouTube",     icon: "tv",                    category: "Entertainment", minutes: 45,  isWaste: true,  color: .red),
        AppUsageItem(name: "Resilience",  icon: "bolt.heart.fill",       category: "Productivity",  minutes: 32,  isWaste: false, color: .purple),
        AppUsageItem(name: "Messages",    icon: "message.fill",          category: "Communication", minutes: 28,  isWaste: false, color: .green),
        AppUsageItem(name: "Reddit",      icon: "arrow.up.square.fill",  category: "Social",        minutes: 22,  isWaste: true,  color: .orange),
    ]

    var totalScreenTimeToday: Int { 440 } // minutes
    var wastedApps: [AppUsageItem] { appUsage.filter { $0.isWaste } }
    var totalWastedMinutes: Int { wastedApps.reduce(0) { $0 + $1.minutes } }
    var productiveMinutes: Int { appUsage.filter { !$0.isWaste }.reduce(0) { $0 + $1.minutes } }
    var maxWeeklyHours: Double { weeklyData.map { $0.hours }.max() ?? 1 }
    var avgWeeklyHours: Double { weeklyData.map { $0.hours }.reduce(0, +) / Double(weeklyData.count) }
    
    var wastedPercentage: Int {
        if totalScreenTimeToday == 0 { return 0 }
        return Int(Double(totalWastedMinutes) / Double(totalScreenTimeToday) * 100.0)
    }
    
    var wastedRatio: CGFloat {
        if totalScreenTimeToday == 0 { return 0 }
        return CGFloat(totalWastedMinutes) / CGFloat(totalScreenTimeToday)
    }
    
    var maxWastedMinutes: Int {
        wastedApps.map { $0.minutes }.max() ?? 1
    }

    var body: some View {
        ResiliencePage(showBackButton: true) {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Productivity Hub")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Thursday, Feb 19")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "chart.bar.xaxis")
                            .font(.title2)
                            .foregroundColor(.purple)
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    // MARK: Tab Selector
                    HStack(spacing: 0) {
                        tabButton(title: "Overview", index: 0)
                        tabButton(title: "Time Wasted", index: 1)
                        tabButton(title: "Tasks", index: 2)
                    }
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    if selectedTab == 0 {
                        overviewSection
                    } else if selectedTab == 1 {
                        timeWastedSection
                    } else {
                        tasksSection
                    }
                }
                .padding(.bottom, 32)
            }
        }
    }

    // MARK: - Tab Button
    @ViewBuilder
    func tabButton(title: String, index: Int) -> some View {
        Button(action: { withAnimation(.easeInOut(duration: 0.2)) { selectedTab = index } }) {
            Text(title)
                .font(.caption)
                .fontWeight(selectedTab == index ? .semibold : .regular)
                .foregroundColor(selectedTab == index ? .white : .gray)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(selectedTab == index ? Color.purple : Color.clear)
                .cornerRadius(10)
                .padding(3)
        }
    }

    // MARK: - Overview Section
    var overviewSection: some View {
        VStack(spacing: 20) {

            // Today's screen time summary
            HStack(spacing: 12) {
                screenTimeStat(label: "Screen Time", value: formatTime(totalScreenTimeToday), icon: "iphone", color: .blue)
                screenTimeStat(label: "Productive", value: formatTime(productiveMinutes), icon: "checkmark.seal.fill", color: .green)
                screenTimeStat(label: "Wasted", value: formatTime(totalWastedMinutes), icon: "hourglass.tophalf.filled", color: .red)
            }
            .padding(.horizontal)

            // Weekly Trend Chart
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(.purple)
                    Text("7-Day Screen Time")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "Avg %.1fh", avgWeeklyHours))
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(weeklyData) { entry in
                        VStack(spacing: 4) {
                            Text(String(format: "%.1f", entry.hours))
                                .font(.system(size: 9))
                                .foregroundColor(.gray)
                            RoundedRectangle(cornerRadius: 6)
                                .fill(barColor(for: entry.hours))
                                .frame(width: 32, height: CGFloat(entry.hours / maxWeeklyHours) * 100)
                            Text(entry.day)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(maxWidth: .infinity)

                // Average line label
                HStack {
                    Rectangle()
                        .fill(Color.yellow.opacity(0.6))
                        .frame(maxWidth: .infinity, maxHeight: 1)
                    Text("avg")
                        .font(.system(size: 9))
                        .foregroundColor(.yellow.opacity(0.8))
                }
            }
            .padding()
            .background(Color.gray.opacity(0.15))
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.purple.opacity(0.25), lineWidth: 1))
            .padding(.horizontal)

            // All app usage breakdown
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "apps.iphone")
                        .foregroundColor(.blue)
                    Text("App Breakdown")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text("Today")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                ForEach(appUsage.prefix(6)) { app in
                    appRow(app)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.15))
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.blue.opacity(0.2), lineWidth: 1))
            .padding(.horizontal)

            // Focus Timer
            focusTimerSection
                .padding(.horizontal)
        }
    }

    // MARK: - Time Wasted Section
    var timeWastedSection: some View {
        VStack(spacing: 20) {
            // Banner
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .font(.title2)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Time Wasted Today")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("\(formatTime(totalWastedMinutes)) on non-useful apps")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    }
                    Spacer()
                    // Donut-style ring
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 6)
                            .frame(width: 52, height: 52)
                        Circle()
                            .trim(from: 0, to: wastedRatio)
                            .stroke(Color.red, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .frame(width: 52, height: 52)
                            .rotationEffect(.degrees(-90))
                        Text("\(wastedPercentage)%")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.red)
                    }
                }

                // Recovery message
                Text("💡 Cutting Instagram & TikTok alone saves you \(formatTime(180)) daily — that's 21h per week reclaimed.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(
                LinearGradient(colors: [Color.red.opacity(0.15), Color.orange.opacity(0.08)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.red.opacity(0.3), lineWidth: 1))
            .padding(.horizontal)

            // Wasted apps list
            VStack(alignment: .leading, spacing: 12) {
                Text("Biggest Time Sinks")
                    .font(.headline)
                    .foregroundColor(.white)

                ForEach(wastedApps.sorted { $0.minutes > $1.minutes }) { app in
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(app.color.opacity(0.2))
                                .frame(width: 38, height: 38)
                            Image(systemName: app.icon)
                                .foregroundColor(app.color)
                                .font(.system(size: 16))
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(app.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            Text(app.category)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(formatTime(app.minutes))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.red)
                            // bar
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color.gray.opacity(0.25))
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(app.color.opacity(0.7))
                                        .frame(width: geo.size.width * CGFloat(app.minutes) / CGFloat(maxWastedMinutes))
                                }
                            }
                            .frame(width: 80, height: 5)
                        }
                    }
                    .padding(10)
                    .background(Color.gray.opacity(0.12))
                    .cornerRadius(12)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.15))
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.orange.opacity(0.25), lineWidth: 1))
            .padding(.horizontal)

            // Weekly trend of wasted time
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("Wasted Time Trend")
                        .font(.headline)
                        .foregroundColor(.white)
                }

                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(["Mon","Tue","Wed","Thu","Fri","Sat","Sun"].indices, id: \.self) { i in
                        let wasted: [Double] = [1.2, 2.5, 1.0, 2.8, 3.1, 3.8, 2.3]
                        VStack(spacing: 4) {
                            Text(String(format: "%.1f", wasted[i]))
                                .font(.system(size: 9))
                                .foregroundColor(.gray)
                            RoundedRectangle(cornerRadius: 5)
                                .fill(wasted[i] > 2.5 ? Color.red.opacity(0.7) : Color.orange.opacity(0.5))
                                .frame(width: 32, height: CGFloat(wasted[i] / 4.0) * 90)
                            Text(["Mon","Tue","Wed","Thu","Fri","Sat","Sun"][i])
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                Text("📈 Your wasted screen time is trending up on weekends. Consider setting app limits on Sat/Sun.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.gray.opacity(0.15))
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.red.opacity(0.2), lineWidth: 1))
            .padding(.horizontal)
        }
    }

    // MARK: - Tasks Section
    var tasksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                TextField("Add a new task...", text: $newTaskText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                Button(action: addTask) {
                    Image(systemName: "plus")
                        .padding(10)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }

            ForEach($tasks) { $task in
                HStack {
                    Button(action: { task.isCompleted.toggle() }) {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(task.isCompleted ? .green : .gray)
                            .font(.title3)
                    }
                    Text(task.text)
                        .strikethrough(task.isCompleted)
                        .foregroundColor(task.isCompleted ? .gray : .white)
                    Spacer()
                    Button(action: { deleteTask(task) }) {
                        Image(systemName: "trash")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
        }
        .padding()
    }

    // MARK: - Focus Timer Card
    var focusTimerSection: some View {
        VStack(spacing: 14) {
            HStack {
                Image(systemName: "timer")
                    .font(.title2)
                    .foregroundColor(.purple)
                Text("Quick Focus")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }

            if isFocusing {
                Text("24:59")
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                Button(action: { isFocusing = false }) {
                    Text("Stop Focus")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.2))
                        .foregroundColor(.red)
                        .cornerRadius(12)
                }
            } else {
                VStack(spacing: 4) {
                    Text("\(Int(focusDuration)) min")
                        .font(.title2).bold().foregroundColor(.white)
                    Slider(value: $focusDuration, in: 5...60, step: 5)
                        .accentColor(.purple)
                }
                Button(action: { isFocusing = true }) {
                    Text("Start Focus")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.purple.opacity(0.3), lineWidth: 1))
    }

    // MARK: - Helper Views

    func screenTimeStat(label: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(color.opacity(0.12))
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(color.opacity(0.3), lineWidth: 1))
    }

    func appRow(_ app: AppUsageItem) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(app.color.opacity(0.2))
                    .frame(width: 34, height: 34)
                Image(systemName: app.icon)
                    .foregroundColor(app.color)
                    .font(.system(size: 14))
            }
            Text(app.name)
                .font(.subheadline)
                .foregroundColor(.white)
            Spacer()
            if app.isWaste {
                Text("waste")
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.red.opacity(0.2))
                    .foregroundColor(.red)
                    .cornerRadius(6)
            }
            Text(formatTime(app.minutes))
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(app.isWaste ? .red : .green)
        }
    }

    // MARK: - Helpers

    func barColor(for hours: Double) -> Color {
        if hours >= 7 { return .red.opacity(0.8) }
        if hours >= 5 { return .orange.opacity(0.8) }
        return .purple.opacity(0.8)
    }

    func formatTime(_ minutes: Int) -> String {
        if minutes < 60 { return "\(minutes)m" }
        let h = minutes / 60
        let m = minutes % 60
        return m == 0 ? "\(h)h" : "\(h)h \(m)m"
    }

    func addTask() {
        guard !newTaskText.isEmpty else { return }
        tasks.append(TodoItem(text: newTaskText, isCompleted: false, order: tasks.count))
        newTaskText = ""
    }

    func deleteTask(_ task: TodoItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }
}
