import SwiftUI

struct DaySchedule: View {
    let date: Date
    let events: [CalendarEvent]
    
    private let hourHeight: CGFloat = 60
    private let startHour = 0
    private let endHour = 24
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ZStack(alignment: .topLeading) {
                    // Time Grid
                    VStack(spacing: 0) {
                        ForEach(startHour..<endHour, id: \.self) { hour in
                            HStack(alignment: .top) {
                                Text(formatHour(hour))
                                    .font(.system(size: 11, weight: .medium, design: .rounded))
                                    .foregroundColor(.gray.opacity(0.8))
                                    .frame(width: 50, alignment: .trailing)
                                    .offset(y: -7)
                                
                                Rectangle()
                                    .fill(Color.white.opacity(0.08))
                                    .frame(height: 0.5)
                            }
                            .frame(height: hourHeight, alignment: .top)
                            .id(hour)
                        }
                    }
                    
                    // Events
                    ForEach(events) { event in
                        EventView(event: event, hourHeight: hourHeight)
                    }
                    
                    // Current Time Indicator
                    if Calendar.current.isDateInToday(date) {
                        CurrentTimeLine(hourHeight: hourHeight)
                    }
                }
                .padding(.vertical)
            }
            .onAppear {
                if Calendar.current.isDateInToday(date) {
                    let hour = Calendar.current.component(.hour, from: Date())
                    // Scroll to current hour, centering it slightly
                    withAnimation {
                        proxy.scrollTo(hour, anchor: .center)
                    }
                }
            }
        }
    }
    
    func formatHour(_ hour: Int) -> String {
        let h = hour % 12
        let ampm = hour < 12 ? "AM" : "PM"
        return "\(h == 0 ? 12 : h):00 \(ampm)"
    }
}

struct EventView: View {
    let event: CalendarEvent
    let hourHeight: CGFloat
    
    var topOffset: CGFloat {
        let calendar = Calendar.current
        let hour = CGFloat(calendar.component(.hour, from: event.startTime))
        let minute = CGFloat(calendar.component(.minute, from: event.startTime))
        return (hour + minute / 60) * hourHeight
    }
    
    var height: CGFloat {
        let duration = event.endTime.timeIntervalSince(event.startTime)
        return CGFloat(duration / 3600) * hourHeight
    }
    
    var body: some View {
        Group {
            if let recipeId = event.linkedRecipeId, event.type == .meal,
               let recipe = RecipeDatabase.shared.recipes.first(where: { $0.id == recipeId }) {
                NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                    eventContent
                }
            } else if event.type == .workout {
                NavigationLink(destination: WorkoutSessionView()) {
                    eventContent
                }
            } else if event.type == .sleep {
                NavigationLink(destination: SleepView()) {
                    eventContent
                }
            } else {
                eventContent
            }
        }
        .frame(height: max(height, 22))
        .padding(.leading, 60)
        .padding(.trailing, 12)
        .offset(y: topOffset)
    }
    
    private var eventContent: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(eventColor(for: event.type))
                .frame(width: 3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(eventColor(for: event.type))
                
                Text(formatTime(event.startTime))
                    .font(.system(size: 9))
                    .foregroundColor(eventColor(for: event.type).opacity(0.8))
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(eventColor(for: event.type).opacity(0.12))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(eventColor(for: event.type).opacity(0.2), lineWidth: 0.5)
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
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct CurrentTimeLine: View {
    let hourHeight: CGFloat
    
    var topOffset: CGFloat {
        let calendar = Calendar.current
        let now = Date()
        let hour = CGFloat(calendar.component(.hour, from: now))
        let minute = CGFloat(calendar.component(.minute, from: now))
        return (hour + minute / 60) * hourHeight
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Circle()
                .fill(Color.red)
                .frame(width: 10, height: 10)
                .background(Circle().fill(Color.black))
            
            Rectangle()
                .fill(Color.red)
                .frame(height: 1.5)
        }
        .padding(.leading, 45)
        .offset(y: topOffset)
    }
}
