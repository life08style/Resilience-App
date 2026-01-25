import Foundation
import SwiftUI
import Combine

enum GoalType: String, Codable, CaseIterable {
    case project = "Project"
    case skill = "Skill"
}

struct RoadmapDay: Identifiable, Codable {
    var id = UUID()
    var dayNumber: Int
    var title: String
    var description: String
    var youtubeLink: String?
    var isCompleted: Bool = false
}

struct RoadmapGoal: Identifiable, Codable {
    var id = UUID()
    var title: String
    var type: GoalType
    var targetDate: Date
    var roadmap: [RoadmapDay]
    var progress: Double {
        guard !roadmap.isEmpty else { return 0 }
        let completed = roadmap.filter { $0.isCompleted }.count
        return Double(completed) / Double(roadmap.count)
    }
}

class GoalStore: ObservableObject {
    static let shared = GoalStore()
    
    @Published var goals: [RoadmapGoal] = []
    
    // Mock Data for Demo
    init() {
        goals = [
            RoadmapGoal(
                title: "Learn SwiftUI",
                type: .skill,
                targetDate: Date().addingTimeInterval(86400 * 30),
                roadmap: [
                    RoadmapDay(dayNumber: 1, title: "Basics of Views", description: "Learn about Text, Image, and Stacks.", youtubeLink: "https://youtube.com/example1", isCompleted: true),
                    RoadmapDay(dayNumber: 2, title: "State & Binding", description: "Understand data flow.", isCompleted: false)
                ]
            ),
            RoadmapGoal(
                title: "Build Portfolio Website",
                type: .project,
                targetDate: Date().addingTimeInterval(86400 * 14),
                roadmap: [
                    RoadmapDay(dayNumber: 1, title: "Design Mockups", description: "Create Figma designs.", isCompleted: false)
                ]
            )
        ]
    }
    
    func addGoal(_ goal: RoadmapGoal) {
        goals.append(goal)
    }
    
    func deleteGoal(at indexSet: IndexSet) {
        goals.remove(atOffsets: indexSet)
    }
}
