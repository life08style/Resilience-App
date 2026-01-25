import SwiftUI

struct StreaksView: View {
    @State private var streaks = [
        StreakItem(title: "Workout Streak", icon: "dumbbell.fill", current: 5, best: 12, color: .teal),
        StreakItem(title: "Meditation Streak", icon: "brain.head.profile", current: 3, best: 7, color: .purple),
        StreakItem(title: "Sleep Streak", icon: "moon.fill", current: 8, best: 8, color: .indigo),
        StreakItem(title: "Nutrition Streak", icon: "fork.knife", current: 2, best: 15, color: .green),
        StreakItem(title: "Productivity Streak", icon: "clock.fill", current: 4, best: 10, color: .orange)
    ]
    
    struct StreakItem: Identifiable {
        let id = UUID()
        let title: String
        let icon: String
        let current: Int
        let best: Int
        let color: Color
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    BluMascotView(customization: BluCustomization.defaultCustomization, size: 80)
                    
                    Text("Your Streaks")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Blu's tracking your champion consistency!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top)
                
                // Overview Stats
                HStack(spacing: 12) {
                    StreakStatBox(title: "Active", value: "5", icon: "flame.fill", color: .orange)
                    StreakStatBox(title: "Avg Streak", value: "4.2", icon: "chart.bar.fill", color: .cyan)
                    StreakStatBox(title: "Total", value: "124", icon: "dumbbell.fill", color: .teal)
                }
                .padding(.horizontal)
                
                // Individual Streaks
                VStack(spacing: 16) {
                    ForEach(streaks) { streak in
                        StreakDetailCard(item: streak)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationTitle("Streaks")
    }
}

struct StreakStatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Image(systemName: icon)
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.2))
        .cornerRadius(12)
    }
}

struct StreakDetailCard: View {
    let item: StreaksView.StreakItem
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: item.icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(item.color)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Keep it up!")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            HStack {
                VStack {
                    Text("\(item.current)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(item.color)
                    Text("Current")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .background(Color.gray)
                
                VStack {
                    Text("\(item.best)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Best")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(item.color.opacity(0.3), lineWidth: 1)
        )
    }
}
