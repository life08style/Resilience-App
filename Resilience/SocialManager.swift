import SwiftData
import SwiftUI
import Combine

class SocialManager: ObservableObject {
    // Mock Users Database
    let mockUsers: [User] = [
        User(id: "user_001", email: "sarah@example.com", fullName: "Sarah Connor", username: "sarahC", language: "en", leaderboardScore: 1540),
        User(id: "user_002", email: "john@example.com", fullName: "John Doe", username: "johndoe", language: "en", leaderboardScore: 1200),
        User(id: "user_003", email: "mike@example.com", fullName: "Mike Ross", username: "mikeross", language: "en", leaderboardScore: 980),
        User(id: "user_004", email: "rachel@example.com", fullName: "Rachel Green", username: "rachelg", language: "en", leaderboardScore: 1100),
        User(id: "user_005", email: "ross@example.com", fullName: "Ross Geller", username: "dinolover", language: "en", leaderboardScore: 890)
    ]
    
    @Published var searchResults: [User] = []
    
    // In a real app, modelContext would be passed in or managed by a singleton data provider.
    // For this implementation, we will perform operations assuming we have access to context in the View.
    
    func searchUsers(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        searchResults = mockUsers.filter { user in
            user.username.localizedCaseInsensitiveContains(query) ||
            user.fullName.localizedCaseInsensitiveContains(query)
        }
    }
    
    func createConversation(with user: User, context: ModelContext) -> SocialConversation {
        // Check if conversation already exists (simplified check)
        // In a real app, query SwiftData for existing conversation with these participants
        
        let newConv = SocialConversation(
            participants: [User.currentUser.id, user.id],
            participantNames: [User.currentUser.fullName, user.fullName],
            lastMessageText: "Started a conversation",
            lastMessageTimestamp: Date(),
            unreadCount: 0
        )
        
        context.insert(newConv)
        return newConv
    }
    
    func sendMessage(text: String, conversation: SocialConversation, context: ModelContext) {
        let message = SocialMessage(
            senderId: User.currentUser.id,
            text: text,
            timestamp: Date(),
            isRead: true
        )
        
        message.conversation = conversation
        conversation.messages.append(message)
        conversation.lastMessageText = text
        conversation.lastMessageTimestamp = Date()
        
        // Simulate reply after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.receiveMockReply(conversation: conversation, context: context)
        }
    }
    
    private func receiveMockReply(conversation: SocialConversation, context: ModelContext) {
        let replies = ["That sounds great!", "How are you doing?", "Keep up the good work!", "Let's catch up soon.", "Nice!"]
        let randomReply = replies.randomElement() ?? "Hello!"
        
        let otherUserId = conversation.participants.first(where: { $0 != User.currentUser.id }) ?? "unknown"
        
        let message = SocialMessage(
            senderId: otherUserId,
            text: randomReply,
            timestamp: Date(),
            isRead: false
        )
        
        message.conversation = conversation
        conversation.messages.append(message)
        conversation.lastMessageText = randomReply
        conversation.lastMessageTimestamp = Date()
        conversation.unreadCount += 1
    }
}
