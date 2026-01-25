import SwiftUI

struct GroupChallenges: View {
    @State private var challenges: [GroupChallenge] = []
    @State private var filter: String = "active"
    
    var body: some View {
        VStack(spacing: 16) {
            // Filter Tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterButton(title: "Active", icon: "flame.fill", isSelected: filter == "active") { filter = "active" }
                    FilterButton(title: "Mine", icon: "target", isSelected: filter == "my") { filter = "my" }
                    FilterButton(title: "Done", icon: "trophy.fill", isSelected: filter == "completed") { filter = "completed" }
                }
                .padding(.horizontal)
            }
            
            // Challenges List
            if challenges.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "trophy")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("No Challenges Found")
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
            } else {
                ForEach(challenges) { challenge in
                    ChallengeCard(challenge: challenge)
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .onAppear(perform: loadChallenges)
    }
    
    func loadChallenges() {
        // Mock data
        self.challenges = [
            GroupChallenge(
                id: UUID(),
                title: "30-Day Squat Challenge",
                description: "Do squats every day for 30 days",
                category: .exercise,
                challengeType: .streak,
                targetValue: 30,
                durationDays: 30,
                startDate: Date(),
                endDate: Date().addingTimeInterval(30*24*3600),
                participants: [],
                status: "active"
            )
        ]
    }
}

struct FilterButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color(UIColor.systemGray6).opacity(0.3))
            .foregroundColor(isSelected ? .white : .gray)
            .cornerRadius(20)
        }
    }
}

struct ChallengeCard: View {
    let challenge: GroupChallenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(challenge.category.rawValue.capitalized)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(4)
                
                Spacer()
                
                Text(challenge.status.capitalized)
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            Text(challenge.title)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(challenge.description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(2)
            
            HStack {
                Label("\(challenge.targetValue)", systemImage: "target")
                Spacer()
                Label("\(challenge.durationDays) days", systemImage: "calendar")
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding()
        .background(categoryColor(for: challenge.category))
        .cornerRadius(16)
    }
    
    func categoryColor(for category: ChallengeCategory) -> Color {
        switch category {
        case .exercise: return .teal.opacity(0.8)
        case .diet: return .green.opacity(0.8)
        case .sleep: return .indigo.opacity(0.8)
        case .productivity: return .orange.opacity(0.8)
        case .mentalHealth: return .blue.opacity(0.8)
        }
    }
}
