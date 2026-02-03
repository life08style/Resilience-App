import SwiftUI
import SwiftData


struct HomeView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BuildMomentumView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(1)
            
            DashboardView()
                .tabItem {
                    Label("Main Menu", systemImage: "chart.bar.xaxis")
                }
                .tag(2)
            
            SocialView()
                .tabItem {
                    Label("Social", systemImage: "person.2.fill")
                }
                .tag(3)
            
            NavigationView {
                PantryView(showBackButton: false)
            }
                .tabItem {
                    Label("Store", systemImage: "cart.fill")
                }
                .tag(4)
        }
        .accentColor(DesignSystem.Colors.primary)
        .preferredColorScheme(.dark)
        .onChange(of: selectedTab) { oldValue, newValue in
            HapticManager.shared.selection()
        }
    }
}

// Placeholder Views for tabs not yet fully implemented
struct LandingContent: View {
    @Binding var selectedTab: Int
    @State private var showAccount = false
    @State private var showCustomization = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("Welcome Back,")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Yakir")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: { showAccount = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding(10)
                            .background(Color(UIColor.systemGray6).opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                
                // Mascot Section
                VStack(spacing: 16) {
                    ZStack(alignment: .topTrailing) {
                        BluMascotView(customization: BluCustomization.defaultCustomization, size: 180)
                            .shadow(color: .blue.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        Button(action: { showCustomization = true }) {
                            Image(systemName: "paintbrush.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        .offset(x: 10, y: -10)
                    }
                    
                    Text("Ready to crush today's goals?")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding(.vertical, 20)
                
                // Streaks Summary
                NavigationLink(destination: StreaksView()) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Daily Streak")
                                .font(.caption)
                                .foregroundColor(.gray)
                            HStack {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.orange)
                                Text("5 Days")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6).opacity(0.1))
                    .cornerRadius(16)
                }
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Actions")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        QuickActionButton(title: "Log Workout", icon: "dumbbell.fill", color: .green) {
                            selectedTab = 1 // Go to Productivity
                        }
                        QuickActionButton(title: "Focus Mode", icon: "brain.head.profile", color: .purple) {
                            selectedTab = 1
                        }
                        QuickActionButton(title: "Add Task", icon: "plus.circle.fill", color: .blue) {
                            selectedTab = 1
                        }
                        QuickActionButton(title: "Sleep Mode", icon: "moon.fill", color: .indigo) {
                            selectedTab = 1
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
        .sheet(isPresented: $showAccount) {
            AccountView()
        }
        .sheet(isPresented: $showCustomization) {
            BluCustomizationView()
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(UIColor.systemGray6).opacity(0.1))
            .cornerRadius(16)
        }
    }
}

struct ProductivityContent: View {
    var body: some View {
        List {
            Section(header: Text("Growth")) {
                NavigationLink(destination: ProjectsView()) {
                    Label("Projects", systemImage: "hammer.fill")
                        .foregroundColor(.blue)
                }
                NavigationLink(destination: SkillsView()) {
                    Label("Skills", systemImage: "brain.head.profile")
                        .foregroundColor(.purple)
                }
            }
            
            Section(header: Text("Advanced Productivity")) {
                NavigationLink(destination: HabitTrackerView()) {
                    Label("Habit Tracker", systemImage: "checklist.checked")
                }
                NavigationLink(destination: MealPlannerView()) {
                    Label("Meal Planner", systemImage: "fork.knife.circle.fill")
                }
            }
            
            Section(header: Text("Advanced Fitness")) {
                NavigationLink(destination: WorkoutSessionView()) {
                    Label("Live Workout", systemImage: "play.circle.fill")
                        .foregroundColor(.green)
                }
                NavigationLink(destination: BodyMeasurementsView()) {
                    Label("Body Metrics", systemImage: "ruler.fill")
                }
            }
            
            Section(header: Text("Content & Social")) {
                NavigationLink(destination: MusicLibraryView()) {
                    Label("Music Library", systemImage: "music.note.list")
                }
                NavigationLink(destination: SubscriptionView()) {
                    Label("Premium Subscription", systemImage: "crown.fill")
                        .foregroundColor(.yellow)
                }
            }
            
            Section(header: Text("Focus & Tools")) {
                NavigationLink(destination: TimeManagementView()) {
                    Label("Time Management", systemImage: "clock.fill")
                }
                NavigationLink(destination: TodoListView()) {
                    Label("Todo List", systemImage: "checklist")
                }
                NavigationLink(destination: AppLockView()) {
                    Label("App Lock", systemImage: "lock.shield.fill")
                }
                NavigationLink(destination: WhiteNoisePlayer()) {
                    Label("White Noise", systemImage: "waveform.path.ecg")
                }
            }
            
            Section(header: Text("Wellness")) {
                NavigationLink(destination: SleepScheduleView()) {
                    Label("Sleep Schedules", systemImage: "moon.zzz.fill")
                }
                NavigationLink(destination: MentalHealthView()) {
                    Label("Mental Health", systemImage: "brain.head.profile")
                }
                NavigationLink(destination: DietView()) {
                    Label("Diet & Nutrition", systemImage: "leaf.fill")
                }
            }
            
            Section(header: Text("Fitness & AI")) {
                NavigationLink(destination: ExerciseView()) {
                    Label("Exercise Hub", systemImage: "figure.run")
                }
                NavigationLink(destination: AICoachView()) {
                    Label("AI Coach", systemImage: "bubble.left.and.bubble.right.fill")
                        .foregroundColor(.cyan)
                }
                NavigationLink(destination: WorkoutBuilderView()) {
                    Label("Workout Builder", systemImage: "hammer.fill")
                }
                NavigationLink(destination: AIWorkoutPlannerView()) {
                    Label("AI Workout Planner", systemImage: "wand.and.stars")
                        .foregroundColor(.purple)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Productivity")
    }
}

struct SocialTabButton: View {
    let title: String
    let icon: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
            .foregroundColor(isActive ? .cyan : .gray)
            .padding(.vertical, 8)
            .overlay(
                Rectangle()
                    .fill(isActive ? Color.cyan : Color.clear)
                    .frame(height: 2)
                    .offset(y: 12),
                alignment: .bottom
            )
        }
    }
}

enum CalendarViewMode {
    case day, month
}

struct CalendarView: View {
    @ObservedObject private var calendarManager = CalendarManager.shared
    @State private var currentDate = Date()
    @State private var selectedDate = Date()
    @State private var viewMode: CalendarViewMode = .day
    @State private var showAddEvent = false
    @State private var showQuickSchedule = false
    @State private var scheduleText = ""
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // App Bar
                ResilienceAppBar(showBackButton: false)
                
