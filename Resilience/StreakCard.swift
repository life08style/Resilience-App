import SwiftUI

struct StreakCard: View {
    let friendName: String
    let myStreak: Int
    let friendStreak: Int
    let myLastWorkout: Date?
    let friendLastWorkout: Date?
    
    var myStreakIsHigher: Bool { myStreak > friendStreak }
    var friendStreakIsHigher: Bool { friendStreak > myStreak }
    var isEven: Bool { myStreak == friendStreak }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(friendName)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                if isEven && myStreak > 0 {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(.yellow)
                }
            }
            
            HStack(spacing: 16) {
                // My Stats
                VStack {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(myStreakIsHigher ? .green : .orange)
                        Text("\(myStreak)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(myStreakIsHigher ? .green : .white)
                    }
                    Text("Your Streak")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(myStreakIsHigher ? Color.green.opacity(0.1) : Color(UIColor.systemGray6).opacity(0.3))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(myStreakIsHigher ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1)
                )
                
                // Friend Stats
                VStack {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(friendStreakIsHigher ? .blue : .orange)
                        Text("\(friendStreak)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(friendStreakIsHigher ? .blue : .white)
                    }
                    Text("\(friendName)'s Streak")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(friendStreakIsHigher ? Color.blue.opacity(0.1) : Color(UIColor.systemGray6).opacity(0.3))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(friendStreakIsHigher ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 1)
                )
            }
            
            // Status Message
            if myStreakIsHigher {
                Text("🔥 You're ahead!")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            } else if friendStreakIsHigher {
                Text("💪 \(friendName) is winning!")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            } else if isEven && myStreak > 0 {
                Text("🏆 It's a tie!")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
            } else {
                Text("Ready to start your streak?")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.2))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}
