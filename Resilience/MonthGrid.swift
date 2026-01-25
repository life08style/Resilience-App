import SwiftUI

struct MonthGrid: View {
    @Binding var currentDate: Date
    @Binding var selectedDate: Date
    let events: [CalendarEvent]
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 12) {
            // Days Header
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Grid
            let days = generateDaysInMonth(for: currentDate)
            let rows = days.chunked(into: 7)
            
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(spacing: 8) {
                    ForEach(rows[rowIndex], id: \.self) { date in
                        if let date = date {
                            DayCell(
                                date: date,
                                isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                isToday: calendar.isDateInToday(date),
                                events: events.filter { calendar.isDate($0.date, inSameDayAs: date) }
                            )
                            .onTapGesture {
                                selectedDate = date
                            }
                        } else {
                            Color.clear
                                .frame(maxWidth: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
            }
        }
    }
    
    func generateDaysInMonth(for date: Date) -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let offset = firstWeekday - 1
        
        var days: [Date?] = Array(repeating: nil, count: offset)
        
        for day in 1...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        // Fill remaining cells to complete the last row
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        return days
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let events: [CalendarEvent]
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.subheadline)
                .fontWeight(isSelected || isToday ? .bold : .regular)
                .foregroundColor(isSelected ? .white : (isToday ? .blue : .white))
            
            HStack(spacing: 2) {
                ForEach(events.prefix(3)) { event in
                    Circle()
                        .fill(eventColor(for: event.type))
                        .frame(width: 4, height: 4)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .background(isSelected ? Color.blue.opacity(0.15) : Color.clear)
        .cornerRadius(12)
        .overlay(
            ZStack {
                if isToday {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 28, height: 28)
                        .offset(y: -8)
                }
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 1)
            }
        )
    }
    
    func eventColor(for type: EventType) -> Color {
        switch type {
        case .meal: return .green
        case .workout: return .teal
        case .work: return .blue
        case .sleep: return .indigo
        case .freeWrite: return .yellow
        case .todo: return .gray
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
