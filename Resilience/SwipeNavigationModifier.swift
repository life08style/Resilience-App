import SwiftUI
import UIKit

struct SwipeNavigationModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                SwipeNavigationControllerRepresentable()
            )
    }
}

struct SwipeNavigationControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Enable swipe back even if navigation bar is hidden
        uiViewController.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        uiViewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

extension View {
    func enableSwipeBack() -> some View {
        self.modifier(SwipeNavigationModifier())
    }
}
