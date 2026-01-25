import SwiftUI
import Charts
import SwiftData

struct ProgressTrackingView: View {
    @ObservedObject var settings = UserSettings.shared
    @State private var selectedTab: String = "Plans"
    let tabs = ["Plans", "Body"]
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            VStack(spacing: 0) {
                // Custom Segmented Control
                HStack(spacing: 0) {
                    ForEach(tabs, id: \.self) { tab in
                        Button(action: { withAnimation { selectedTab = tab } }) {
                            VStack(spacing: 8) {
                                Text(tab)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(selectedTab == tab ? .white : .gray)
                                
                                Rectangle()
                                    .fill(selectedTab == tab ? Color.cyan : Color.clear)
                                    .frame(height: 3)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        if selectedTab == "Plans" {
                            ProgressPlansTab()
                        } else {
                            ProgressBodyTab()
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

// MARK: - Body Tab (Complex logic requested)
struct ProgressBodyTab: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BodyMeasurement.date, order: .forward) private var measurements: [BodyMeasurement]
    @State private var showingLogSheet = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Legend
            HStack(spacing: 16) {
                let weightUnit = UserSettings.shared.unitSystem == .imperial ? "lbs" : "kg"
                SharedLegendItem(label: "Weight (\(weightUnit))", color: .blue)
                SharedLegendItem(label: "Waist (in)", color: .green)
                SharedLegendItem(label: "Body Fat %", color: .cyan)
            }
            .padding(.horizontal)
            
            BodyCompositionChart(measurements: measurements)
            
            // Log Button
            Button(action: { showingLogSheet = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("LOG NEW MEASUREMENTS")
                        .fontWeight(.black)
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.cyan)
                .cornerRadius(30)
            }
            .padding(.horizontal)
            
            MeasurementHistoryList(measurements: measurements)
        }
        .sheet(isPresented: $showingLogSheet) {
            BodyLogSheet()
        }
    }
}

struct BodyCompositionChart: View {
    let measurements: [BodyMeasurement]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Body Composition Trends")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            if measurements.isEmpty {
                emptyState
            } else {
                actualChart
            }
        }
        .padding(.vertical)
        .background(Color.white.opacity(0.05))
        .cornerRadius(24)
        .padding(.horizontal)
    }
    
    private var emptyState: some View {
        VStack {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.largeTitle)
                .foregroundColor(.gray.opacity(0.3))
            Text("No data to display. Start logging below.")
                .foregroundColor(.gray)
        }
        .frame(height: 250)
        .frame(maxWidth: .infinity)
    }
    
    private var actualChart: some View {
        Chart {
            ForEach(measurements) { m in
                let displayWeight = UserSettings.shared.unitSystem == .imperial ? m.weight * 2.20462 : m.weight
                // Weight Line (Primary)
                LineMark(
                    x: .value("Date", m.date),
                    y: .value("Weight", displayWeight)
                )
                .foregroundStyle(.blue)
                .interpolationMethod(.catmullRom)
                .symbol(by: .value("Metric", "Weight"))
                
                // Waist Line (Optional)
                if let waist = m.waist {
                    LineMark(
                        x: .value("Date", m.date),
                        y: .value("Waist", waist)
                    )
                    .foregroundStyle(.green)
                    .interpolationMethod(.catmullRom)
                    .symbol(by: .value("Metric", "Waist"))
                }
                
                // Body Fat Line (Optional)
                if let fat = m.bodyFatPercentage {
                    LineMark(
                        x: .value("Date", m.date),
                        y: .value("Body Fat", fat)
                    )
                    .foregroundStyle(.cyan)
                    .interpolationMethod(.catmullRom)
                    .symbol(by: .value("Metric", "Body Fat"))
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartForegroundStyleScale([
            "Weight": .blue,
            "Waist": .green,
            "Body Fat": .cyan
        ])
        .chartLegend(.hidden)
        .frame(height: 250)
        .padding()
    }
}

struct MeasurementHistoryList: View {
    @Environment(\.modelContext) private var modelContext
    let measurements: [BodyMeasurement]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Measurement History")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(measurements.reversed()) { m in
                HistoryRow(m: m)
            }
        }
        .padding(.horizontal)
    }
}