                // Sub-Header (Date & View Modes)
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Button(action: {
                            withAnimation {
                                currentDate = Date()
                                selectedDate = Date()
                                viewMode = .day
                            }
                        }) {
                            Text(formatDate(currentDate))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        HStack(spacing: 12) {
                            Button(action: { viewMode = .month }) {
                                Text("Month")
                                    .font(.caption)
                                    .fontWeight(viewMode == .month ? .bold : .medium)
                                    .foregroundColor(viewMode == .month ? .blue : .gray)
                            }
                            
                            Button(action: { viewMode = .day }) {
                                Text("Day")
                                    .font(.caption)
                                    .fontWeight(viewMode == .day ? .bold : .medium)
                                    .foregroundColor(viewMode == .day ? .blue : .gray)
                            }
                            
                            HStack(spacing: 16) {
                                Button(action: { moveDate(by: -1) }) {
                                    Image(systemName: "chevron.left")
                                }
                                Button(action: { moveDate(by: 1) }) {
                                    Image(systemName: "chevron.right")
                                }
                            }
                            .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: { showQuickSchedule.toggle() }) {
                            Image(systemName: "sparkles")
                                .font(.headline)
                                .foregroundColor(showQuickSchedule ? .blue : .white)
                                .frame(width: 32, height: 32)
                                .background(showQuickSchedule ? Color.white : Color(UIColor.systemGray6).opacity(0.3))
                                .clipShape(Circle())
                        }
                        
                        Button("Today") {
                            withAnimation {
                                currentDate = Date()
                                selectedDate = Date()
                            }
                        }
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(UIColor.systemGray6).opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        Button(action: { showAddEvent = true }) {
                            Image(systemName: "plus")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding()
                
                if showQuickSchedule {
                    QuickScheduleView(scheduleText: $scheduleText)
                        .padding(.horizontal)
                        .padding(.bottom)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Content
                if viewMode == .month {
                    MonthGrid(currentDate: $currentDate, selectedDate: $selectedDate, events: calendarManager.events)
                        .padding()
                        .transition(.opacity)
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.width < 0 {
                                        // Swipe Left -> Next Month
                                        moveDate(by: 1)
                                    } else if value.translation.width > 0 {
                                        // Swipe Right -> Previous Month
                                        moveDate(by: -1)
                                    }
                                }
                        )
                } else {
                    DaySchedule(date: selectedDate, events: calendarManager.events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) })
                        .transition(.opacity)
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.width < 0 {
                                        // Swipe Left -> Next Day
                                        moveDate(by: 1)
                                    } else if value.translation.width > 0 {
                                        // Swipe Right -> Previous Day
                                        moveDate(by: -1)
                                    }
                                }
                        )
                }
            }
        }
        .onChange(of: selectedDate) { _, newDate in
            currentDate = newDate
            viewMode = .day
        }
        .sheet(isPresented: $showAddEvent) { AddEventView() }
    }
    
    func moveDate(by value: Int) {
        withAnimation {
            if viewMode == .day {
                if let newDate = Calendar.current.date(byAdding: .day, value: value, to: currentDate) {
                    currentDate = newDate
                    selectedDate = newDate
                }
            } else {
                if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) {
                    currentDate = newDate
                }
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = viewMode == .month ? "MMMM yyyy" : "MMMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct QuickScheduleView: View {
    @Binding var scheduleText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Schedule")
                .font(.headline)
                .foregroundColor(.white)
            
            ZStack(alignment: .topLeading) {
                if scheduleText.isEmpty {
                    Text("8:00 AM Breakfast 1h\n9:30 AM Gym 45m\n1:00 PM Lunch")
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }
                
                TextEditor(text: $scheduleText)
                    .scrollContentBackground(.hidden)
                    .padding(4)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(8)
                    .frame(height: 100)
                    .foregroundColor(.white)
            }
            
            Button(action: generateSchedule) {
                Text("Generate Schedule")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.2))
        .cornerRadius(16)
    }
    
    func generateSchedule() {
        // Logic to parse scheduleText and create CalendarEvents
        print("Generating schedule from: \(scheduleText)")
        scheduleText = "" // Clear after generation
    }
}
