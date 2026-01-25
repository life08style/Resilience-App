import SwiftUI
import UIKit

struct DesignSystem {
    struct Colors {
        static let background = Color.black
        static let surface = Color(UIColor.systemGray6).opacity(0.15)
        static let surfaceHighlight = Color(UIColor.systemGray6).opacity(0.3)
        
        static let primary = Color.blue
        static let secondary = Color.purple
        static let accent = Color.cyan
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
        
        static let textPrimary = Color.white
        static let textSecondary = Color.gray
    }
    
    struct Fonts {
        static func titleLarge() -> Font { .system(size: 34, weight: .bold, design: .rounded) }
        static func titleMedium() -> Font { .system(size: 24, weight: .bold, design: .rounded) }
        static func headline() -> Font { .headline }
        static func body() -> Font { .body }
        static func caption() -> Font { .caption }
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 20
        static let padding: CGFloat = 16
    }
}

// MARK: - Global Page Wrapper
struct ResiliencePage<Content: View>: View {
    let showBackButton: Bool
    let content: Content
    
    init(showBackButton: Bool = true, @ViewBuilder content: () -> Content) {
        self.showBackButton = showBackButton
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.edgesIgnoringSafeArea(.all)
            
            content
                .padding(.top, 85) // Raised from 110
            
            ResilienceAppBar(showBackButton: showBackButton)
        }
        .navigationBarHidden(true)
    }
}
// MARK: - Shared UI Components

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
