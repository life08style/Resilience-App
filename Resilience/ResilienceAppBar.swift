import SwiftUI

struct ResilienceAppBar: View {
    @Environment(\.presentationMode) var presentationMode
    
    var showBackButton: Bool = true
    @State private var showMusic = false
    @State private var showAccount = false
    
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
                .zIndex(1)
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
            
            // Right Group: Music + Account
            HStack(spacing: 8) {
                // Music Button
                Button(action: { showMusic = true }) {
                    Image(systemName: "music.note")
                        .font(.system(size: 14))
                        .padding(8)
                        .background(Circle().fill(Color.purple))
                        .foregroundColor(.white)
                }
                
                // Combined Account Button (Settings + Profile)
                Button(action: { showAccount = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 14))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(
                        Capsule().fill(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    )
                    .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color.black.edgesIgnoringSafeArea(.top))
        .sheet(isPresented: $showMusic) {
            MusicLibraryView()
        }
        .sheet(isPresented: $showAccount) {
            NavigationView {
                AccountHubView()
            }
        }
    }
}

/// Combined Account Hub — Profile header + Settings tabs in one sheet
struct AccountHubView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var settings = UserSettings.shared
    @State private var selectedTab: AccountTab = .profile

    enum AccountTab: String, CaseIterable {
        case profile = "Profile"
        case app     = "Settings"
        case sounds  = "Sounds"
        case blu     = "Appearance"

        var icon: String {
            switch self {
            case .profile: return "person.crop.circle.fill"
            case .app:     return "gearshape.fill"
            case .sounds:  return "speaker.wave.3.fill"
            case .blu:     return "paintbrush.fill"
            }
        }
    }

    var body: some View {
        ResiliencePage(showBackButton: true) {
            VStack(spacing: 0) {
                // Tab Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(AccountTab.allCases, id: \.self) { tab in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedTab = tab
                                }
                                HapticManager.shared.selection()
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: tab.icon)
                                        .font(.subheadline)
                                    Text(tab.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(selectedTab == tab ? Color.blue : Color.white.opacity(0.1))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 24)

                // Content
                Group {
                    switch selectedTab {
                    case .profile:
                        MainAccountSettingsView()
                    case .app:
                        GeneralSettingsView()
                    case .sounds:
                        SoundHapticSettingsView()
                    case .blu:
                        BluCustomizationView()
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: selectedTab)

                Spacer()
            }
            .padding(.bottom, 20)
        }
    }
}
