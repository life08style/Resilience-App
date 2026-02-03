import SwiftUI

struct ResilienceAppBar: View {
    @Environment(\.presentationMode) var presentationMode
    
    var showBackButton: Bool = true
    @State private var showSettings = false
    @State private var showProfile = false
    
    var body: some View {
        ZStack {
            // Left: Back Button
            if showBackButton {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .zIndex(1) // Ensure it's on top
            }

            // Center: Resilience Wordmark
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
                Button(action: { showProfile = true }) {
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
        .sheet(isPresented: $showProfile) {
            NavigationView {
                UserProfileView(user: User.currentUser)
            }
        }
    }
}
