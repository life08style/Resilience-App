import SwiftUI
import SwiftData
import Charts

struct BodyMeasurementsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BodyMeasurement.date, order: .forward) private var measurements: [BodyMeasurement]
    
    @State private var showAddSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Body Metrics")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Track your progress over time")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top)
                
                // Chart Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Weight Trend")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    if measurements.isEmpty {
                        Text("No data available")
                            .foregroundColor(.gray)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(16)
                    } else {
                        Chart {
                            ForEach(measurements) { measurement in
                                LineMark(
                                    x: .value("Date", measurement.date),
                                    y: .value("Weight", measurement.weight)
                                )
                                .foregroundStyle(Color.blue.gradient)
                                .interpolationMethod(.catmullRom)
                                
                                PointMark(
                                    x: .value("Date", measurement.date),
                                    y: .value("Weight", measurement.weight)
                                )
                                .foregroundStyle(Color.white)
                            }
                        }
                        .chartYScale(domain: .automatic(includesZero: false))
                        .frame(height: 200)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal)
                
                // Recent Entries List
                VStack(alignment: .leading, spacing: 16) {
                    Text("History")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    ForEach(measurements.reversed()) { measurement in
                        MeasurementRow(measurement: measurement)
                    }
                }
                
                // Add Button
                Button(action: { showAddSheet = true }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Log Measurement")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(16)
                }
                .padding()
            }
            .padding(.bottom)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationTitle("Measurements")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddSheet) {
            LogMeasurementSheet()
        }
    }
}

struct MeasurementRow: View {
    let measurement: BodyMeasurement
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(formatDate(measurement.date))
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(String(format: "%.1f", measurement.weight)) kg")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            if let fat = measurement.bodyFatPercentage {
                VStack(alignment: .trailing) {
                    Text("Body Fat")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(String(format: "%.1f", fat))%")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct LogMeasurementSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var weight = ""
    @State private var bodyFat = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Details")) {
                    HStack {
                        Text("Weight (kg)")
                        Spacer()
                        TextField("0.0", text: $weight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Body Fat %")
                        Spacer()
                        TextField("Optional", text: $bodyFat)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section {
                    Button(action: saveMeasurement) {
                        Text("Save Measurement")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Log Measurement")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func saveMeasurement() {
        if let weightVal = Double(weight) {
            let fatVal = Double(bodyFat)
            let measurement = BodyMeasurement(
                date: date,
                weight: weightVal,
                bodyFatPercentage: fatVal
            )
            modelContext.insert(measurement)
            dismiss()
        }
    }
}
