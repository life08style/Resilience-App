import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var calendarManager = CalendarManager.shared
    
    @State private var title = ""
    @State private var type: EventType = .workout
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(3600)
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Title", text: $title)
                    Picker("Type", selection: $type) {
                        ForEach(EventType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.iconName)
                                Text(type.rawValue.capitalized)
                            }
                            .tag(type)
                        }
                    }
                }
                
                Section(header: Text("Time")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                }
                
                Section {
                    Button(action: addEvent) {
                        Text("Add Event")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("New Event")
            .navigationBarItems(leading: Button("Cancel") { dismiss() })
            .preferredColorScheme(.dark)
        }
    }
    
    func addEvent() {
        guard !title.isEmpty else { return }
        
        // Combine date with times
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)
        
        var startComp = calendar.dateComponents([.year, .month, .day], from: date)
        startComp.hour = startComponents.hour
        startComp.minute = startComponents.minute
        
        var endComp = calendar.dateComponents([.year, .month, .day], from: date)
        endComp.hour = endComponents.hour
        endComp.minute = endComponents.minute
        
        guard let finalStart = calendar.date(from: startComp),
              let finalEnd = calendar.date(from: endComp) else { return }
        
        let newEvent = CalendarEvent(
            title: title,
            type: type,
            startTime: finalStart,
            endTime: finalEnd,
            date: date
        )
        
        calendarManager.addEvent(newEvent)
        HapticManager.shared.success()
        dismiss()
    }
}
