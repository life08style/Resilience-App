import SwiftUI

struct ScheduleTaskSheet: View {
    @Environment(\.dismiss) private var dismiss
    let task: TodoItem
    @State private var selectedDate = Date()
    @State private var includeTime = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    Text(task.text)
                        .font(.headline)
                        .padding(.vertical, 8)
                }
                
                Section(header: Text("Schedule")) {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: [.date])
                    
                    Toggle("Set Time", isOn: $includeTime)
                    
                    if includeTime {
                        DatePicker("Time", selection: $selectedDate, displayedComponents: [.hourAndMinute])
                    }
                }
                
                Section {
                    Button("Save Schedule") {
                        task.date = includeTime ? selectedDate : Calendar.current.startOfDay(for: selectedDate)
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Schedule Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
