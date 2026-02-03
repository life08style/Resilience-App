import SwiftUI
import SwiftData

@main
struct ResilienceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            SleepSchedule.self,
            TodoItem.self,
            MealPlan.self,
            WorkoutSession.self,
            BodyMeasurement.self,
            Habit.self,
            HabitLog.self,
            SavedRecipe.self,
            ChatMessage.self,
            PantryItem.self,
            CartItem.self,
            DailyNutritionLog.self,
            SleepLog.self,
            ExerciseLog.self,
            ScreenTimeLog.self,
            SocialConversation.self,
            SocialMessage.self
        ])
    }
}
