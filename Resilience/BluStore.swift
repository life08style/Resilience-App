import SwiftUI
import Combine

class BluStore: ObservableObject {
    static let shared = BluStore()
    
    @Published var customization: BluCustomization = BluCustomization.defaultCustomization
    
    // Additional state related to the mascot or simple global state
    @Published var isHappy = true
}
