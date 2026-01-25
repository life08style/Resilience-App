import SwiftUI

struct MainAccountSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            ScrollView {
                VStack(spacing: 32) {
                    // Profile Section
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 100, height: 100)
                            
                            Text("YL")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text("Yakir Lieberman")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            Text("yakir.lieberman@gmail.com")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top)
                    
                    // Account Details
                    VStack(alignment: .leading, spacing: 0) {
                        Text("ACCOUNT DETAILS")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.leading)
                            .padding(.bottom, 8)
                        
                        VStack(spacing: 0) {
                            AccountRow(label: "Username", value: "yakir_l")
                            Divider().background(Color.white.opacity(0.1)).padding(.leading, 16)
                            AccountRow(label: "Membership", value: "Pro Lifetime")
                            Divider().background(Color.white.opacity(0.1)).padding(.leading, 16)
                            AccountRow(label: "Join Date", value: "Jan 2024")
                        }
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    
                    // Security
                    VStack(alignment: .leading, spacing: 0) {
                        Text("SECURITY")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.leading)
                            .padding(.bottom, 8)
                        
                        VStack(spacing: 0) {
                            AccountRow(label: "Password", value: "••••••••")
                            Divider().background(Color.white.opacity(0.1)).padding(.leading, 16)
                            AccountRow(label: "Two-Factor", value: "Enabled")
                        }
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    
                    Button(action: { /* Sign Out Logic */ }) {
                        Text("Sign Out")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct AccountRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding()
    }
}

#Preview {
    MainAccountSettingsView()
}
