import SwiftUI

struct WorkoutAchievementCard: View {
    let achievement: ActivityFeedItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Circle()
                    .fill(Color.teal)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading) {
                    Text(achievement.createdByName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text(achievement.title)
                        .font(.caption)
                        .foregroundColor(.teal)
                }
                
                Spacer()
                
                Text(timeAgo(from: achievement.activityDate))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(achievement.description)
                .font(.body)
                .foregroundColor(.white)
            
            // Data visualization placeholder
            if let data = achievement.data {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(data.keys.sorted(), id: \.self) { key in
                        HStack {
                            Text(key.capitalized)
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(data[key] ?? "")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemGray6).opacity(0.1), Color.teal.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.teal.opacity(0.3), lineWidth: 1)
        )
    }
    
    func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
