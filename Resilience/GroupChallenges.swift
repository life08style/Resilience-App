import SwiftUI

struct GroupChallenges: View {
    @State private var challenges: [GroupChallenge] = []
    @State private var filter: String = "active"
    @State private var showAddChallenge = false
    @State private var selectedChallenge: GroupChallenge? = nil

    var filteredChallenges: [GroupChallenge] {
        switch filter {
        case "active":
            return challenges.filter { $0.status == "active" }
        case "my":
            return challenges.filter { $0.participants.contains { $0.userEmail == User.currentUser.email } }
        case "completed":
            return challenges.filter { $0.status == "completed" }
        default:
            return challenges
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            // Header with Plus Button
            HStack {
                 Text("My Challenges")
                     .font(.title2)
                     .fontWeight(.bold)
                     .foregroundColor(.white)
                 
                 Spacer()
                 
                 Button(action: {
                     showAddChallenge = true
                 }) {
                     Image(systemName: "plus.circle.fill")
                         .font(.title2)
                         .foregroundColor(.white)
                 }
             }
             .padding(.horizontal)
             
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
            if filteredChallenges.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "trophy")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("No Challenges Found")
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
            } else {
                ForEach(filteredChallenges) { challenge in
                    ChallengeCard(challenge: challenge, onLongPress: {
                        selectedChallenge = challenge
                    })
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .sheet(isPresented: $showAddChallenge) {
            AddChallengeView { newChallenge in
                var challengeToAdd = newChallenge
                let participant = ChallengeParticipant(
                    userEmail: User.currentUser.email,
                    userName: User.currentUser.fullName,
                    currentProgress: 0,
                    joinedDate: Date()
                )
                challengeToAdd.participants.append(participant)
                self.challenges.append(challengeToAdd)
            }
        }
        .sheet(item: $selectedChallenge) { challenge in
            ChallengeDetailSheet(challenge: challenge)
        }
        .onAppear(perform: loadChallenges)
    }
    
    func loadChallenges() {
        self.challenges = [
            GroupChallenge(
                id: UUID(),
                title: "30-Day Squat Challenge",
                description: "Do squats every day for 30 days to build lower body strength and consistency.",
                category: .exercise,
                challengeType: .streak,
                targetValue: 30,
                durationDays: 30,
                startDate: Date(),
                endDate: Date().addingTimeInterval(30*24*3600),
                participants: [
                    ChallengeParticipant(userEmail: User.currentUser.email, userName: User.currentUser.fullName, currentProgress: 8, joinedDate: Date())
                ],
                status: "active"
            ),
            GroupChallenge(
                id: UUID(),
                title: "7-Day Clean Eating",
                description: "Eat clean whole foods for 7 consecutive days. No processed food allowed.",
                category: .diet,
                challengeType: .streak,
                targetValue: 7,
                durationDays: 7,
                startDate: Calendar.current.date(byAdding: .day, value: -30, to: Date())!,
                endDate: Calendar.current.date(byAdding: .day, value: -23, to: Date())!,
                participants: [],
                status: "completed"
            ),
            GroupChallenge(
                id: UUID(),
                title: "Sleep 8 Hours Challenge",
                description: "Get at least 8 hours of sleep every night for 14 days. Track your sleep with the app.",
                category: .sleep,
                challengeType: .streak,
                targetValue: 14,
                durationDays: 14,
                startDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
                endDate: Calendar.current.date(byAdding: .day, value: 19, to: Date())!,
                participants: [],
                status: "inactive"
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
    var onLongPress: (() -> Void)? = nil

    @State private var isPressed = false

    var isInactive: Bool {
        challenge.status != "active"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(challenge.category.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(4)
                
                Spacer()
                
                Text(challenge.status.capitalized)
                    .font(.caption)
                    .foregroundColor(statusColor)
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

            if isInactive {
                HStack {
                    Image(systemName: "hand.tap.fill")
                        .font(.caption2)
                    Text("Hold to view details")
                        .font(.caption2)
                }
                .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding()
        .background(categoryColor(for: challenge.category).opacity(isInactive ? 0.5 : 1.0))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isInactive ? Color.white.opacity(0.2) : Color.clear, lineWidth: 1)
        )
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: 0.5, pressing: { pressing in
            withAnimation { isPressed = pressing }
        }, perform: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            onLongPress?()
        })
    }

    var statusColor: Color {
        switch challenge.status {
        case "active": return .green
        case "completed": return .yellow
        default: return .gray
        }
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

// MARK: - Challenge Detail Sheet

struct ChallengeDetailSheet: View {
    let challenge: GroupChallenge
    @Environment(\.dismiss) private var dismiss

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, categoryColor(for: challenge.category).opacity(0.4)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // Status Badge
                        HStack {
                            Label(challenge.status.capitalized, systemImage: statusIcon)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(statusColor.opacity(0.2))
                                .foregroundColor(statusColor)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(statusColor.opacity(0.4), lineWidth: 1))

                            Spacer()

                            Text(challenge.category.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.1))
                                .foregroundColor(.white.opacity(0.7))
                                .cornerRadius(12)
                        }

                        // Title & Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text(challenge.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text(challenge.description)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Divider().background(Color.white.opacity(0.2))

                        // Stats Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            DetailStatCard(icon: "target", label: "Target", value: "\(challenge.targetValue)")
                            DetailStatCard(icon: "calendar", label: "Duration", value: "\(challenge.durationDays) days")
                            DetailStatCard(icon: "calendar.badge.clock", label: "Start", value: dateFormatter.string(from: challenge.startDate))
                            DetailStatCard(icon: "flag.checkered", label: "End", value: dateFormatter.string(from: challenge.endDate))
                        }

                        Divider().background(Color.white.opacity(0.2))

                        // Challenge Type
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Challenge Type")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.6))
                                .textCase(.uppercase)

                            HStack(spacing: 10) {
                                Image(systemName: challengeTypeIcon)
                                    .foregroundColor(categoryColor(for: challenge.category))
                                Text(challenge.challengeType.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }

                        // Participants
                        if !challenge.participants.isEmpty {
                            Divider().background(Color.white.opacity(0.2))

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Participants (\(challenge.participants.count))")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.6))
                                    .textCase(.uppercase)

                                ForEach(challenge.participants) { p in
                                    HStack {
                                        Circle()
                                            .fill(categoryColor(for: challenge.category))
                                            .frame(width: 36, height: 36)
                                            .overlay(
                                                Text(String(p.userName.prefix(1)))
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white)
                                            )

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(p.userName)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(.white)
                                            Text("Progress: \(p.currentProgress)")
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.6))
                                        }

                                        Spacer()
                                    }
                                }
                            }
                        }

                        Spacer(minLength: 32)
                    }
                    .padding()
                }
            }
            .navigationTitle("Challenge Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.white)
                }
            }
        }
    }

    var statusColor: Color {
        switch challenge.status {
        case "active": return .green
        case "completed": return .yellow
        default: return .gray
        }
    }

    var statusIcon: String {
        switch challenge.status {
        case "active": return "flame.fill"
        case "completed": return "trophy.fill"
        default: return "clock.fill"
        }
    }

    var challengeTypeIcon: String {
        switch challenge.challengeType {
        case .streak: return "flame.fill"
        case .totalCount: return "number.circle.fill"
        case .weeklyGoal: return "calendar.badge.checkmark"
        }
    }

    func categoryColor(for category: ChallengeCategory) -> Color {
        switch category {
        case .exercise: return .teal
        case .diet: return .green
        case .sleep: return .indigo
        case .productivity: return .orange
        case .mentalHealth: return .blue
        }
    }
}

struct DetailStatCard: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                Text(label)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .textCase(.uppercase)
            }
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.08))
        .cornerRadius(12)
    }
}
