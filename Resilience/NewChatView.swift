import SwiftUI
import SwiftData
import Contacts

struct NewChatView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var socialManager: SocialManager
    @StateObject private var contactsManager = ContactsManager()
    
    @State private var searchText = ""
    @State private var activeTab = 0 // 0: Search, 1: Contacts
    @State private var selectedUser: User?
    @State private var navigateToChat = false
    @State private var createdConversation: SocialConversation?
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search username", text: $searchText)
                        .foregroundColor(.white)
                        .onChange(of: searchText) {
                            socialManager.searchUsers(query: searchText)
                        }
                }
                .padding()
                .background(Color(white: 0.15))
                .cornerRadius(10)
                .padding()
                
                // Segments
                Picker("", selection: $activeTab) {
                    Text("Search").tag(0)
                    Text("Contacts").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if activeTab == 0 {
                    // Search Results
                    List {
                        ForEach(socialManager.searchResults) { user in
                            Button(action: { startChat(with: user) }) {
                                HStack {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 40, height: 40)
                                        .overlay(Text(String(user.fullName.prefix(1))).foregroundColor(.white))
                                    
                                    VStack(alignment: .leading) {
                                        Text(user.fullName)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        Text("@\(user.username)")
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                    Image(systemName: "message.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .listRowBackground(Color.black)
                        }
                    }
                    .listStyle(PlainListStyle())
                } else {
                    // Contacts List
                    if contactsManager.authorizationStatus == .authorized {
                        List {
                            ForEach(contactsManager.contacts, id: \.identifier) { contact in
                                HStack {
                                    if let imageData = contact.thumbnailImageData, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                    } else {
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(width: 40, height: 40)
                                            .overlay(Text(String(contact.givenName.prefix(1))).foregroundColor(.white))
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(contact.givenName) \(contact.familyName)")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        // Mock status
                                        Text("Invite to App")
                                            .foregroundColor(.blue)
                                            .font(.subheadline)
                                    }
                                }
                                .listRowBackground(Color.black)
                            }
                        }
                        .listStyle(PlainListStyle())
                    } else {
                        VStack(spacing: 20) {
                            Spacer()
                            Text("Find friends from your contacts")
                                .foregroundColor(.gray)
                            Button("Sync Contacts") {
                                contactsManager.requestAccess()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            Spacer()
                        }
                    }
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.white)
                }
            }
            // Invisible Navigation Link to handle push
            .background(
                NavigationLink(isActive: $navigateToChat) {
                    if let conv = createdConversation {
                        ChatDetailView(conversation: conv)
                            .environmentObject(socialManager) // Pass explicity if needed, though usually inherited if in hierarchy
                    }
                } label: { EmptyView() }
            )
        }
        .onAppear {
            contactsManager.checkPermission()
        }
    }
    
    private func startChat(with user: User) {
        let newConv = socialManager.createConversation(with: user, context: modelContext)
        self.createdConversation = newConv
        self.navigateToChat = true
        // In this specific flow (sheet -> nav), we might want to just dismiss and let the parent handle navigation,
        // but for simplicity, we'll navigate within the sheet or dismiss if we can pass the ID back.
        // Better UX: Dismiss this sheet and navigate on the main stack.
        // For MVP: Navigate here, or simpler: Close sheet and user sees it in list.
        dismiss()
    }
}
