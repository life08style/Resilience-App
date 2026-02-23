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
    @FocusState private var isSearchFocused: Bool

    // Users matching current query (autofill dropdown)
    var filteredUsers: [User] {
        socialManager.searchResults
    }

    // Whether we're in "suggestions" mode (empty query) vs "autocomplete" mode (typing)
    var isShowingSuggestions: Bool { searchText.isEmpty }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                // ── Search / To: field ──────────────────────────────
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(isSearchFocused ? .blue : .gray)
                            .animation(.easeInOut(duration: 0.2), value: isSearchFocused)

                        TextField("Search username or name…", text: $searchText)
                            .foregroundColor(.white)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .focused($isSearchFocused)
                            .onChange(of: searchText) {
                                socialManager.searchUsers(query: searchText)
                            }

                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .transition(.opacity)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color(white: 0.14))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .animation(.easeInOut(duration: 0.15), value: searchText.isEmpty)

                    // ── Inline autofill chips (appear while typing) ──
                    if !isShowingSuggestions && !filteredUsers.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(filteredUsers.prefix(6)) { user in
                                    Button(action: { startChat(with: user) }) {
                                        HStack(spacing: 6) {
                                            Circle()
                                                .fill(avatarColor(for: user.username))
                                                .frame(width: 22, height: 22)
                                                .overlay(
                                                    Text(String(user.fullName.prefix(1)))
                                                        .font(.system(size: 11, weight: .bold))
                                                        .foregroundColor(.white)
                                                )
                                            Text("@\(user.username)")
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(.white)
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                        )
                                        .cornerRadius(20)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .padding(.top, 8)

                // ── Segments ───────────────────────────────────────
                Picker("", selection: $activeTab) {
                    Text("Search").tag(0)
                    Text("Contacts").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.top, 12)

                Divider()
                    .background(Color(white: 0.2))
                    .padding(.top, 8)

                if activeTab == 0 {
                    searchTab
                } else {
                    contactsTab
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
            .background(
                NavigationLink(isActive: $navigateToChat) {
                    if let conv = createdConversation {
                        ChatDetailView(conversation: conv)
                            .environmentObject(socialManager)
                    }
                } label: { EmptyView() }
            )
        }
        .onAppear {
            contactsManager.checkPermission()
            // Trigger suggestions immediately on appear
            socialManager.searchUsers(query: "")
            isSearchFocused = true
        }
    }

    // MARK: - Search Tab
    @ViewBuilder
    private var searchTab: some View {
        if filteredUsers.isEmpty && !isShowingSuggestions {
            // No results
            VStack(spacing: 12) {
                Spacer()
                Image(systemName: "person.fill.questionmark")
                    .font(.system(size: 44))
                    .foregroundColor(.gray)
                Text("No users found for \"\(searchText)\"")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                Spacer()
            }
        } else {
            List {
                // Section header
                if isShowingSuggestions {
                    Section {
                        ForEach(filteredUsers) { user in
                            userRow(user: user)
                        }
                    } header: {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.blue)
                                .font(.caption)
                            Text("Suggested")
                                .font(.caption)
                                .foregroundColor(.blue)
                                .textCase(nil)
                        }
                    }
                } else {
                    Section {
                        ForEach(filteredUsers) { user in
                            userRow(user: user)
                        }
                    } header: {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .font(.caption)
                            Text("Results")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .textCase(nil)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
        }
    }

    // MARK: - Contacts Tab
    @ViewBuilder
    private var contactsTab: some View {
        if contactsManager.authorizationStatus == .authorized {
            List {
                ForEach(contactsManager.contacts, id: \.identifier) { contact in
                    HStack(spacing: 12) {
                        if let imageData = contact.thumbnailImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(avatarColor(for: contact.givenName))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Text(String(contact.givenName.prefix(1)))
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.white)
                                )
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(contact.givenName) \(contact.familyName)")
                                .foregroundColor(.white)
                                .font(.headline)
                            Text("Invite to App")
                                .foregroundColor(.blue)
                                .font(.subheadline)
                        }
                    }
                    .listRowBackground(Color.black)
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
        } else {
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "person.2.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.gray)
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

    // MARK: - User Row
    @ViewBuilder
    private func userRow(user: User) -> some View {
        Button(action: { startChat(with: user) }) {
            HStack(spacing: 12) {
                Circle()
                    .fill(avatarColor(for: user.username))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text(String(user.fullName.prefix(1)))
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                    )

                VStack(alignment: .leading, spacing: 2) {
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
                    .opacity(0.8)
            }
        }
        .listRowBackground(Color(white: 0.09))
    }

    // MARK: - Helpers
    private func startChat(with user: User) {
        let newConv = socialManager.createConversation(with: user, context: modelContext)
        self.createdConversation = newConv
        self.navigateToChat = true
        dismiss()
    }

    /// Generates a consistent color per username initial
    private func avatarColor(for name: String) -> Color {
        let colors: [Color] = [.blue, .purple, .green, .orange, .pink, .teal, .indigo]
        let index = (name.unicodeScalars.first?.value ?? 0) % UInt32(colors.count)
        return colors[Int(index)]
    }
}
