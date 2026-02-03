import SwiftUI
import SwiftData

struct ChatDetailView: View {
    @Bindable var conversation: SocialConversation
    @EnvironmentObject var socialManager: SocialManager
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var messageText = ""
    
    // Auto-scroll logic
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    var otherParticipantName: String {
        let currentUserId = User.currentUser.id
        guard let index = conversation.participants.firstIndex(where: { $0 != currentUserId }) else {
            return conversation.groupName ?? "Chat"
        }
        return conversation.participantNames[index]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Text(otherParticipantName)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    // Future: Chat Details/Settings
                }) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.black)
            
            // Messages List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(conversation.messages.sorted(by: { $0.timestamp < $1.timestamp })) { message in
                            MessageBubble(message: message, isCurrentUser: message.senderId == User.currentUser.id)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: conversation.messages.count) {
                    if let lastId = conversation.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
                .onAppear {
                    scrollProxy = proxy
                    // Scroll to bottom on open
                    if let lastId = conversation.messages.last?.id {
                        proxy.scrollTo(lastId, anchor: .bottom)
                    }
                }
            }
            .background(Color(white: 0.1)) // Dark gray background
            
            // Input Area
            HStack(spacing: 10) {
                TextField("Message...", text: $messageText)
                    .padding(10)
                    .background(Color(white: 0.2))
                    .cornerRadius(20)
                    .foregroundColor(.white)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(messageText.isEmpty ? .gray : .blue)
                }
                .disabled(messageText.isEmpty)
            }
            .padding()
            .background(Color.black)
        }
        .navigationBarHidden(true)
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        socialManager.sendMessage(text: messageText, conversation: conversation, context: modelContext)
        messageText = ""
    }
}

struct MessageBubble: View {
    let message: SocialMessage
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser { Spacer() }
            
            Text(message.text)
                .padding(12)
                .background(isCurrentUser ? Color.blue : Color(white: 0.25))
                .foregroundColor(.white)
                .cornerRadius(16)
                .frame(maxWidth: 280, alignment: isCurrentUser ? .trailing : .leading)
            
            if !isCurrentUser { Spacer() }
        }
    }
}
