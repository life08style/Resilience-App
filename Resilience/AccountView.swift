import SwiftUI

struct AccountView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .padding(10)
                        .background(DesignSystem.Colors.surface)
                        .clipShape(Circle())
                }
                Spacer()
                Text("Account Settings")
                    .font(DesignSystem.Fonts.titleMedium())
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                Spacer()
                Color.clear.frame(width: 40, height: 40)
            }
            .padding()
            
            if let user = MockAuthService.shared.currentUser {
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    VStack(spacing: 4) {
                        Text(user.name)
                            .font(DesignSystem.Fonts.headline())
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                        Text(user.email)
                            .font(DesignSystem.Fonts.body())
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(DesignSystem.Colors.surface)
                .cornerRadius(DesignSystem.Layout.cornerRadius)
                .padding(.horizontal)
            }
            
            Spacer()
            
            Button(action: {
                MockAuthService.shared.signOut()
                NotificationCenter.default.post(name: NSNotification.Name("SignOut"), object: nil)
            }) {
                Text("Sign Out")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(DesignSystem.Colors.error)
                    .cornerRadius(DesignSystem.Layout.cornerRadius)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .background(DesignSystem.Colors.background.edgesIgnoringSafeArea(.all))
    }
}
