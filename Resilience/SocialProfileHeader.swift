import SwiftUI

struct SocialProfileHeader: View {
    let user: User
    
    var body: some View {
        NavigationLink(destination: UserProfileView(user: user)) {
            HStack(spacing: 16) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 56, height: 56)
                    
                    Text(String(user.fullName.prefix(1)))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .overlay(
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                )
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.fullName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Text("\(user.leaderboardScore)")
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                            Text("Score")
                                .foregroundColor(.gray)
                        }
                        
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 4, height: 4)
                        
                        Text("1 Friend") // Mocked for now, dynamic later
                            .foregroundColor(.blue)
                    }
                    .font(.caption)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(UIColor.systemGray6).opacity(0.15))
            .cornerRadius(16)
        }
    }
}
