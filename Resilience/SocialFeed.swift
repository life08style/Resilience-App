import SwiftUI

struct SocialFeed: View {
    @State private var posts: [SocialPost] = []
    @State private var achievements: [ActivityFeedItem] = []
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView()
                    .padding()
            } else if posts.isEmpty && achievements.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "trophy")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("No activity yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Complete a workout to share your first achievement!")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
            } else {
                LazyVStack(spacing: 16) {
                    // Combine and sort posts and achievements by date
                    let combinedItems = (
                        posts.map { FeedItem.post($0) } +
                        achievements.map { FeedItem.achievement($0) }
                    ).sorted { $0.date > $1.date }
                    
                    ForEach(combinedItems.indices, id: \.self) { index in
                        switch combinedItems[index] {
                        case .post(let post):
                            PostCard(post: post)
                        case .achievement(let achievement):
                            WorkoutAchievementCard(achievement: achievement)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear(perform: loadFeed)
    }
    
    func loadFeed() {
        // Mock data loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.posts = [
                SocialPost(id: UUID(), createdBy: "user2", createdByName: "Sarah J.", createdDate: Date().addingTimeInterval(-3600), content: "Just finished a 5k run! Feeling great.", imageUrl: "https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=800&h=600&fit=crop", likes: 12, comments: 3)
            ]
            self.achievements = [
                ActivityFeedItem(id: UUID(), createdBy: "user3", createdByName: "Mike T.", activityDate: Date().addingTimeInterval(-7200), type: "workout_complete", title: "Morning Workout", description: "Completed a 30 min strength session.", data: ["Duration": "30m", "Calories": "320"])
            ]
            self.isLoading = false
        }
    }
}

enum FeedItem {
    case post(SocialPost)
    case achievement(ActivityFeedItem)
    
    var date: Date {
        switch self {
        case .post(let post): return post.createdDate
        case .achievement(let item): return item.activityDate
        }
    }
}
