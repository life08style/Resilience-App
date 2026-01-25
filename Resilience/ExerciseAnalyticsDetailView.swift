import SwiftUI
import Charts
import SwiftData

struct ExerciseAnalyticsDetailView: View {
    @Query(sort: \ExerciseLog.date, order: .forward) private var logs: [ExerciseLog]
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
                
                stepsChartSection
                
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
                Text("Exercise Insights")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                Text("Keep moving, stay resilient.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            ZStack {
                Circle()
                    .stroke(Color.green.opacity(0.1), lineWidth: 8)
                    .frame(width: 60, height: 60)
                Image(systemName: "figure.walk")
                    .foregroundColor(.green)
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
                        // Align currentDate to start of period
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
                        .background(selectedPeriod == period ? Color.green : Color.clear)
                        .cornerRadius(10)
                }
            }
        }
        .padding(4)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var stepsChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Steps")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                if let selected = selectedLog {
                    Text("\(selected.steps) steps on \(selected.date, style: .date)")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Text("\(totalSteps) total")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Chart {
                ForEach(displayedLogs) { log in
                    BarMark(
                        x: .value("Date", log.date, unit: .day),
                        y: .value("Steps", log.steps)
                    )
                    .foregroundStyle(Color.green.gradient)
                    .cornerRadius(4)
                    .opacity(rawSelectedDate == nil || Calendar.current.isDate(log.date, inSameDayAs: rawSelectedDate!) ? 1 : 0.4)
                }
                
                if let rawSelectedDate {
                    RuleMark(x: .value("Selected", rawSelectedDate, unit: .day))
                        .foregroundStyle(.white.opacity(0.1))
                }
                
                RuleMark(y: .value("Average", averageSteps))
                    .lineStyle(StrokeStyle(dash: [5, 5]))
                    .foregroundStyle(.gray.opacity(0.5))
            }
            .frame(height: 200)
            .chartXSelection(value: $rawSelectedDate)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { date in
                    AxisGridLine().foregroundStyle(.white.opacity(0.1))
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                        .foregroundStyle(.gray)
                }
            }
            .chartYAxis {
                AxisMarks { value in
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
    
    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ChartStatCard(title: "Active Calories", value: "\(totalCalories)", unit: "kcal", icon: "flame.fill", color: .orange)
            ChartStatCard(title: "Exercise Time", value: "\(totalMinutes)", unit: "min", icon: "timer", color: .blue)
        }
        .padding(.horizontal)
    }
    
    private var historyList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent History")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(logs.reversed().prefix(7)) { log in
                HStack {
                    VStack(alignment: .leading) {
                        Text(log.date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Text("\(log.steps) steps")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    Spacer()
                    Text("\(log.activeCalories) kcal")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white.opacity(0.03))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helpers
    
    private var displayedLogs: [ExerciseLog] {
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
    
    private var selectedLog: ExerciseLog? {
        guard let rawSelectedDate else { return nil }
        return displayedLogs.first { Calendar.current.isDate($0.date, inSameDayAs: rawSelectedDate) }
    }
    
    private var totalSteps: Int {
        displayedLogs.reduce(0) { $0 + $1.steps }
    }
    
    private var averageSteps: Double {
        displayedLogs.isEmpty ? 0 : Double(totalSteps) / Double(displayedLogs.count)
    }
    
    private var totalCalories: Int {
        displayedLogs.reduce(0) { $0 + $1.activeCalories }
    }
    
    private var totalMinutes: Int {
        displayedLogs.reduce(0) { $0 + $1.exerciseMinutes }
    }
    
    private func seedMockDataIfEmpty() {
        guard logs.isEmpty else { return }
        
        let calendar = Calendar.current
        for i in 0...30 {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                let log = ExerciseLog(
                    date: date,
                    steps: Int.random(in: 3000...12000),
                    activeCalories: Int.random(in: 200...800),
                    exerciseMinutes: Int.random(in: 20...90)
                )
                modelContext.insert(log)
            }
        }
    }
}



#Preview {
    ExerciseAnalyticsDetailView()
        .background(Color.black)
}
