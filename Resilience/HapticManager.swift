import SwiftUI
import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func success() {
        notification(type: .success)
    }
    
    func warning() {
        notification(type: .warning)
    }
    
    func error() {
        notification(type: .error)
    }
}
