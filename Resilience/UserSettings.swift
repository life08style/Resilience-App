import SwiftUI
import Combine

class UserSettings: ObservableObject {
    static let shared = UserSettings()
    
    enum UnitSystem: String {
        case metric, imperial
    }
    
    @Published var unitSystem: UnitSystem = .imperial
    
    // Music Integration
    @Published var preferredMusicService: String = "apple_music" // "apple_music" or "spotify"
    
    // Health & Notifications
    @Published var healthConnected: Bool = false
    @Published var notificationsEnabled: Bool = true
    
    // Sounds & Haptics
    @Published var soundVolume: Double = 0.8
    @Published var hapticsEnabled: Bool = true
}
