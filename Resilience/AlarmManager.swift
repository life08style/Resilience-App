import Foundation
import UserNotifications
import SwiftUI
import SwiftData
import Combine

/// Centralized alarm manager responsible for scheduling, cancelling,
/// and tracking the firing state of alarms.
class AlarmManager: ObservableObject {
    static let shared = AlarmManager()
    
    /// When true the alarm is currently ringing and the app should present AlarmActiveView
    @Published var alarmFiring: Bool = false
    
    /// The schedule whose alarm is currently firing (used by AlarmActiveView)
    @Published var firingSchedule: SleepSchedule?
    
    /// Snooze duration in minutes
    let snoozeDuration: Int = 5
    
    private init() {
        registerNotificationCategory()
    }
    
    // MARK: - Notification Category
    
    private func registerNotificationCategory() {
        let dismissAction = UNNotificationAction(
            identifier: "DISMISS_ACTION",
            title: "Dismiss",
            options: [.destructive]
        )
        let snoozeAction = UNNotificationAction(
            identifier: "SNOOZE_ACTION",
            title: "Snooze (5 min)",
            options: []
        )
        
        let alarmCategory = UNNotificationCategory(
            identifier: "ALARM",
            actions: [snoozeAction, dismissAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([alarmCategory])
    }
    
    // MARK: - Schedule Alarm
    
    /// Schedule local notifications for each enabled day of the given SleepSchedule
    func scheduleAlarm(for schedule: SleepSchedule) {
        // Cancel existing first
        cancelAlarm(for: schedule)
        
        guard schedule.isEnabled else { return }
        
        let calendar = Calendar.current
        let wakeComponents = calendar.dateComponents([.hour, .minute], from: schedule.wakeTime)
        
        guard let hour = wakeComponents.hour, let minute = wakeComponents.minute else { return }
        
        // Map day strings to weekday numbers (1 = Sunday … 7 = Saturday)
        let dayMap: [String: Int] = [
            "sun": 1, "mon": 2, "tue": 3, "wed": 4,
            "thu": 5, "fri": 6, "sat": 7
        ]
        
        let daysToSchedule = schedule.days.isEmpty ? Array(dayMap.keys) : schedule.days
        
        for day in daysToSchedule {
            guard let weekday = dayMap[day.lowercased()] else { continue }
            
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.weekday = weekday
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let content = UNMutableNotificationContent()
            content.title = "⏰ Wake Up!"
            content.body = schedule.name.isEmpty ? "Time to wake up!" : "\(schedule.name) — Time to wake up!"
            content.sound = .defaultCritical
            content.categoryIdentifier = "ALARM"
            content.userInfo = ["scheduleId": schedule.id.uuidString]
            
            let requestId = "alarm-\(schedule.id.uuidString)-\(weekday)"
            let request = UNNotificationRequest(identifier: requestId, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Failed to schedule alarm: \(error)")
                }
            }
        }
        
        print("✅ Scheduled alarm for \(schedule.name) at \(hour):\(String(format: "%02d", minute))")
    }
    
    /// Cancel all alarms for a schedule
    func cancelAlarm(for schedule: SleepSchedule) {
        let dayMap = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
        let ids = dayMap.enumerated().map { "alarm-\(schedule.id.uuidString)-\($0.offset + 1)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
        print("❌ Cancelled alarms for \(schedule.name)")
    }
    
    // MARK: - Fire / Dismiss
    
    /// Call this when the alarm notification triggers while app is in foreground
    func fireAlarm(schedule: SleepSchedule) {
        DispatchQueue.main.async {
            self.firingSchedule = schedule
            self.alarmFiring = true
            SoundManager.shared.playAlarm(named: schedule.alarmSound)
        }
    }
    
    /// Dismiss the currently firing alarm
    func dismissAlarm() {
        DispatchQueue.main.async {
            SoundManager.shared.stopAlarm()
            self.alarmFiring = false
            self.firingSchedule = nil
        }
    }
    
    /// Snooze the alarm for snoozeDuration minutes
    func snoozeAlarm() {
        guard let schedule = firingSchedule else { return }
        
        SoundManager.shared.stopAlarm()
        alarmFiring = false
        
        // Schedule a one-shot notification for snooze
        let content = UNMutableNotificationContent()
        content.title = "⏰ Snooze Over!"
        content.body = "Your alarm is ringing again!"
        content.sound = .defaultCritical
        content.categoryIdentifier = "ALARM"
        content.userInfo = ["scheduleId": schedule.id.uuidString]
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(snoozeDuration * 60),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "snooze-\(schedule.id.uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Next Alarm Info
    
    /// Returns a formatted string for the next alarm time from any enabled schedule
    func nextAlarmTimeString(from schedules: [SleepSchedule]) -> String? {
        guard let next = schedules.first(where: { $0.isEnabled }) else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: next.wakeTime)
    }
}