struct HistoryRow: View {
    @Environment(\.modelContext) private var modelContext
    let m: BodyMeasurement
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(m.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                HStack(spacing: 12) {
                    let displayWeight = UserSettings.shared.unitSystem == .imperial ? m.weight * 2.20462 : m.weight
                    let weightUnit = UserSettings.shared.unitSystem == .imperial ? "lbs" : "kg"
                    MetricLabel(value: displayWeight, unit: weightUnit, color: .blue)
                    if let w = m.waist { MetricLabel(value: w, unit: "in", color: .green) }
                    if let f = m.bodyFatPercentage { MetricLabel(value: f, unit: "%", color: .cyan) }
                }
            }
            
            Spacer()
            
            Button(action: { modelContext.delete(m) }) {
                Image(systemName: "trash")
                    .foregroundColor(.red.opacity(0.6))
            }
        }
        .padding()
        .background(Color.white.opacity(0.03))
        .cornerRadius(16)
    }
}




// MARK: - Logging Sheet
struct BodyLogSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var weight: String = ""
    @State private var waist: String = ""
    @State private var bodyFat: String = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 24) {
                    DatePicker("Measurement Date", selection: $date, displayedComponents: .date)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        let weightUnit = UserSettings.shared.unitSystem == .imperial ? "lbs" : "kg"
                        LogField(label: "Weight (\(weightUnit)) *", value: $weight, icon: "scalemass", color: .blue)
                        LogField(label: "Waist (inches)", value: $waist, icon: "ruler", color: .green)
                        LogField(label: "Body Fat (%)", value: $bodyFat, icon: "percent", color: .cyan)
                    }
                    
                    Spacer()
                    
                    Button(action: save) {
                        Text("SAVE MEASUREMENT")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(weight.isEmpty ? Color.gray : Color.cyan)
                            .cornerRadius(12)
                    }
                    .disabled(weight.isEmpty)
                }
                .padding()
                .navigationTitle("Log Body Data")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                }
            }
        }
        .accentColor(.cyan)
    }
    
    func save() {
        guard var w = Double(weight) else { return }
        
        // Always store as kg in the database for consistency
        if UserSettings.shared.unitSystem == .imperial {
            w = w / 2.20462
        }
        
        let new = BodyMeasurement(
            date: date,
            weight: w,
            bodyFatPercentage: Double(bodyFat),
            waist: Double(waist)
        )
        modelContext.insert(new)
        dismiss()
    }
}

struct LogField: View {
    let label: String
    @Binding var value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.caption).foregroundColor(.gray)
            HStack {
                Image(systemName: icon).foregroundColor(color)
                TextField("Enter value", text: $value)
                    .keyboardType(.decimalPad)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

// MARK: - Placeholders for other tabs



struct ProgressPlansTab: View {
    var body: some View {
        VStack(spacing: 16) {
            PlanCard(title: "Workout Plan", planName: "PPL Split", nextEvent: "Legs at 5 PM", icon: "dumbbell.fill", color: .orange, destination: AnyView(Text("Workout Detail")))
            PlanCard(title: "Meal Plan", planName: "Vegan Boost", nextEvent: "Dinner at 7 PM", icon: "leaf.fill", color: .green, destination: AnyView(Text("Meal Detail")))
        }
        .padding(.horizontal)
    }
}

// MARK: - Helper Views

struct OverviewStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.1))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}



struct PlanCard: View {
    let title: String
    let planName: String
    let nextEvent: String
    let icon: String
    let color: Color
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.title3)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(planName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(nextEvent)
                        .font(.caption)
                        .foregroundColor(color)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .bold))
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.1), lineWidth: 1)
            )
        }
    }
}
