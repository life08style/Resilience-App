import Foundation
import SwiftUI

struct UserProfile: Codable {
    let id: String
    let email: String
    let name: String
}

protocol AuthServiceProtocol {
    var currentUser: UserProfile? { get }
    func login(email: String, password: String) async throws -> UserProfile
    func signUp(name: String, email: String, password: String) async throws -> UserProfile
    func signOut()
}

class MockAuthService: AuthServiceProtocol {
    static let shared = MockAuthService()
    
    @AppStorage("mock_user_session") private var sessionData: Data?
    
    var currentUser: UserProfile? {
        if let data = sessionData {
            return try? JSONDecoder().decode(UserProfile.self, from: data)
        }
        return nil
    }
    
    func login(email: String, password: String) async throws -> UserProfile {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        if password == "password" {
            let user = UserProfile(id: UUID().uuidString, email: email, name: "Test User")
            saveSession(user)
            return user
        } else {
            throw AuthError.invalidCredentials
        }
    }
    
    func signUp(name: String, email: String, password: String) async throws -> UserProfile {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let user = UserProfile(id: UUID().uuidString, email: email, name: name)
        saveSession(user)
        return user
    }
    
    func signOut() {
        sessionData = nil
    }
    
    private func saveSession(_ user: UserProfile) {
        if let data = try? JSONEncoder().encode(user) {
            sessionData = data
        }
    }
}

enum AuthError: Error {
    case invalidCredentials
    case unknown
}
