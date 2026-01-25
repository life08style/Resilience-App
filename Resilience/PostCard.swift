import SwiftUI

struct PostCard: View {
    let post: SocialPost
    @State private var isLiked = false
    @State private var likeCount: Int
    @State private var showComments = false
    
    init(post: SocialPost) {
        self.post = post
        _likeCount = State(initialValue: post.likes)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(post.createdByName.prefix(1)))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    )
                
                VStack(alignment: .leading) {
                    Text(post.createdByName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text(timeAgo(from: post.createdDate))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                }
            }
            
            // Content
            Text(post.content)
                .font(.body)
                .foregroundColor(.white)
            
            if let imageUrl = post.imageUrl {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 200)
                .cornerRadius(12)
                .clipped()
            }
            
            Divider().background(Color.gray.opacity(0.3))
            
            // Actions
            HStack(spacing: 24) {
                Button(action: {
                    withAnimation(.spring()) {
                        isLiked.toggle()
                        likeCount += isLiked ? 1 : -1
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .gray)
                        Text("\(likeCount)")
                    }
                }
                
                Button(action: { showComments.toggle() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.right")
                        Text("\(post.comments)")
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            .foregroundColor(.gray)
            .font(.subheadline)
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.1))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.05), lineWidth: 1))
        .sheet(isPresented: $showComments) {
            NavigationView {
                Text("Comments coming soon")
                    .foregroundColor(.gray)
                    .navigationTitle("Comments")
                    .toolbar {
                        Button("Close") { showComments = false }
                    }
            }
            .presentationDetents([.medium, .large])
        }
    }
    
    func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
