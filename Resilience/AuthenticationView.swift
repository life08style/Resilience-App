import SwiftUI

struct AuthenticationView: View {
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showError = false
    
    // Callback to notify App that auth is successful
    var onAuthSuccess: () -> Void
    
    var body: some View {
        ZStack {
            DesignSystem.Colors.background.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                // Logo / Branding
                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 60))
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    Text("Antigravity")
                        .font(DesignSystem.Fonts.titleLarge())
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    
                    Text(isLoginMode ? "Welcome Back" : "Create Account")
                        .font(DesignSystem.Fonts.body())
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
                .padding(.top, 60)
                
                // Form Fields
                VStack(spacing: 16) {
                    if !isLoginMode {
                        CustomTextField(icon: "person.fill", placeholder: "Full Name", text: $name)
                    }
                    
                    CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    CustomSecureField(icon: "lock.fill", placeholder: "Password", text: $password)
                }
                .padding(.horizontal)
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(DesignSystem.Colors.error)
                        .font(DesignSystem.Fonts.caption())
                }
                
                // Action Button
                Button(action: handleAuth) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text(isLoginMode ? "Sign In" : "Sign Up")
                                .fontWeight(.bold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(DesignSystem.Colors.primary)
                    .foregroundColor(.white)
                    .cornerRadius(DesignSystem.Layout.cornerRadius)
                }
                .disabled(isLoading)
                .padding(.horizontal)
                
                // Toggle Mode
                Button(action: {
                    withAnimation {
                        isLoginMode.toggle()
                        showError = false
                        errorMessage = ""
                    }
                }) {
                    Text(isLoginMode ? "Don't have an account? Sign Up" : "Already have an account? Sign In")
                        .font(DesignSystem.Fonts.body())
                        .foregroundColor(DesignSystem.Colors.primary)
                }
                
                Spacer()
            }
        }
    }
    
    func handleAuth() {
        isLoading = true
        showError = false
        
        Task {
            do {
                if isLoginMode {
                    _ = try await MockAuthService.shared.login(email: email, password: password)
                } else {
                    _ = try await MockAuthService.shared.signUp(name: name, email: email, password: password)
                }
                
                await MainActor.run {
                    isLoading = false
                    HapticManager.shared.notification(type: .success)
                    onAuthSuccess()
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Authentication failed. Please try again."
                    showError = true
                    HapticManager.shared.notification(type: .error)
                }
            }
        }
    }
}

struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .frame(width: 24)
            TextField(placeholder, text: $text)
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
        .padding()
        .background(DesignSystem.Colors.surface)
        .cornerRadius(DesignSystem.Layout.cornerRadius)
    }
}

struct CustomSecureField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .frame(width: 24)
            SecureField(placeholder, text: $text)
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
        .padding()
        .background(DesignSystem.Colors.surface)
        .cornerRadius(DesignSystem.Layout.cornerRadius)
    }
}
