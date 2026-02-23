import SwiftUI
import SwiftData
import Charts

// MARK: - Widget Visibility Preferences
struct HomeWidgetVisibility {
    @AppStorage("home.show.progress") static var showProgress: Bool = true
    @AppStorage("home.show.todo") static var showTodo: Bool = true
    @AppStorage("home.show.sleep") static var showSleep: Bool = true
    @AppStorage("home.show.pantry") static var showPantry: Bool = true
}

struct BuildMomentumView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoItem.order) private var todos: [TodoItem]
    @StateObject private var store = BluStore.shared

    // Widget visibility (persisted)
    @AppStorage("home.show.progress") private var showProgress: Bool = true
    @AppStorage("home.show.todo") private var showTodo: Bool = true
    @AppStorage("home.show.sleep") private var showSleep: Bool = true
    @AppStorage("home.show.pantry") private var showPantry: Bool = true

    // UI States
    @State private var showFocusMode = false
    @State private var showStartDay = false
    @State private var isEditMode = false
    @State private var editModeScale: CGFloat = 1.0

    var completedTodos: Int { todos.filter { $0.isCompleted }.count }
    var totalTodos: Int { todos.count }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Background
                Color.black.edgesIgnoringSafeArea(.all)

                // Main Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {

                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Build Your Momentum")
                                    .font(.system(size: 24, weight: .black, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.blue.opacity(0.9), .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                Text("Resilience")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button(action: { showStartDay = true }) {
                                Circle()
                                    .fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 38, height: 38)
                                    .overlay(
                                        Image(systemName: "play.fill")
                                            .font(.body)
                                            .foregroundColor(.white)
                                    )
                                    .shadow(color: .purple.opacity(0.5), radius: 8, x: 0, y: 0)
                            }
                        }
                        .padding(.top, 10)

                        // Main Grid
                        VStack(spacing: 14) {

                            // Row 1: Progress Grid & To Do List
                            if showProgress || showTodo {
                                HStack(alignment: .top, spacing: 14) {

                                    // Left Col: Progress Grid
                                    if showProgress {
                                        progressCard
                                            .widgetOverlay(
                                                isEditMode: isEditMode,
                                                label: "Progress",
                                                isVisible: $showProgress
                                            )
                                    }

                                    // Right Col: To Do List
                                    if showTodo {
                                        todoCard
                                            .widgetOverlay(
                                                isEditMode: isEditMode,
                                                label: "To Do",
                                                isVisible: $showTodo
                                            )
                                    }
                                }
                                .frame(height: 260)
                            }

                            // Row 2: Sleep Banner
                            if showSleep {
                                NavigationLink(destination: SleepView()) {
                                    sleepBanner
                                }
                                .widgetOverlay(
                                    isEditMode: isEditMode,
                                    label: "Sleep",
                                    isVisible: $showSleep
                                )
                            }

                            // Row 3: Pantry & Saved
                            if showPantry {
                                pantryRow
                                    .widgetOverlay(
                                        isEditMode: isEditMode,
                                        label: "Pantry & Saved",
                                        isVisible: $showPantry
                                    )
                            }
                        }
                        .padding(.horizontal)

                        // Spacer for Footer
                        Spacer().frame(height: 110)
                    }
                }
                // Long-press on background to enter edit mode
                .onLongPressGesture(minimumDuration: 0.6) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        isEditMode = true
                        HapticManager.shared.selection()
                    }
                }

                // Fixed Footer
                VStack(spacing: 0) {
                    if isEditMode {
                        editModeBar
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        summaryBar
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isEditMode)
                .padding(.horizontal)
                .padding(.bottom, 20)
                .background(
                    LinearGradient(colors: [.black.opacity(0), .black], startPoint: .top, endPoint: .bottom)
                        .frame(height: 130)
                        .allowsHitTesting(false)
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

    // MARK: - Summary Bar
    var summaryBar: some View {
        HStack(spacing: 0) {
            SummaryStatItem(icon: "flame.fill", value: "2", label: "Streak", color: .orange)
                .frame(maxWidth: .infinity)

            Divider()
                .frame(width: 1, height: 36)
                .background(Color.white.opacity(0.15))

            SummaryStatItem(
                icon: "checkmark.circle.fill",
                value: "\(completedTodos)/\(totalTodos)",
                label: "Tasks",
                color: .green
            )
            .frame(maxWidth: .infinity)

            Divider()
                .frame(width: 1, height: 36)
                .background(Color.white.opacity(0.15))

            SummaryStatItem(icon: "timer", value: "0m", label: "Focus", color: .cyan)
                .frame(maxWidth: .infinity)

            Divider()
                .frame(width: 1, height: 36)
                .background(Color.white.opacity(0.15))

            Button(action: { showFocusMode = true }) {
                HStack(spacing: 6) {
                    Image(systemName: "bolt.fill")
                        .font(.caption)
                        .foregroundColor(.black)
                    Text("Focus")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(Color.cyan)
                .cornerRadius(20)
            }
            .padding(.leading, 8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(UIColor.systemGray6).opacity(0.25))
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 8)
    }

    // MARK: - Edit Mode Bar
    var editModeBar: some View {
        VStack(spacing: 12) {
            Text("Hold & tap cards to show/hide")
                .font(.caption)
                .foregroundColor(.gray)

            HStack(spacing: 12) {
                WidgetToggleChip(label: "Progress", icon: "chart.bar.fill", isOn: $showProgress)
                WidgetToggleChip(label: "To Do", icon: "list.bullet.circle", isOn: $showTodo)
                WidgetToggleChip(label: "Sleep", icon: "moon.fill", isOn: $showSleep)
                WidgetToggleChip(label: "Pantry", icon: "cart", isOn: $showPantry)
            }

            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    isEditMode = false
                    HapticManager.shared.selection()
                }
            }) {
                Text("Done")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(20)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(UIColor.systemGray5).opacity(0.3))
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 8)
    }

    // MARK: - Progress Card
    var progressCard: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Progress")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ProgressSquare(icon: "clock.arrow.circlepath", value: "3h 12m", label: "Active", color: .indigo)
                ProgressSquare(icon: "shoe.fill", value: "109", label: "Steps", color: .green)
                ProgressSquare(icon: "flame.fill", value: "2", label: "Streak", color: .orange)
                ProgressSquare(icon: "clock", value: "0m", label: "Focus", color: .purple)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGray6).opacity(0.15))
        .cornerRadius(22)
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.blue.opacity(0.25), lineWidth: 1))
    }

    // MARK: - To Do Card
    var todoCard: some View {
        VStack(spacing: 0) {
            NavigationLink(destination: TodoListView()) {
                HStack {
                    Image(systemName: "list.bullet.circle")
                        .foregroundColor(.cyan)
                    Text("To Do")
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
                    Text("No tasks yet")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .frame(height: 100)
            } else {
                VStack(alignment: .leading, spacing: 10) {
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
                .frame(height: 100, alignment: .top)
            }

            Spacer()

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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGray6).opacity(0.15))
        .cornerRadius(22)
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.blue.opacity(0.25), lineWidth: 1))
    }

    // MARK: - Sleep Banner
    var sleepBanner: some View {
        HStack(spacing: 14) {
            Image(systemName: "moon.stars.fill")
                .font(.title2)
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 2) {
                Text("Sleep Schedule")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("No schedule set")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            LinearGradient(
                colors: [Color(hex: "8A2BE2"), Color(hex: "4B0082")],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(18)
    }

    // MARK: - Pantry Row
    var pantryRow: some View {
        HStack(spacing: 14) {
            NavigationLink(destination: PantryView(showBackButton: true)) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "cart")
                                .foregroundColor(.white)
                            Spacer()
                            Circle()
                                .fill(Color.green)
                                .frame(width: 18, height: 18)
                                .overlay(Text("0").font(.caption2).foregroundColor(.black))
                        }
                        Text("Pantry")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemGray6).opacity(0.15))
                    .cornerRadius(18)
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.15), lineWidth: 1))
                }
            }

            NavigationLink(destination: AnyView(SavedHubView())) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Image(systemName: "bookmark.fill")
                            .foregroundColor(.white)
                        Text("Saved")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemGray6).opacity(0.15))
                    .cornerRadius(18)
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.15), lineWidth: 1))
                }
            }
        }
    }
}

