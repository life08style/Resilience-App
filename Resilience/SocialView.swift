import SwiftUI

struct SocialView: View {
    @State private var activeTab = "feed"
    @State private var user = User.currentUser
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Persistent Profile Header
                ResilienceAppBar(showBackButton: false)
                
                SocialProfileHeader(user: user)
                    .padding()
                    .background(Color.black)
                
                // Tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        SocialTabButton(title: "Feed", icon: "activity", isActive: activeTab == "feed") { activeTab = "feed" }
                        SocialTabButton(title: "Leaderboard", icon: "trophy", isActive: activeTab == "leaderboard") { activeTab = "leaderboard" }
                        SocialTabButton(title: "Challenges", icon: "person.3", isActive: activeTab == "challenges") { activeTab = "challenges" }
                        SocialTabButton(title: "Messages", icon: "message", isActive: activeTab == "messages") { activeTab = "messages" }
                    }
                    .padding()
                }
                .background(Color.black)
                
                // Content
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    
                    if activeTab == "feed" {
                        SocialFeed()
                    } else if activeTab == "leaderboard" {
                        ScrollView {
                            StreakLeaderboard()
                                .padding(.bottom, 100)
                        }
                    } else if activeTab == "challenges" {
                        ScrollView {
                            GroupChallenges()
                                .padding(.bottom, 100)
                        }
                    } else {
                        VStack {
                            Spacer()
                            Image(systemName: "bubble.left.and.bubble.right")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                                .padding()
                            Text("Messages Coming Soon")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        .accentColor(.white) // Ensure back buttons are white
    }
}
