import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var schedules: [SleepSchedule]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack(alignment: .top) {
                    Color.black.edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        Spacer().frame(height: 60) // Space for AppBar
                        
                        // We need to fit 3 rows of height ~200 each + spacing. Total height > 600.
                        // On smaller phones this might still be tight. Using Flexible Grid.
                        
                        let cardHeight = (geo.size.height - 80 - 100) / 3 // Available height / 3 rows approx
                        
                        LazyVGrid(columns: columns, spacing: 12) {
                            // 1. Sleep
                            NavigationLink(destination: SleepView()) {
                                MenuCard(
                                    title: "Sleep",
                                    subtitle: schedules.first(where: { $0.isEnabled }).map { "\(formatTime($0.bedtime)) - \(formatTime($0.wakeTime))" } ?? "No schedule",
                                    imageName: "SleepCategory",
                                    icon: "moon.fill",
                                    overlayColor: .purple
                                )
                                .frame(height: cardHeight)
                            }
                            
                            // 2. Exercise
                            NavigationLink(destination: ExerciseView()) {
                                MenuCard(
                                    title: "Exercise",
                                    subtitle: "",
                                    imageName: "ExerciseCategory",
                                    icon: "dumbbell.fill",
                                    overlayColor: .orange
                                )
                                .frame(height: cardHeight)
                            }
                            
                            // 3. Diet
                            NavigationLink(destination: DietView()) {
                                MenuCard(
                                    title: "Diet",
                                    subtitle: "",
                                    imageName: "DietCategory",
                                    icon: "leaf.fill",
                                    overlayColor: .green
                                )
                                .frame(height: cardHeight)
                            }
                            
                            // 4. Habits
                            NavigationLink(destination: HabitTrackerView()) {
                                MenuCard(
                                    title: "Habits",
                                    subtitle: "",
                                    imageName: "HabitsCategory",
                                    icon: "checkmark.square.fill",
                                    overlayColor: .blue
                                )
                                .frame(height: cardHeight)
                            }
                            
                            // 5. Productivity
                            NavigationLink(destination: ProjectsView()) { 
                                MenuCard(
                                    title: "Productivity",
                                    subtitle: "",
                                    imageName: "TimeCategory",
                                    icon: "clock.fill",
                                    overlayColor: .yellow
                                )
                                .frame(height: cardHeight)
                            }
                            
                            // 6. Analytics & Insights
                            NavigationLink(destination: AnalyticsHubView()) {
                                MenuCard(
                                    title: "Analytics & Insights",
                                    subtitle: "",
                                    imageName: "AnalyticsCategory",
                                    icon: "chart.bar.xaxis",
                                    overlayColor: .indigo
                                )
                                .frame(height: cardHeight)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        Spacer()
                        
                        // Mascot Overlay (Bottom Right of Grid)
                        HStack {
                            Spacer()
                            BluMascotView(customization: BluStore.shared.customization, size: 80)
                                .offset(x: 10, y: -40)
                        }
                        .padding(.trailing, 20)
                    }
                    
                    // Fixed Header
                    ResilienceAppBar(showBackButton: false)
                }
                .navigationBarHidden(true)
            }
        }
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct MenuCard: View {
    let title: String
    let subtitle: String
    let imageName: String
    let icon: String
    let overlayColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Icon Overlay (Top Left)
            HStack {
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                Spacer()
            }
            .padding(12)
            
            Spacer()
            
            // Text Content (Bottom Left)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            .padding(16)
        }
        // .frame(height: 200) //  REMOVED FIXED HEIGHT
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                overlayColor.opacity(0.4)
                
                LinearGradient(colors: [.black.opacity(0.6), .clear], startPoint: .bottom, endPoint: .center)
            }
        )
        .cornerRadius(24)
        .clipped() // Crucial to prevent image overflow
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

extension Optional {
    func map<T>(_ transform: (Wrapped) -> T) -> T? {
        if let value = self {
            return transform(value)
        }
        return nil
    }
}
