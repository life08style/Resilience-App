import SwiftUI

struct StreakLeaderboard: View {
    @State private var leaderboardData: [LeaderboardEntry] = []
    @State private var isLoading = true
    
    struct LeaderboardEntry: Identifiable {
        let id: String
        let name: String
        let score: Int
    }
    
    var body: some View {
        VStack(spacing: 12) {
            if isLoading {
                ProgressView()
                    .padding()
            } else if leaderboardData.isEmpty {
                VStack {
                    Image(systemName: "trophy")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("Leaderboard is Empty")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding()
            } else {
                ForEach(Array(leaderboardData.enumerated()), id: \.element.id) { index, entry in
                    HStack {
                        Text("\(index + 1)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(rankColor(for: index))
                            .frame(width: 30)
                        
                        Text(entry.name)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(entry.score)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.cyan)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6).opacity(0.2))
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        // Mock data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.leaderboardData = [
                LeaderboardEntry(id: "1", name: "Sarah J.", score: 45),
                LeaderboardEntry(id: "2", name: "Mike T.", score: 32),
                LeaderboardEntry(id: "3", name: "Demo User", score: 12)
            ]
            self.isLoading = false
        }
    }
    
    func rankColor(for index: Int) -> Color {
        switch index {
        case 0: return .yellow
        case 1: return .gray
        case 2: return .orange
        default: return .gray
        }
    }
}
