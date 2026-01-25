import SwiftUI
import SwiftData
import Charts

struct BuildMomentumView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoItem.order) private var todos: [TodoItem]
    @Query private var cartItems: [CartItem]
    @StateObject private var store = BluStore.shared 
    
    // Progress Card States
    @State private var progressMode: Int = 0 // 0: Exercise, 1: Diet, 2: Body
    @State private var animateTitle = false
    
    // Quick Add Todo State
    @State private var quickTodoText: String = ""
    @FocusState private var isAddFocused: Bool
    @State private var showFocusMode = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack(alignment: .top) {
                    // Background
                    Color.black.edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        // App Bar
                        ResilienceAppBar(showBackButton: false)
                        
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 24) {
                                // Title Section
                                VStack(spacing: 4) {
                                    Text("Build Your Momentum")
                                        .font(.system(size: 28, weight: .black, design: .rounded))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [.blue, .purple],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                                    
                                    Capsule()
                                        .fill(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                                        .frame(width: 100, height: 4)
                                }
                                .padding(.top, 10)
                                
                                // Cards Stack (Spreading nicely)
                                VStack(spacing: 20) {
                                    
                                    // 1. Progress Card (Full Width)
                                    VStack(spacing: 12) {
                                        NavigationLink(destination: ProgressTrackingView()) {
                                            HStack {
                                                Image(systemName: "chart.xyaxis.line")
                                                    .foregroundColor(.cyan)
                                                Text("Progress Tracking")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        
                                        // Preview Content
                                        HStack(spacing: 20) {
                                            VStack(alignment: .leading) {
                                                Text("Weight").font(.caption).foregroundColor(.gray)
                                                HStack {
                                                    Text("183.2").font(.title2).fontWeight(.bold).foregroundColor(.white)
                                                    Text("lbs").font(.caption).foregroundColor(.gray)
                                                }
                                            }
                                            
                                            Divider().background(Color.gray.opacity(0.3))
                                            
                                            VStack(alignment: .leading) {
                                                Text("Trend").font(.caption).foregroundColor(.gray)
                                                Text("-1.8%").font(.title2).fontWeight(.bold).foregroundColor(.green)
                                            }
                                            
                                            Spacer()
                                            
                                            // Mini graph visual
                                            Chart {
                                                RuleMark(y: .value("Goal", 180)).foregroundStyle(.green).lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                                                LineMark(x: .value("D1", 1), y: .value("W", 185)).foregroundStyle(.cyan)
                                                LineMark(x: .value("D2", 2), y: .value("W", 184)).foregroundStyle(.cyan)
                                                LineMark(x: .value("D3", 3), y: .value("W", 183.2)).foregroundStyle(.cyan)
                                            }
                                            .frame(width: 60, height: 30)
                                            .chartXAxis(.hidden)
                                            .chartYAxis(.hidden)
                                        }
                                    }
                                    .padding()
                                    .background(Color(UIColor.systemGray6).opacity(0.15))
                                    .cornerRadius(20)
                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.1), lineWidth: 1))
                                    
                                    // 2. To Do / Habits Card (Full width)
                                    VStack(spacing: 0) {
                                        NavigationLink(destination: TodoListView()) {
                                            HStack {
                                                Image(systemName: "list.bullet.clipboard")
                                                    .foregroundColor(.purple)
                                                Text("Daily Goals")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                Spacer()
                                                Text("\(todos.filter { !$0.isCompleted }.count) Pending")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                            .padding()
                                        }
                                        
                                        Divider().background(Color.white.opacity(0.1))
                                        
                                        // Quick List
                                        VStack(spacing: 12) {
                                            if todos.isEmpty {
                                                Text("No tasks yet. Add one!").font(.caption).foregroundColor(.gray).padding()
                                            } else {
                                                ForEach(todos.prefix(3)) { todo in
                                                    HStack {
                                                        Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                                            .foregroundColor(todo.isCompleted ? .green : .gray)
                                                        Text(todo.text)
                                                            .strikethrough(todo.isCompleted)
                                                            .foregroundColor(todo.isCompleted ? .gray : .white)
                                                        Spacer()
                                                    }
                                                }
                                            }
                                            
                                            // Add Todo Input
                                            HStack {
                                                Image(systemName: "plus").foregroundColor(.gray)
                                                TextField("Add quick task...", text: $quickTodoText, onCommit: addQuickTodo)
                                                    .foregroundColor(.white)
                                            }
                                            .padding(10)
                                            .background(Color.black.opacity(0.3))
                                            .cornerRadius(10)
                                        }
                                        .padding()
                                    }
                                    .background(Color(UIColor.systemGray6).opacity(0.15))
                                    .cornerRadius(20)
                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.1), lineWidth: 1))
                                    
                                    // 3. Sleep Cycle (Full Width)
                                    NavigationLink(destination: SleepView()) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                HStack {
                                                    Image(systemName: "moon.stars.fill").foregroundColor(.indigo)
                                                    Text("Sleep Cycle").font(.headline).foregroundColor(.white)
                                                }
                                                Text("8h 12m scheduled").font(.caption).foregroundColor(.gray)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right").foregroundColor(.gray)
                                        }
                                        .padding()
                                        .background(
                                            LinearGradient(colors: [.indigo.opacity(0.2), .purple.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
                                        )
                                        .cornerRadius(20)
                                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.indigo.opacity(0.3), lineWidth: 1))
                                    }
                                    
                                    // 4. Pantry & Saved (Side-by-Side but wider)
                                    HStack(spacing: 16) {
                                        NavigationLink(destination: PantryView()) {
                                            HStack {
                                                Image(systemName: "cart.fill").foregroundColor(.green)
                                                Text("Pantry").font(.headline).foregroundColor(.white)
                                                Spacer()
                                            }
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color(UIColor.systemGray6).opacity(0.15))
                                            .cornerRadius(20)
                                        }
                                        
                                        NavigationLink(destination: AnyView(SavedHubView())) {
                                            HStack {
                                                Image(systemName: "bookmark.fill").foregroundColor(.orange)
                                                Text("Saved").font(.headline).foregroundColor(.white)
                                                Spacer()
                                            }
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color(UIColor.systemGray6).opacity(0.15))
                                            .cornerRadius(20)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                // Footer Action
                                Button(action: {}) {
                                    Text("Start Day")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(16)
                                        .shadow(color: .white.opacity(0.2), radius: 10, x: 0, y: 0)
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                            }
                            .padding(.bottom, 50)
                        }
                    }
                }
                .navigationBarHidden(true)
                .fullScreenCover(isPresented: $showFocusMode) {
                    FocusModeView()
                }
            }
        }
    }
    
    func addQuickTodo() {
        guard !quickTodoText.isEmpty else { return }
        let new = TodoItem(text: quickTodoText, isCompleted: false, order: todos.count)
        modelContext.insert(new)
        quickTodoText = ""
        isAddFocused = false
    }
}

