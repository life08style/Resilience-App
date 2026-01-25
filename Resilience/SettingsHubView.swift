import SwiftUI

struct SettingsHubView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settings = UserSettings.shared
    @State private var selectedTab: SettingsTab = .account
    
    enum SettingsTab: String, CaseIterable {
        case account = "Account"
        case blu = "Blu"
        case app = "App"
        case sounds = "Sounds"
        
        var icon: String {
            switch self {
            case .account: return "person.crop.circle.fill"
            case .blu: return "paintbrush.fill"
            case .app: return "gearshape.fill"
            case .sounds: return "speaker.wave.3.fill"
            }
        }
    }
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            VStack(spacing: 0) {
                // Title & Header
                HStack {
                    Text("Settings")
                        .font(DesignSystem.Fonts.titleLarge())
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                // Custom Top Tab Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(SettingsTab.allCases, id: \.self) { tab in
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
                
                // Content Switcher
                // We use ZStack + Opacity or just Switch. Switch is better for lifecycle if views are heavy, 
                // but these are settings screens, so it's fine.
                // Using a Transition for smooth switching
                
                Group {
                    switch selectedTab {
                    case .account:
                        MainAccountSettingsView()
                    case .blu:
                        BluCustomizationView()
                    case .app:
                        GeneralSettingsView()
                    case .sounds:
                        SoundHapticSettingsView()
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

#Preview {
    SettingsHubView()
}
