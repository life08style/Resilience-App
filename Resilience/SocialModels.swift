import Foundation
import SwiftData

// MARK: - Social Messaging Models

@Model
class SocialConversation {
    @Attribute(.unique) var id: UUID
    var participants: [String] // User IDs or usernames
    var participantNames: [String] // Display names for UI
    var lastMessageText: String
    var lastMessageTimestamp: Date
    var unreadCount: Int
    var isGroup: Bool
    var groupName: String?
    
    @Relationship(deleteRule: .cascade) var messages: [SocialMessage] = []
    
    init(id: UUID = UUID(), participants: [String], participantNames: [String], lastMessageText: String = "", lastMessageTimestamp: Date = Date(), unreadCount: Int = 0, isGroup: Bool = false, groupName: String? = nil) {
        self.id = id
        self.participants = participants
        self.participantNames = participantNames
        self.lastMessageText = lastMessageText
        self.lastMessageTimestamp = lastMessageTimestamp
        self.unreadCount = unreadCount
        self.isGroup = isGroup
        self.groupName = groupName
    }
}

@Model
class SocialMessage {
    @Attribute(.unique) var id: UUID
    var senderId: String
    var text: String
    var timestamp: Date
    var isRead: Bool
    var conversationId: UUID?
    
    // Relationship back to conversation
    @Relationship var conversation: SocialConversation?
    
    init(id: UUID = UUID(), senderId: String, text: String, timestamp: Date = Date(), isRead: Bool = false) {
        self.id = id
        self.senderId = senderId
        self.text = text
        self.timestamp = timestamp
        self.isRead = isRead
    }
}
