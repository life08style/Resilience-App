import SwiftUI

struct ResilienceAppBar: View {
    @Environment(\.presentationMode) var presentationMode
    
    var showBackButton: Bool = true
    @State private var showSettings = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Left Group: Back Button ONLY (or empty spacer if root)
            HStack(spacing: 12) {
                if showBackButton {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .bold)) // Slightly larger
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Circle().fill(Color.white.opacity(0.1)))
                    }
                } else {
                    // Placeholder to balance layout if needed, or just nothing
                    Color.clear.frame(width: 40, height: 40)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Center Group: Resilience Wordmark
            Text("Resilience")
                .font(.system(size: 22, weight: .black, design: .rounded))
                .tracking(1)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Color(white: 0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .white.opacity(0.2), radius: 5, x: 0, y: 0)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Right Group: Music, Gear, User
            HStack(spacing: 8) {
                Button(action: {}) {
                    Image(systemName: "music.note")
                        .font(.system(size: 14))
                        .padding(8)
                        .background(Circle().fill(Color.purple))
                        .foregroundColor(.white)
                }
                
                Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 14))
                        .padding(8)
                        .background(Circle().fill(Color.gray))
                        .foregroundColor(.white)
                }
                
                // User Button (Now on Right)
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .stroke(
                                LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing),
                                lineWidth: 2
                            )
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle()
                                    .fill(Color.black)
                                    .padding(1)
                            )
                        
                        Text("U")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color.black.edgesIgnoringSafeArea(.top))
        .sheet(isPresented: $showSettings) {
            NavigationView {
                SettingsHubView()
            }
        }
    }
}
