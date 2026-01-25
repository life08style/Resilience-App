import SwiftUI

struct UserProfileView: View {
    let user: User
    @State private var showCreatePost = false
    @State private var showEditProfile = false
    
    // Mock user posts
    @State private var userPosts: [SocialPost] = [
        SocialPost(id: UUID(), createdBy: "user1", createdByName: "Yakir", createdDate: Date().addingTimeInterval(-86400), content: "Just hit a new PR on the bench press! 🚀", imageUrl: nil, likes: 24, comments: 5),
        SocialPost(id: UUID(), createdBy: "user1", createdByName: "Yakir", createdDate: Date().addingTimeInterval(-172800), content: "Morning run views 🌅", imageUrl: "https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=800&h=600&fit=crop", likes: 45, comments: 8)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Profile Info
                VStack(spacing: 16) {
                    ZStack(alignment: .bottomTrailing) {
                        // Profile Image with Gradient Border
                        Circle()
                            .stroke(
                                LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing),
                                lineWidth: 3
                            )
                            .frame(width: 108, height: 108)
                            .overlay(
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 100, height: 100)
                            )
                            .overlay(
                                Text(String(user.fullName.prefix(1)))
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                            )
                        
                        // Edit/Camera Badge
                        Button(action: { showEditProfile = true }) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 14, weight: .bold))
                                .padding(8)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                                .overlay(Circle().stroke(Color.black, lineWidth: 3))
                        }
                        .offset(x: 4, y: 4)
                    }
                    
                    VStack(spacing: 6) {
                        Text(user.fullName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("@\(user.username)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding(.top, 30)
                
                // Stats Row (Glassmorphic)
                HStack(spacing: 0) {
                    ProfileStatBox(value: "\(userPosts.count)", label: "Posts")
                    Divider().background(Color.gray.opacity(0.3)).frame(height: 30)
                    ProfileStatBox(value: "1", label: "Friends") // Mock
                    Divider().background(Color.gray.opacity(0.3)).frame(height: 30)
                    ProfileStatBox(value: "\(user.leaderboardScore)", label: "Score")
                }
                .padding(.vertical, 16)
                .background(Color.white.opacity(0.05))
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
                .padding(.horizontal)
                
                // Action Buttons
                HStack(spacing: 16) {
                    Button(action: { showEditProfile = true }) {
                        Text("Edit Profile")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                    }
                    
                    Button(action: { showCreatePost = true }) {
                        Text("Share Moment")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(12)
                            .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.horizontal)
                
                // Posts Feed Section
                VStack(spacing: 0) {
                    HStack {
                        Text("Recent Activity")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    if userPosts.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "camera.on.rectangle")
                                .font(.system(size: 40))
                                .foregroundColor(.gray.opacity(0.5))
                            Text("No moments shared yet")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(userPosts) { post in
                                PostCard(post: post)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.bottom, 100)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationTitle("")
        .navigationBarHidden(false)
        .sheet(isPresented: $showCreatePost) {
            CreatePostView()
        }
    }
}

struct ProfileStatBox: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}
