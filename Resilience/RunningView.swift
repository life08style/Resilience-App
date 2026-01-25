import SwiftUI

struct RunWorkout: Identifiable, Codable {
    var id = UUID()
    let title: String
    let description: String
    let distance: String
    let duration: Int
    let difficulty: String
}

// Extension to help with simple storage
extension RunWorkout {
    // Generate a consistent ID based on title for this simple app
    var stableID: String { title }
}

// RunRecord removed (defined in Models.swift)

struct RunningView: View {
    @State private var selectedDuration: Int? = nil
    @State private var selectedDifficulty: String? = nil
    @AppStorage("completedRuns") private var completedRunsString: String = ""
    @ObservedObject var settings = UserSettings.shared
    
    var completedRunIds: [String] {
        completedRunsString.components(separatedBy: ",")
    }
    
    let workouts: [RunWorkout] = [
        RunWorkout(title: "Easy Challenge", description: "A great starting point to build consistency.", distance: "2 km", duration: 15, difficulty: "easy"),
        RunWorkout(title: "Medium Challenge", description: "Push your endurance with a solid 5km run.", distance: "5 km", duration: 35, difficulty: "difficult"),
        RunWorkout(title: "Pro Challenge", description: "The ultimate test of stamina and speed.", distance: "10 km", duration: 60, difficulty: "pro"),
        RunWorkout(title: "Morning Boost", description: "A quick run to energize your day.", distance: "2 km", duration: 10, difficulty: "easy"),
        RunWorkout(title: "Quick Sprint", description: "Short but intense speed workout.", distance: "1 km", duration: 5, difficulty: "difficult"),
        RunWorkout(title: "Recovery Run", description: "Easy pace for active recovery.", distance: "3 km", duration: 25, difficulty: "easy")
    ]
    

    
    var filteredWorkouts: [RunWorkout] {
        workouts.filter { workout in
            let durationMatch = selectedDuration == nil || workout.duration <= selectedDuration!
            let difficultyMatch = selectedDifficulty == nil || workout.difficulty == selectedDifficulty
            return durationMatch && difficultyMatch
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Hero Section
                        ZStack(alignment: .bottomLeading) {
                            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1551632811-561732d1e306?w=800")) { image in
                                image.resizable().aspectRatio(contentMode: .fill)
                            } placeholder: { Color.gray }
                            .frame(height: 200)
                            .clipped()
                            .overlay(LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom))
                            .cornerRadius(16)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Conquer Your Summit")
                                    .font(.title2).fontWeight(.bold).foregroundColor(.white)
                                Text("Every step forward is progress toward your peak")
                                    .font(.subheadline).foregroundColor(.white.opacity(0.9))
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        
                        // Start Free Run Button
                        NavigationLink(destination: ActiveRunView(mode: "gps")) {
                            HStack {
                                Image(systemName: "location.fill")
                                Text("Start Free Run").fontWeight(.bold)
                                Text("Track with GPS").font(.caption).opacity(0.8)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [.teal, .blue], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        // Filters
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                // Duration Filter
                                Menu {
                                    Button("All Durations") { selectedDuration = nil }
                                    Button("< 15 min") { selectedDuration = 15 }
                                    Button("< 30 min") { selectedDuration = 30 }
                                    Button("< 60 min") { selectedDuration = 60 }
                                } label: {
                                    FilterPill(text: selectedDuration == nil ? "Duration" : "< \(selectedDuration!) min")
                                }
                                
                                // Difficulty Filter
                                Menu {
                                    Button("All Levels") { selectedDifficulty = nil }
                                    Button("Easy") { selectedDifficulty = "easy" }
                                    Button("Difficult") { selectedDifficulty = "difficult" }
                                    Button("Pro") { selectedDifficulty = "pro" }
                                } label: {
                                    FilterPill(text: selectedDifficulty == nil ? "Difficulty" : selectedDifficulty!.capitalized)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Workout List
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Guided Runs (\(filteredWorkouts.count))")
                                .font(.headline).foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ForEach(filteredWorkouts) { workout in
                                let isCompleted = completedRunIds.contains(workout.stableID)
                                
                                NavigationLink(destination: ActiveRunView(mode: "guided", workout: workout)) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 6) {
                                            HStack {
                                                Text(workout.title)
                                                    .font(.headline)
                                                    .foregroundColor(isCompleted ? .black : .white)
                                                
                                                if isCompleted {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(.green)
                                                }
                                                
                                                Spacer()
                                                
                                                Text(workout.difficulty.uppercased())
                                                    .font(.caption2).fontWeight(.bold)
                                                    .padding(4)
                                                    .background(Color.black.opacity(0.2))
                                                    .cornerRadius(4)
                                                    .foregroundColor(isCompleted ? .black : .white)
                                            }
                                            
                                            Text(workout.description)
                                                .font(.caption)
                                                .foregroundColor(isCompleted ? .black.opacity(0.7) : .gray)
                                                .multilineTextAlignment(.leading)
                                            
                                            HStack(spacing: 12) {
                                                Label("\(workout.duration) min", systemImage: "clock")
                                                let dist = settings.unitSystem == .imperial ? convertKmToMiles(workout.distance) : workout.distance
                                                Label(dist, systemImage: "arrow.up.right")
                                            }
                                            .font(.caption)
                                            .foregroundColor(isCompleted ? .black.opacity(0.7) : .gray)
                                        }
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(isCompleted ? .black.opacity(0.5) : .gray)
                                    }
                                    .padding()
                                    // GREEN HIGHLIGHT logic
                                    .background(isCompleted ? Color.green : Color(UIColor.systemGray6).opacity(0.1))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    func convertKmToMiles(_ kmString: String) -> String {
        let components = kmString.components(separatedBy: " ")
        guard components.count >= 1, let km = Double(components[0]) else { return kmString }
        let miles = km * 0.621371
        return String(format: "%.1f miles", miles)
    }
}

struct FilterPill: View {
    let text: String
    var body: some View {
        HStack {
            Text(text)
            Image(systemName: "chevron.down")
        }
        .padding(.horizontal, 12).padding(.vertical, 6)
        .background(Color.gray.opacity(0.2))
        .foregroundColor(.white)
        .cornerRadius(20)
    }
}
