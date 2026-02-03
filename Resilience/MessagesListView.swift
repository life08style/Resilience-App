import SwiftUI
import SwiftData

struct MessagesListView: View {
    @Query(sort: \SocialConversation.lastMessageTimestamp, order: .reverse) private var conversations: [SocialConversation]
    @State private var showingNewChat = false
    @StateObject private var socialManager = SocialManager()
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if conversations.isEmpty {
                EmptyStateView(showingNewChat: $showingNewChat)
            } else {
                List {
                    ForEach(conversations) { conversation in
                        NavigationLink(destination: ChatDetailView(conversation: conversation).environmentObject(socialManager)) {
                            ConversationRow(conversation: conversation)
                        }
                        .listRowBackground(Color.black)
                    }
                    .onDelete(perform: deleteConversation)
                }
                .listStyle(PlainListStyle())
            }
            
            // Floating Action Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { showingNewChat = true }) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingNewChat) {
            NewChatView()
                .environmentObject(socialManager)
        }
    }
    
    private func deleteConversation(offsets: IndexSet) {
        // Implementation for deletion would go here using modelContext
        // For now, we'll leave it as a placeholder or implement if needed
    }
}

struct ConversationRow: View {
    let conversation: SocialConversation
    
    var otherParticipantName: String {
        let currentUserId = User.currentUser.id
        guard let index = conversation.participants.firstIndex(where: { $0 != currentUserId }) else {
            return conversation.groupName ?? "Chat"
        }
        return conversation.participantNames[index]
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.gray)
                .frame(width: 50, height: 50)
                .overlay(Text(String(otherParticipantName.prefix(1))).foregroundColor(.white))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(otherParticipantName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(timeAgo(conversation.lastMessageTimestamp))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(conversation.lastMessageText)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
    }
    
    func timeAgo(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct EmptyStateView: View {
    @Binding var showingNewChat: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Messages Yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Start connecting with your friends and share your progress!")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            Button(action: { showingNewChat = true }) {
                Text("Start a Chat")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}
