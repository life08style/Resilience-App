import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    override private init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleHabitReminder(habitId: UUID, title: String, time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Habit Reminder"
        content.body = "Time to \(title)!"
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "habit-\(habitId.uuidString)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelHabitReminder(habitId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["habit-\(habitId.uuidString)"])
    }
    
    func scheduleSleepReminder(bedtime: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Sleep Time"
        content.body = "It's time to wind down for bed."
        content.sound = .default
        
        // Schedule 30 mins before bedtime
        guard let reminderTime = Calendar.current.date(byAdding: .minute, value: -30, to: bedtime) else { return }
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "sleep-reminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // Handle foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
