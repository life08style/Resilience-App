import SwiftUI

struct AddBodyMeasurementView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var date = Date()
    @State private var weight = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Date")) {
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("Measurements")) {
                    HStack {
                        Text("Weight")
                        Spacer()
                        TextField("lbs", text: $weight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
                
                Section {
                    Button("Save Entry") {
                        // TODO: Implement save logic
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Log Body Metrics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
