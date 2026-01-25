import SwiftUI
import Charts
import SwiftData

struct DietAnalyticsDetailView: View {
    @Query(sort: \DailyNutritionLog.date, order: .forward) private var logs: [DailyNutritionLog]
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
                
                calorieChartSection
                
                macrosBreakdownSection
                
                statsGrid
                
                historyList
            }
            .padding(.bottom, 100)
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Dietary Analytics")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                Text("Fuel your ambition.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            ZStack {
                Circle()
                    .stroke(Color.orange.opacity(0.1), lineWidth: 8)
                    .frame(width: 60, height: 60)
                Image(systemName: "fork.knife")
                    .foregroundColor(.orange)
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
                        .background(selectedPeriod == period ? Color.orange : Color.clear)
                        .cornerRadius(10)
                }
            }
        }
        .padding(4)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
    
    private var calorieChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Daily Calories")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                if let selected = selectedLog {
                    Text("\(Int(selected.calories)) kcal on \(selected.date, style: .date)")
                        .font(.caption)
                        .foregroundColor(.orange)
                } else {
                    Text("Target: 2500")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Chart {
                ForEach(displayedLogs) { log in
                    BarMark(
                        x: .value("Day", log.date, unit: .day),
                        y: .value("Calories", log.calories)
                    )
                    .foregroundStyle(log.calories > 2500 ? Color.red.gradient : Color.orange.gradient)
                    .cornerRadius(4)
                    .opacity(rawSelectedDate == nil || Calendar.current.isDate(log.date, inSameDayAs: rawSelectedDate!) ? 1 : 0.4)
                }
                
                if let rawSelectedDate {
                    RuleMark(x: .value("Selected", rawSelectedDate, unit: .day))
                        .foregroundStyle(.white.opacity(0.1))
                }
                
                RuleMark(y: .value("Goal", 2500))
                    .lineStyle(StrokeStyle(dash: [5, 5]))
                    .foregroundStyle(.white.opacity(0.3))
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
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(24)
        .padding(.horizontal)
    }
    
    private var macrosBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Macronutrient Average")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 20) {
                MacroPill(label: "Protein", percentage: 30, color: .green)
                MacroPill(label: "Carbs", percentage: 50, color: .blue)
                MacroPill(label: "Fat", percentage: 20, color: .red)
            }
            
            // Stacked Bar for Macros
            GeometryReader { geo in
                HStack(spacing: 0) {
                    Rectangle().fill(Color.green).frame(width: geo.size.width * 0.3)
                    Rectangle().fill(Color.blue).frame(width: geo.size.width * 0.5)
                    Rectangle().fill(Color.red).frame(width: geo.size.width * 0.2)
                }
                .cornerRadius(10)
            }
            .frame(height: 12)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(24)
        .padding(.horizontal)
    }
    
    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ChartStatCard(title: "Avg Protein", value: "\(Int(averageProtein))", unit: "g", icon: "dumbbell.fill", color: .green)
            ChartStatCard(title: "Avg Fiber", value: "28", unit: "g", icon: "leaf.fill", color: .orange)
        }
        .padding(.horizontal)
    }
    
    private var historyList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Nutrition History")
                .font(.headline)
                .foregroundColor(.white)
            
            if logs.isEmpty {
                Text("No data logged yet. Complete recipes or log food to see trends.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(logs.reversed().prefix(7)) { log in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(log.date, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text("\(Int(log.calories)) kcal")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        Spacer()
                        HStack(spacing: 12) {
                            MacroSmallLabel(label: "P", value: Int(log.protein), color: .green)
                            MacroSmallLabel(label: "C", value: Int(log.carbs), color: .blue)
                            MacroSmallLabel(label: "F", value: Int(log.fat), color: .red)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.03))
                    .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helpers
    
    private var displayedLogs: [DailyNutritionLog] {
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
    
    private var selectedLog: DailyNutritionLog? {
        guard let rawSelectedDate else { return nil }
        return displayedLogs.first { Calendar.current.isDate($0.date, inSameDayAs: rawSelectedDate) }
    }
    
    private var averageProtein: Double {
        displayedLogs.isEmpty ? 0 : displayedLogs.reduce(0) { $0 + $1.protein } / Double(displayedLogs.count)
    }
}

struct MacroPill: View {
    let label: String
    let percentage: Int
    let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.caption2).foregroundColor(.gray)
            Text("\(percentage)%").font(.caption).fontWeight(.bold).foregroundColor(color)
        }
    }
}

struct MacroSmallLabel: View {
    let label: String
    let value: Int
    let color: Color
    var body: some View {
        HStack(spacing: 2) {
            Text(label).font(.system(size: 8, weight: .bold)).foregroundColor(.gray)
            Text("\(value)g").font(.system(size: 10, weight: .bold)).foregroundColor(color)
        }
    }
}

#Preview {
    DietAnalyticsDetailView()
        .background(Color.black)
}
