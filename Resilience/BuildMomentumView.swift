import SwiftUI
import SwiftData
import Charts

struct BuildMomentumView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoItem.order) private var todos: [TodoItem]
    @Query private var cartItems: [CartItem]
    @StateObject private var store = BluStore.shared
    
    // UI States
    @State private var quickTodoText: String = ""
    @State private var showFocusMode = false
    @State private var showStartDay = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Background
                Color.black.edgesIgnoringSafeArea(.all)
                
                // Main Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Resilience")
                                .font(.system(size: 20, weight: .heavy, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                            
                            VStack(spacing: 4) {
                                Text("Build Your Momentum")
                                    .font(.system(size: 28, weight: .black, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.blue.opacity(0.8), .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                                
                                Capsule()
                                    .fill(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                                    .frame(width: 140, height: 4)
                            }
                        }
                        .padding(.top, 10)
                        
                        // Main Grid Layout
                        VStack(spacing: 16) {
                            
                            // Row 1: Progress Grid & To Do List
                            HStack(alignment: .top, spacing: 16) {
                                
                                // Left Col: Progress Grid (2x2)
                                VStack(spacing: 12) {
                                    HStack {
                                        Text("Progress")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Spacer()
                                        // Icons for tabs (placeholder visual)
                                        HStack(spacing: 4) {
                                            Image(systemName: "chart.bar.fill").font(.caption2).foregroundColor(.blue)
                                            Image(systemName: "dumbbell.fill").font(.caption2).foregroundColor(.gray)
                                            Image(systemName: "figure.run").font(.caption2).foregroundColor(.gray)
                                        }
                                        .padding(4)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(8)
                                    }
                                    
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                        ProgressSquare(icon: "clock.arrow.circlepath", value: "3h 12m", label: "Active", color: .indigo)
                                        ProgressSquare(icon: "shoe.fill", value: "109", label: "Steps", color: .green)
                                        ProgressSquare(icon: "flame.fill", value: "2", label: "Streak", color: .orange)
                                        ProgressSquare(icon: "clock", value: "0m", label: "Focus", color: .purple)
                                    }
                                }
                                .padding()
                                .background(Color(UIColor.systemGray6).opacity(0.15))
                                .cornerRadius(24)
                                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.blue.opacity(0.3), lineWidth: 1))
                                
                                // Right Col: To Do List
                                VStack(spacing: 0) {
                                    NavigationLink(destination: TodoListView()) {
                                        HStack {
                                            Image(systemName: "list.bullet.circle")
                                                .foregroundColor(.cyan)
                                            Text("To Do List")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        .padding([.horizontal, .top])
                                        .padding(.bottom, 8)
                                    }
                                    
                                    if todos.isEmpty {
                                        VStack {
                                            Spacer()
                                            Text("No active tasks")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            Button(action: { /* Focus field */ }) {
                                                HStack {
                                                    Image(systemName: "plus")
                                                    Text("Add a task...")
                                                }
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.5))
                                            }
                                            .padding(.top, 4)
                                            Spacer()
                                        }
                                        .frame(height: 120)
                                    } else {
                                        VStack(alignment: .leading, spacing: 12) {
                                            ForEach(todos.prefix(4)) { todo in
                                                HStack(alignment: .top, spacing: 8) {
                                                    Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                                        .foregroundColor(todo.isCompleted ? .green : .gray)
                                                        .font(.caption)
                                                    Text(todo.text)
                                                        .font(.caption)
                                                        .strikethrough(todo.isCompleted)
                                                        .foregroundColor(todo.isCompleted ? .gray : .white)
                                                        .lineLimit(1)
                                                    Spacer()
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                        .frame(height: 120, alignment: .top)
                                    }
                                    
                                    Spacer()
                                    
                                    // Projects / Skills Buttons
                                    HStack(spacing: 8) {
                                        NavigationLink(destination: ProjectsView()) {
                                            HStack {
                                                Image(systemName: "folder.fill")
                                                Text("Projects")
                                            }
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(Color.blue.opacity(0.8))
                                            .cornerRadius(8)
                                        }
                                        
                                        NavigationLink(destination: SkillsView()) {
                                            HStack {
                                                Image(systemName: "book.fill")
                                                Text("Skills")
                                            }
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(Color.purple.opacity(0.6))
                                            .cornerRadius(8)
                                        }
                                    }
                                    .padding(12)
                                }
                                .background(Color(UIColor.systemGray6).opacity(0.15))
                                .cornerRadius(24)
                                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.blue.opacity(0.3), lineWidth: 1))
                            }
                            .frame(height: 280) // Fixed height to align rows
                            
                            // Row 2: Sleep Schedule Banner
                            NavigationLink(destination: SleepView()) {
                                HStack(spacing: 16) {
                                    Image(systemName: "moon.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 50)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Sleep Schedule")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("sleep") // Placeholder or binding
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    
                                    Spacer()
                                    
                                    Text("No schedule set")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .padding(20)
                                .background(
                                    LinearGradient(
                                        colors: [Color(hex: "8A2BE2"), Color(hex: "4B0082")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(20)
                            }
                            
                            // Row 3: Pantry & Saved
                            HStack(spacing: 16) {
                                NavigationLink(destination: PantryView(showBackButton: true)) {
                                    VStack(spacing: 8) {
                                        HStack {
                                            Image(systemName: "cart")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            Spacer()
                                            Circle()
                                                .fill(Color.green)
                                                .frame(width: 20, height: 20)
                                                .overlay(Text("0").font(.caption2).foregroundColor(.black))
                                        }
                                        Text("Pantry")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("1 items")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.black)
                                    .cornerRadius(20)
                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.2), lineWidth: 1))
                                }
                                
                                NavigationLink(destination: AnyView(SavedHubView())) {
                                    VStack(spacing: 8) {
                                        Image(systemName: "bookmark.fill")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                        Text("Saved")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("0 items")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.black)
                                    .cornerRadius(20)
                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.2), lineWidth: 1))
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Spacer for Footer
                        Spacer().frame(height: 100)
                    }
                }
                
                // Fixed Footer
                HStack(spacing: 16) {
                    // Play Button Circle
                    Button(action: { showStartDay = true }) {
                        Circle()
                            .fill(
                                LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "play.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            )
                            .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 0)
                    }
                    
                    // Get To Work Button
                    Button(action: { showFocusMode = true }) {
                        HStack {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                            Text("Get To Work")
                                .fontWeight(.bold)
                            Image(systemName: "arrow.right")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.cyan)
                        .cornerRadius(30)
                        .shadow(color: .cyan.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    
                    // Mascot
                    BluMascotView(customization: BluCustomization.defaultCustomization, size: 80)
                        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                        .offset(y: -10) // Slight overlap effect
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                .background(
                    LinearGradient(colors: [.black.opacity(0), .black], startPoint: .top, endPoint: .bottom)
                        .frame(height: 120)
                )
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showFocusMode) {
                FocusModeView()
            }
            .fullScreenCover(isPresented: $showStartDay) {
                StartDayView()
            }
        }
    }
}

// MARK: - Subviews

struct ProgressSquare: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemGray6).opacity(0.2))
        .cornerRadius(16)
    }
}


