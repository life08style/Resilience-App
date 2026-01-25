import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var content = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading) {
                        Text("Yakir") // Use actual user name
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Public")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ZStack(alignment: .topLeading) {
                    if content.isEmpty {
                        Text("What's on your mind?")
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    }
                    
                    TextEditor(text: $content)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color(UIColor.systemGray6).opacity(0.1))
                .cornerRadius(16)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        // Logic to add post would go here
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(content.isEmpty)
                }
            }
        }
    }
}
