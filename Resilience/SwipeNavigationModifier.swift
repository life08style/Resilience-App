import SwiftUI
import UIKit

// Notification posted when an edge-swipe occurs but there is nothing to pop.
extension Notification.Name {
    static let navigateToHome = Notification.Name("navigateToHome")
}

// MARK: - Global Edge Swipe Manager

/// Installs a single UIScreenEdgePanGestureRecognizer on the app window.
/// • When a navigation stack has views to pop → re-enables the system pop gesture and defers to it.
/// • When at a root view → posts `navigateToHome` so the TabView switches to tab 0.
final class EdgeSwipeManager: NSObject, UIGestureRecognizerDelegate {
    static let shared = EdgeSwipeManager()
    private var installed = false

    func installIfNeeded(in window: UIWindow) {
        guard !installed else { return }
        installed = true

        let gesture = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(handleEdgePan(_:))
        )
        gesture.edges = .left
        gesture.delegate = self
        window.addGestureRecognizer(gesture)
    }

    // MARK: Handler

    @objc private func handleEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        guard gesture.state == .ended else { return }
        // If we reach here, gestureRecognizerShouldBegin returned true → nothing to pop
        NotificationCenter.default.post(name: .navigateToHome, object: nil)
    }

    // MARK: Delegate

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let window = gestureRecognizer.view as? UIWindow else { return false }

        if let topNav = Self.findTopNavigationController(from: window.rootViewController) {
            // Always re-enable the system interactive pop (hidden nav bar disables it)
            topNav.interactivePopGestureRecognizer?.delegate = nil
            topNav.interactivePopGestureRecognizer?.isEnabled = true

            if topNav.viewControllers.count > 1 {
                // Let the system interactive pop handle the swipe-back
                return false
            }
        }
        // Nothing to pop → our gesture will fire → go home
        return true
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer
    ) -> Bool { true }

    // MARK: - VC Hierarchy Helpers

    static func findTopNavigationController(from vc: UIViewController?) -> UINavigationController? {
        guard let vc = vc else { return nil }

        // Presented modal takes priority
        if let presented = vc.presentedViewController {
            if let nav = findTopNavigationController(from: presented) { return nav }
        }

        if let tab = vc as? UITabBarController {
            return findTopNavigationController(from: tab.selectedViewController)
        }

        if let nav = vc as? UINavigationController {
            // Check children of the top VC for an embedded nav controller
            if let topVC = nav.topViewController, let child = findNavInChildren(topVC) {
                return child
            }
            return nav
        }

        for child in vc.children {
            if let nav = findTopNavigationController(from: child) { return nav }
        }
        return nil
    }

    private static func findNavInChildren(_ vc: UIViewController) -> UINavigationController? {
        for child in vc.children {
            if let nav = child as? UINavigationController { return nav }
            if let nav = findNavInChildren(child) { return nav }
        }
        return nil
    }
}

// MARK: - Window Installer (placed once, in ContentView)

/// A tiny invisible UIView whose only job is to find its window and install the edge gesture.
struct WindowEdgeSwipeInstaller: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let v = UIView(frame: .zero)
        v.isUserInteractionEnabled = false
        v.backgroundColor = .clear
        return v
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let window = uiView.window {
                EdgeSwipeManager.shared.installIfNeeded(in: window)
            }
        }
    }
}

// MARK: - Legacy enableSwipeBack (kept for ResiliencePage compatibility)

struct SwipeNavigationModifier: ViewModifier {
    func body(content: Content) -> some View {
        content // no-op now; the window-level gesture handles everything
    }
}

extension View {
    func enableSwipeBack() -> some View {
        self.modifier(SwipeNavigationModifier())
    }
}
