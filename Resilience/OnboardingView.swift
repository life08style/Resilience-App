import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            DesignSystem.Colors.background.edgesIgnoringSafeArea(.all)
            
            VStack {
                TabView(selection: $currentPage) {
                    WelcomeStep()
                        .tag(0)
                    
                    GoalsStep()
                        .tag(1)
                    
                    PermissionsStep(onComplete: {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    })
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Page Indicator
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(currentPage == index ? DesignSystem.Colors.primary : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}

struct WelcomeStep: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 80))
                .foregroundColor(DesignSystem.Colors.primary)
            
            VStack(spacing: 12) {
                Text("Welcome to Antigravity")
                    .font(DesignSystem.Fonts.titleLarge())
                    .multilineTextAlignment(.center)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text("Your personal companion for productivity, fitness, and growth.")
                    .font(DesignSystem.Fonts.body())
                    .multilineTextAlignment(.center)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            Text("Swipe to continue →")
                .font(DesignSystem.Fonts.caption())
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .padding(.bottom, 40)
        }
    }
}

struct GoalsStep: View {
    @State private var selectedGoals: Set<String> = []
    let goals = ["Build Muscle", "Lose Weight", "Sleep Better", "Be Productive", "Improve Diet"]
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("What are your goals?")
                .font(DesignSystem.Fonts.titleMedium())
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(goals, id: \.self) { goal in
                    Button(action: {
                        if selectedGoals.contains(goal) {
                            selectedGoals.remove(goal)
                        } else {
                            selectedGoals.insert(goal)
                        }
                        HapticManager.shared.selection()
                    }) {
                        HStack {
                            Text(goal)
                                .fontWeight(.medium)
                            Spacer()
                            if selectedGoals.contains(goal) {
                                Image(systemName: "checkmark.circle.fill")
                            } else {
                                Image(systemName: "circle")
                            }
                        }
                        .padding()
                        .background(selectedGoals.contains(goal) ? DesignSystem.Colors.primary.opacity(0.2) : DesignSystem.Colors.surface)
                        .foregroundColor(selectedGoals.contains(goal) ? DesignSystem.Colors.primary : DesignSystem.Colors.textPrimary)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedGoals.contains(goal) ? DesignSystem.Colors.primary : Color.clear, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

struct PermissionsStep: View {
    var onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 80))
                .foregroundColor(.orange)
            
            VStack(spacing: 12) {
                Text("Stay on Track")
                    .font(DesignSystem.Fonts.titleMedium())
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text("Enable notifications to get reminders for your habits and workouts.")
                    .font(DesignSystem.Fonts.body())
                    .multilineTextAlignment(.center)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            Button(action: {
                NotificationManager.shared.requestPermission()
                onComplete()
            }) {
                Text("Get Started")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(DesignSystem.Colors.primary)
                    .cornerRadius(DesignSystem.Layout.cornerRadius)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }
}
