import SwiftUI
import SwiftData

struct AICoachView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ChatMessage.timestamp) private var messages: [ChatMessage]
    
    @State private var inputText = ""
    @State private var isTyping = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text("AI Coach")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Always online")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                Spacer()
                
                Button(action: clearHistory) {
                    Image(systemName: "trash")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6).opacity(0.2))
            
            // Chat Area
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        
                        if isTyping {
                            HStack {
                                TypingIndicator()
                                Spacer()
                            }
                            .padding(.horizontal)
                            .id("typing")
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { oldValue, newValue in
                    if let last = messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: isTyping) { oldValue, typing in
                    if typing {
                        withAnimation {
                            proxy.scrollTo("typing", anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input Area
            HStack(spacing: 12) {
                TextField("Ask me anything...", text: $inputText)
                    .padding(12)
                    .background(Color(UIColor.systemGray6).opacity(0.3))
                    .cornerRadius(20)
                    .foregroundColor(.white)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(inputText.isEmpty ? .gray : .blue)
                }
                .disabled(inputText.isEmpty || isTyping)
            }
            .padding()
            .background(Color(UIColor.systemGray6).opacity(0.1))
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    func sendMessage() {
        let userMsg = ChatMessage(text: inputText, isUser: true, timestamp: Date())
        modelContext.insert(userMsg)
        let currentInput = inputText
        inputText = ""
        isTyping = true
        
        Task {
            do {
                let responseText = try await AIService.shared.sendMessage(history: messages, newMessage: currentInput)
                let aiMsg = ChatMessage(text: responseText, isUser: false, timestamp: Date())
                
                await MainActor.run {
                    isTyping = false
                    modelContext.insert(aiMsg)
                }
            } catch {
                await MainActor.run {
                    isTyping = false
                    let errorMsg = ChatMessage(text: "Sorry, I'm having trouble connecting. Please check your internet or API key.", isUser: false, timestamp: Date())
                    modelContext.insert(errorMsg)
                }
            }
        }
    }
    
    func clearHistory() {
        try? modelContext.delete(model: ChatMessage.self)
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.text)
                .padding(12)
                .background(message.isUser ? Color.blue : Color(UIColor.systemGray6).opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(16)
                .clipShape(RoundedCorner(radius: 16, corners: message.isUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight]))
            
            if !message.isUser { Spacer() }
        }
    }
}

struct TypingIndicator: View {
    @State private var numberOfDots = 0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.gray)
                    .frame(width: 6, height: 6)
                    .opacity(numberOfDots == index ? 1 : 0.3)
            }
        }
        .padding(12)
        .background(Color(UIColor.systemGray6).opacity(0.3))
        .cornerRadius(16)
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.5).repeatForever()) {
                self.numberOfDots = 2
            }
        }
    }
}

