import Foundation
import Combine

class CalendarManager: ObservableObject {
    static let shared = CalendarManager()
    
    @Published var events: [CalendarEvent] = []
    
    private init() {
        loadMockEvents()
    }
    
    func addEvent(_ event: CalendarEvent) {
        events.append(event)
    }
    
    func scheduleMeal(recipe: RecipeModel, date: Date) {
        let event = CalendarEvent(
            title: "Meal: \(recipe.title)",
            type: .meal,
            startTime: date,
            endTime: date.addingTimeInterval(1800), // 30 min
            date: date,
            linkedRecipeId: recipe.id,
            recipeTitle: recipe.title
        )
        addEvent(event)
    }
    
    private func loadMockEvents() {
        let now = Date()
        events = [
            CalendarEvent(title: "Morning Run", type: .workout, startTime: now.addingTimeInterval(-3600), endTime: now, date: now),
            CalendarEvent(title: "Team Meeting", type: .work, startTime: now.addingTimeInterval(3600), endTime: now.addingTimeInterval(7200), date: now),
            CalendarEvent(title: "Lunch", type: .meal, startTime: now.addingTimeInterval(7200), endTime: now.addingTimeInterval(9000), date: now)
        ]
    }
}
