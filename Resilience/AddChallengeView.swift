import SwiftUI

struct AddChallengeView: View {
    @Environment(\.presentationMode) var presentationMode
    var onAdd: (GroupChallenge) -> Void
    
    let availableChallenges: [GroupChallenge] = [
        GroupChallenge(
            id: UUID(),
            title: "Hydration Hero",
            description: "Drink 8 glasses of water daily",
            category: .diet, // Assuming diet broadly covers consumption
            challengeType: .streak,
            targetValue: 8,
            durationDays: 7,
            startDate: Date(),
            endDate: Date().addingTimeInterval(7*24*3600),
            participants: [],
            status: "active"
        ),
        GroupChallenge(
            id: UUID(),
            title: "Early Bird",
            description: "Wake up before 7 AM",
            category: .sleep,
            challengeType: .streak,
            targetValue: 7,
            durationDays: 14,
            startDate: Date(),
            endDate: Date().addingTimeInterval(14*24*3600),
            participants: [],
            status: "active"
        ),
        GroupChallenge(
            id: UUID(),
            title: "Meditation Master",
            description: "Meditate for 10 minutes",
            category: .mentalHealth,
            challengeType: .streak,
            targetValue: 10,
            durationDays: 21,
            startDate: Date(),
            endDate: Date().addingTimeInterval(21*24*3600),
            participants: [],
            status: "active"
        ),
        GroupChallenge(
            id: UUID(),
            title: "Step It Up",
            description: "Walk 10,000 steps",
            category: .exercise,
            challengeType: .streak,
            targetValue: 10000,
            durationDays: 30,
            startDate: Date(),
            endDate: Date().addingTimeInterval(30*24*3600),
            participants: [],
            status: "active"
        ),
        GroupChallenge(
            id: UUID(),
            title: "Focus Flow",
            description: "2 hours of deep work",
            category: .productivity,
            challengeType: .streak,
            targetValue: 2,
            durationDays: 5,
            startDate: Date(),
            endDate: Date().addingTimeInterval(5*24*3600),
            participants: [],
            status: "active"
        )
    ]
    
    var body: some View {
        NavigationView {
            List(availableChallenges) { challenge in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(challenge.title)
                            .font(.headline)
                        Text(challenge.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        onAdd(challenge)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Add Challenge")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
