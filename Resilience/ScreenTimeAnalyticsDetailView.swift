import SwiftUI
import Charts
import SwiftData

struct ScreenTimeAnalyticsDetailView: View {
    @Query(sort: \ScreenTimeLog.date, order: .forward) private var logs: [ScreenTimeLog]
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
                
                usageChartSection
                
                categoryBreakdownSection
                
                historyList
            }
            .padding(.bottom, 100)
        }
        .onAppear(perform: seedMockDataIfEmpty)
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Screen Time")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                Text("Control your focus.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.1), lineWidth: 8)
                    .frame(width: 60, height: 60)
                Image(systemName: "iphone.smartbutton")
                    .foregroundColor(.blue)
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
                        .background(selectedPeriod == period ? Color.blue : Color.clear)
                        .cornerRadius(10)
                }
            }
        }
        .padding(4)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
    
    private var usageChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Daily Usage")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                if let selected = selectedLog {
                    Text("\(selected.totalMinutes / 60)h \(selected.totalMinutes % 60)m on \(selected.date, style: .date)")
                        .font(.caption)
                        .foregroundColor(.blue)
                } else {
                    Text("\(totalMinutes / 60)h \(totalMinutes % 60)m total")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Chart {
                ForEach(displayedLogs) { log in
                    BarMark(
                        x: .value("Day", log.date, unit: .day),
                        y: .value("Minutes", log.totalMinutes)
                    )
                    .foregroundStyle(log.totalMinutes > 120 ? Color.red.gradient : Color.blue.gradient)
                    .cornerRadius(4)
                    .opacity(rawSelectedDate == nil || Calendar.current.isDate(log.date, inSameDayAs: rawSelectedDate!) ? 1 : 0.4)
                }
                
                if let rawSelectedDate {
                    RuleMark(x: .value("Selected", rawSelectedDate, unit: .day))
                        .foregroundStyle(.white.opacity(0.1))
                }
            }
            .frame(height: 180)
            .chartXSelection(value: $rawSelectedDate)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisGridLine().foregroundStyle(.white.opacity(0.1))
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(24)
        .padding(.horizontal)
    }
    
    private var categoryBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top Categories")
                .font(.headline)
                .foregroundColor(.white)
            
            let categories = ["Health & Fitness", "Social", "Productivity", "Entertainment"]
            let colors: [Color] = [.green, .pink, .blue, .purple]
            
            VStack(spacing: 12) {
                ForEach(0..<categories.count, id: \.self) { i in
                    HStack {
                        Circle().fill(colors[i]).frame(width: 8, height: 8)
                        Text(categories[i])
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(Int.random(in: 10...40))%")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    ProgressView(value: Double.random(in: 0.1...0.6))
                        .tint(colors[i])
                        .background(Color.white.opacity(0.05))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(24)
        .padding(.horizontal)
    }
    
    private var historyList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(logs.reversed().prefix(7)) { log in
                HStack {
                    VStack(alignment: .leading) {
                        Text(log.date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("\(log.totalMinutes / 60)h \(log.totalMinutes % 60)m")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color.white.opacity(0.03))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helpers
    
    private var displayedLogs: [ScreenTimeLog] {
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
    
    private var selectedLog: ScreenTimeLog? {
        guard let rawSelectedDate else { return nil }
        return displayedLogs.first { Calendar.current.isDate($0.date, inSameDayAs: rawSelectedDate) }
    }
    
    private var totalMinutes: Int {
        displayedLogs.reduce(0) { $0 + $1.totalMinutes }
    }
    
    private func seedMockDataIfEmpty() {
        guard logs.isEmpty else { return }
        
        let calendar = Calendar.current
        for i in 0...30 {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                let log = ScreenTimeLog(
                    date: date,
                    totalMinutes: Int.random(in: 30...300),
                    categoryBreakdown: [
                        "Health & Fitness": Int.random(in: 10...60),
                        "Productivity": Int.random(in: 20...120)
                    ]
                )
                modelContext.insert(log)
            }
        }
    }
}

#Preview {
    ScreenTimeAnalyticsDetailView()
        .background(Color.black)
}
