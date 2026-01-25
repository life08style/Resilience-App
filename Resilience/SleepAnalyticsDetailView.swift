import SwiftUI
import Charts
import SwiftData

struct SleepAnalyticsDetailView: View {
    @Query(sort: \SleepLog.date, order: .forward) private var logs: [SleepLog]
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedPeriod: String = "Week"
    @State private var currentDate = Calendar.current.startOfDay(for: Date())
    @State private var rawSelectedDate: Date? = nil
    
    let periods = ["Week", "Month", "Year"]
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            VStack(spacing: 24) {
                headerSection
                
                VStack(spacing: 16) {
                    periodPicker
                    DateNavigator(date: $currentDate, period: selectedPeriod)
                }
                .padding(.horizontal)
                
                durationChartSection
                
                qualityChartSection
                
                statsGrid
                
                historyList
            }
            .padding(.bottom, 100)
        }
        .onAppear(perform: seedMockDataIfEmpty)
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Sleep Performance")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                Text("Rest is the catalyst for growth.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            ZStack {
                Circle()
                    .stroke(Color.purple.opacity(0.1), lineWidth: 8)
                    .frame(width: 60, height: 60)
                Image(systemName: "moon.stars.fill")
                    .foregroundColor(.purple)
                    .font(.title2)
            }
        }
        .padding(.horizontal)
    }
    
    private var periodPicker: some View {
        HStack(spacing: 0) {
            ForEach(periods, id: \.self) { period in
                Button(action: { 
                    withAnimation { 
                        selectedPeriod = period 
                        let calendar = Calendar.current
                        let now = Date()
                        if period == "Week" {
                            currentDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) ?? now
                        } else if period == "Month" {
                            currentDate = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
                        } else {
                            currentDate = calendar.date(from: calendar.dateComponents([.year], from: now)) ?? now
                        }
                    } 
                }) {
                    Text(period)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(selectedPeriod == period ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(selectedPeriod == period ? Color.purple : Color.clear)
                        .cornerRadius(10)
                }
            }
        }
        .padding(4)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
    
    private var durationChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Sleep Duration")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                if let selected = selectedLog {
                    Text("\(String(format: "%.1f", selected.durationHours))h on \(selected.date, style: .date)")
                        .font(.caption)
                        .foregroundColor(.purple)
                } else {
                    Text("\(String(format: "%.1f", averageDuration))h avg")
                        .font(.caption)
                        .foregroundColor(.purple)
                }
            }
            
            Chart {
                ForEach(displayedLogs) { log in
                    BarMark(
                        x: .value("Day", log.date, unit: .day),
                        y: .value("Hours", log.durationHours)
                    )
                    .foregroundStyle(log.durationHours >= 7 ? Color.purple.gradient : Color.red.gradient)
                    .cornerRadius(4)
                    .opacity(rawSelectedDate == nil || Calendar.current.isDate(log.date, inSameDayAs: rawSelectedDate!) ? 1 : 0.4)
                }
                
                if let rawSelectedDate {
                    RuleMark(x: .value("Selected", rawSelectedDate, unit: .day))
                        .foregroundStyle(.white.opacity(0.1))
                }
                
                RuleMark(y: .value("Goal", 7.0))
                    .lineStyle(StrokeStyle(dash: [5, 5]))
                    .foregroundStyle(.white.opacity(0.2))
            }
            .frame(height: 200)
            .chartXSelection(value: $rawSelectedDate)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisGridLine().foregroundStyle(.white.opacity(0.1))
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                        .foregroundStyle(.gray)
                }
            }
            .chartYAxis {
                AxisMarks { _ in
                    AxisGridLine().foregroundStyle(.white.opacity(0.1))
                    AxisValueLabel().foregroundStyle(.gray)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(24)
        .padding(.horizontal)
    }
    
    private var qualityChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quality Score")
                .font(.headline)
                .foregroundColor(.white)
            
            Chart {
                ForEach(displayedLogs) { log in
                    AreaMark(
                        x: .value("Day", log.date, unit: .day),
                        y: .value("Score", log.qualityScore)
                    )
                    .foregroundStyle(LinearGradient(colors: [.purple.opacity(0.3), .clear], startPoint: .top, endPoint: .bottom))
                    .interpolationMethod(.catmullRom)
                    
                    LineMark(
                        x: .value("Day", log.date, unit: .day),
                        y: .value("Score", log.qualityScore)
                    )
                    .foregroundStyle(.purple)
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 120)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel().foregroundStyle(.gray)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(24)
        .padding(.horizontal)
    }
    
    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ChartStatCard(title: "Deep Sleep", value: "112", unit: "min", icon: "brain.head.profile", color: .purple)
            ChartStatCard(title: "Consistency", value: "88", unit: "%", icon: "arrow.triangle.2.circlepath", color: .blue)
        }
        .padding(.horizontal)
    }
    
    private var historyList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sleep History")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(logs.reversed().prefix(7)) { log in
                HStack {
                    VStack(alignment: .leading) {
                        Text(log.date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Text("\(String(format: "%.1f", log.durationHours)) hours")
                            .font(.caption)
                            .foregroundColor(.purple)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(log.qualityScore)")
                            .font(.headline)
                            .foregroundColor(log.qualityScore > 80 ? .green : .orange)
                        Text("Quality")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.03))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helpers
    
    private var displayedLogs: [SleepLog] {
        let calendar = Calendar.current
        let startDate = currentDate
        let endDate: Date
        
        switch selectedPeriod {
        case "Week":
            endDate = calendar.date(byAdding: .day, value: 7, to: startDate) ?? startDate
        case "Month":
            endDate = calendar.date(byAdding: .month, value: 1, to: startDate) ?? startDate
        default:
            endDate = calendar.date(byAdding: .year, value: 1, to: startDate) ?? startDate
        }
        
        return logs.filter { $0.date >= startDate && $0.date < endDate }
    }
    
    private var selectedLog: SleepLog? {
        guard let rawSelectedDate else { return nil }
        return displayedLogs.first { Calendar.current.isDate($0.date, inSameDayAs: rawSelectedDate) }
    }
    
    private var averageDuration: Double {
        displayedLogs.isEmpty ? 0 : displayedLogs.reduce(0) { $0 + $1.durationHours } / Double(displayedLogs.count)
    }
    
    private func seedMockDataIfEmpty() {
        guard logs.isEmpty else { return }
        
        let calendar = Calendar.current
        for i in 0...30 {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                let log = SleepLog(
                    date: date,
                    durationHours: Double.random(in: 5.5...9.0),
                    qualityScore: Int.random(in: 60...95),
                    deepSleepMinutes: Int.random(in: 60...180),
                    remSleepMinutes: Int.random(in: 60...150)
                )
                modelContext.insert(log)
            }
        }
    }
}

#Preview {
    SleepAnalyticsDetailView()
        .background(Color.black)
}
