import SwiftUI

struct AnalyticsHubView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab: AnalyticsTab = .sleep
    
    enum AnalyticsTab: String, CaseIterable {
        case sleep = "Sleep"
        case exercise = "Exercise"
        case diet = "Diet"
        case screen = "Screen Time"
        
        var icon: String {
            switch self {
            case .sleep: return "moon.fill"
            case .exercise: return "dumbbell.fill"
            case .diet: return "leaf.fill"
            case .screen: return "hourglass"
            }
        }
        
        var color: Color {
            switch self {
            case .sleep: return .purple
            case .exercise: return .green
            case .diet: return .orange
            case .screen: return .blue
            }
        }
    }
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            VStack(spacing: 0) {
                // Title Area
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Analytics")
                            .font(DesignSystem.Fonts.titleLarge())
                            .foregroundColor(.white)
                        Text("Deep dive into your data.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                // Custom Tab Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(AnalyticsTab.allCases, id: \.self) { tab in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedTab = tab
                                }
                                HapticManager.shared.selection()
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: tab.icon)
                                        .font(.caption)
                                    Text(tab.rawValue)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                                .background(selectedTab == tab ? tab.color : Color.white.opacity(0.1))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
                
                // Content View
                Group {
                    switch selectedTab {
                    case .sleep:
                        SleepAnalyticsDetailView()
                    case .exercise:
                        ExerciseAnalyticsDetailView()
                    case .diet:
                        DietAnalyticsDetailView()
                    case .screen:
                        ScreenTimeAnalyticsDetailView()
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: selectedTab)
                
                Spacer()
            }
        }
    }
}

#Preview {
    AnalyticsHubView()
}
