import SwiftUI
import SwiftData

// MARK: - Main Views
struct ProductivityDashboardView: View {
    @State private var selectedTab = 0
    @State private var showAdd = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab Picker
            Picker("", selection: $selectedTab) {
                Text("Projects").tag(0)
                Text("Skills").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(Color.black)
            
            if selectedTab == 0 {
                GoalListView(title: "Projects", goals: GoalStore.shared.goals.filter { $0.type == .project })
            } else {
                GoalListView(title: "Skills", goals: GoalStore.shared.goals.filter { $0.type == .skill })
            }
        }
        .navigationTitle("Productivity")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAdd = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.cyan)
                }
            }
        }
        .sheet(isPresented: $showAdd) {
            AddGoalSheet(type: selectedTab == 0 ? .project : .skill)
        }
    }
}

// MARK: - Reusable List
struct GoalListView: View {
    let title: String
    let goals: [RoadmapGoal]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if goals.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: title == "Projects" ? "hammer.fill" : "brain.head.profile")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No \(title) yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Tap + to create a new roadmap.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(goals) { goal in
                            NavigationLink(destination: RoadmapDetailView(goal: goal)) {
                                GoalCard(goal: goal)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GoalCard: View {
    let goal: RoadmapGoal
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(goal.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack {
                    Text("\(goal.roadmap.count) steps")
                    Spacer()
                    Text(String(format: "%.0f%% Complete", goal.progress * 100))
                }
                .font(.caption)
                .foregroundColor(.gray)
                
                ProgressView(value: goal.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: goal.type == .project ? .blue : .purple))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Add Sheet (AI & Manual)
struct AddGoalSheet: View {
    let type: GoalType
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = "AI Generate"
    
    // AI Inputs
    @State private var goalName = ""
    @State private var targetDate = Date()
    @State private var isGenerating = false
    
    // Manual Inputs
    @State private var manualName = ""
    
    var body: some View {
        // ... (body remains same as original)
        NavigationView {
            VStack(spacing: 0) {
                Picker("", selection: $selectedTab) {
                    Text("AI Roadmap").tag("AI Generate")
                    Text("Regular Build").tag("Manual Build")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedTab == "AI Generate" {
                    Form {
                        Section(header: Text("Goal Details")) {
                            TextField("I want to...", text: $goalName)
                            DatePicker("Complete by", selection: $targetDate, displayedComponents: .date)
                        }
                        
                        Section(footer: Text("AI will generate a step-by-step roadmap with YouTube resources.")) {
                            Button(action: generateRoadmap) {
                                HStack {
                                    if isGenerating {
                                        ProgressView().padding(.trailing, 8)
                                    }
                                    Text(isGenerating ? "Generating..." : "Generate Roadmap")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isGenerating ? Color.gray : (type == .project ? Color.blue : Color.purple))
                                .cornerRadius(8)
                            }
                            .disabled(isGenerating || goalName.isEmpty)
                        }
                    }
                } else {
                    Form {
                        Section(header: Text("Goal Details")) {
                            TextField("Name", text: $manualName)
                        }
                        
                        Section {
                            Button("Create Example Template") {
                                generateManualTemplate()
                            }
                            .disabled(manualName.isEmpty)
                        }
                    }
                }
            }
            .navigationTitle("New \(type.rawValue)")
            .navigationBarItems(leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() })
        }
    }
    
    func generateRoadmap() {
        isGenerating = true
        let goalId = UUID()
        let query = goalName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Mock AI Delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let steps = [
                RoadmapDay(dayNumber: 1, title: "\(goalName): Fundamentals", description: "Master the basics of \(goalName) through foundational theory and initial practice.", youtubeLink: "https://youtube.com/results?search_query=\(query)+tutorial+fundamentals"),
                RoadmapDay(dayNumber: 2, title: "Building the Core", description: "Implement the primary components and establish your workflow.", youtubeLink: "https://youtube.com/results?search_query=\(query)+core+workflow"),
                RoadmapDay(dayNumber: 3, title: "Intermediate Techniques", description: "Apply more advanced principles to refine your progress.", youtubeLink: "https://youtube.com/results?search_query=\(query)+advanced+techniques"),
                RoadmapDay(dayNumber: 4, title: "Final Polish & Review", description: "Review your work, fix details, and finalize the \(type.rawValue).", youtubeLink: "https://youtube.com/results?search_query=\(query)+final+touches")
            ]
            
            let newGoal = RoadmapGoal(id: goalId, title: goalName, type: type, targetDate: targetDate, roadmap: steps)
            GoalStore.shared.addGoal(newGoal)
            
            // Add Day 1 Task to TodoList
            let firstTask = TodoItem(
                text: "Day 1: \(steps[0].title)",
                isCompleted: false,
                order: 0,
                sourceRoadmapId: goalId,
                sourceDayNumber: 1
            )
            modelContext.insert(firstTask)
            
            isGenerating = false
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func generateManualTemplate() {
        let goalId = UUID()
        let steps = [
            RoadmapDay(dayNumber: 1, title: "Initial Planning", description: "Define your scope and gather materials.", youtubeLink: nil),
            RoadmapDay(dayNumber: 2, title: "First Prototype", description: "Build a rough version of your idea.", youtubeLink: nil)
        ]
        let newGoal = RoadmapGoal(id: goalId, title: manualName, type: type, targetDate: Date().addingTimeInterval(86400 * 7), roadmap: steps)
        GoalStore.shared.addGoal(newGoal)
        
        let firstTask = TodoItem(
            text: "Day 1: \(steps[0].title)",
            isCompleted: false,
            order: 0,
            sourceRoadmapId: goalId,
            sourceDayNumber: 1
        )
        modelContext.insert(firstTask)
        
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Detail View
struct RoadmapDetailView: View {
    let goal: RoadmapGoal
    @State private var items: [RoadmapDay]
    
    init(goal: RoadmapGoal) {
        self.goal = goal
        _items = State(initialValue: goal.roadmap)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(goal.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Target: \(goal.targetDate, style: .date)")
                        .foregroundColor(.gray)
                }
                .padding()
                
                // Timeline
                ForEach(items.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: 16) {
                        // Line & Dot
                        VStack(spacing: 0) {
                            Circle()
                                .fill(items[index].isCompleted ? Color.green : Color.gray)
                                .frame(width: 12, height: 12)
                            
                            if index < items.count - 1 {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 2)
                                    .frame(minHeight: 80) // extend line
                            }
                        }
                        
                        // Content
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Day \(items[index].dayNumber)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(4)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(4)
                                
                                Spacer()
                                
                                Button(action: {
                                    items[index].isCompleted.toggle()
                                    // In a real app, save back to store here
                                }) {
                                    Image(systemName: items[index].isCompleted ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                        .foregroundColor(items[index].isCompleted ? .green : .gray)
                                }
                            }
                            
                            Text(items[index].title)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text(items[index].description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            if let link = items[index].youtubeLink {
                                Link(destination: URL(string: link)!) {
                                    HStack {
                                        Image(systemName: "play.rectangle.fill")
                                            .foregroundColor(.red)
                                        Text("Watch Tutorial")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6).opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
                // Add Step Button (For manual addition)
                Button(action: {
                    let nextDay = (items.last?.dayNumber ?? 0) + 1
                    items.append(RoadmapDay(dayNumber: nextDay, title: "New Step", description: "Tap to edit", youtubeLink: nil))
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Step")
                    }
                    .foregroundColor(.blue)
                    .padding()
                }
            }
            .padding(.bottom, 50)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