// MARK: - Previews
struct ExercisePreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Active Now").font(.caption2).foregroundColor(.gray)
            Text("Leg Day (Lower Body)").font(.subheadline).bold().foregroundColor(.white)
            ProgressView(value: 0.4).tint(.cyan)
        }
    }
}

struct DietPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Next Meal").font(.caption2).foregroundColor(.gray)
            Text("Chicken & Avocado").font(.subheadline).bold().foregroundColor(.white)
            Text("at 1:30 PM").font(.caption).foregroundColor(.cyan)
        }
    }
}

struct WeightData: Identifiable {
    let id = UUID()
    let day: Int
    let weight: Double
}

struct BodyPreview: View {
    // Pre-calculate data to avoid complex inline expressions that confuse the compiler
    let data: [WeightData] = (0..<7).map { i in
        WeightData(day: i, weight: 185.0 - Double(i) * 0.2 + Double.random(in: -0.5...0.5))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Weight Trend")
                .font(.caption2)
                .foregroundColor(.gray)
            
            // Mini Chart
            Chart(data) { point in
                LineMark(
                    x: .value("Day", point.day),
                    y: .value("Weight", point.weight)
                )
                .foregroundStyle(.cyan)
                .interpolationMethod(.catmullRom)
                
                AreaMark(
                    x: .value("Day", point.day),
                    y: .value("Weight", point.weight)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan.opacity(0.3), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: 60)
            
            HStack {
                Text("183.2 lbs")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("-1.8%")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
    }
}

struct SmallMenuLink: View {
    let title: String
    let icon: String
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 12) {
                Image(systemName: icon).font(.title).foregroundColor(.white)
                Text(title).font(.headline).fontWeight(.bold).foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(Color.white.opacity(0.1))
            .cornerRadius(24)
            .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.1), lineWidth: 1))
        }
    }
}