// MARK: - Summary Stat Item
struct SummaryStatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 3) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundColor(color)
                Text(value)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
            }
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Widget Toggle Chip
struct WidgetToggleChip: View {
    let label: String
    let icon: String
    @Binding var isOn: Bool

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isOn.toggle()
                HapticManager.shared.selection()
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: isOn ? icon : "eye.slash")
                    .font(.title3)
                    .foregroundColor(isOn ? .white : .gray)
                Text(label)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(isOn ? .white : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isOn ? Color.blue.opacity(0.4) : Color(UIColor.systemGray6).opacity(0.2))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isOn ? Color.blue.opacity(0.6) : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// MARK: - Widget Overlay Modifier
struct WidgetOverlayModifier: ViewModifier {
    let isEditMode: Bool
    let label: String
    @Binding var isVisible: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
                .opacity(isEditMode ? 0.5 : 1.0)
                .scaleEffect(isEditMode ? 0.97 : 1.0)
                .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isEditMode)
            
            if isEditMode {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.blue.opacity(0.6), lineWidth: 2)
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        isVisible.toggle()
                                        HapticManager.shared.selection()
                                    }
                                }) {
                                    Image(systemName: isVisible ? "eye.fill" : "eye.slash.fill")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(7)
                                        .background(Color.blue)
                                        .clipShape(Circle())
                                        .shadow(color: .blue.opacity(0.4), radius: 4)
                                }
                                .padding(8)
                            }
                            Spacer()
                        }
                    )
                    .transition(.opacity)
            }
        }
    }
}

extension View {
    func widgetOverlay(isEditMode: Bool, label: String, isVisible: Binding<Bool>) -> some View {
        self.modifier(WidgetOverlayModifier(isEditMode: isEditMode, label: label, isVisible: isVisible))
    }
}

// MARK: - Subviews

struct ProgressSquare: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
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
        .padding(.vertical, 10)
        .background(Color(UIColor.systemGray6).opacity(0.2))
        .cornerRadius(14)
    }
}
