import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView()
            .background(WindowEdgeSwipeInstaller())
    }
}
