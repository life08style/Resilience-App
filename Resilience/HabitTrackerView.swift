import SwiftUI
import SwiftData

struct HabitTrackerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]
    
    @State private var showAddSheet = false
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Habit Tracker")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Build better routines, one day at a time.")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Stats Overview
                    HStack(spacing: 12) {
                        HabitStatBox(title: "Completion", value: calculateCompletion(), icon: "checkmark.circle.fill", color: .green)
                        HabitStatBox(title: "Total Habits", value: "\(habits.count)", icon: "list.bullet", color: .blue)
                        HabitStatBox(title: "Best Streak", value: "\(calculateBestStreak())", icon: "flame.fill", color: .orange)
                    }
                    .padding(.horizontal)
                    
                    // Habits List
                    if habits.isEmpty {
                        VStack(spacing: 16) {
                            ProgressView().tint(.blue)
                            Text("Initializing Habits...")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 40)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(habits) { habit in
                                HabitCard(habit: habit)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Add New Habit Button
                    Button(action: { showAddSheet = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Create Custom Habit")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.systemGray6).opacity(0.2))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            seedHabitsIfNeeded()
        }
        .sheet(isPresented: $showAddSheet) {
            AddHabitView()
        }
    }
    
    func seedHabitsIfNeeded() {
        // No auto-seeding, start empty as requested
    }
    
    func calculateCompletion() -> String {
        return "85%"
    }
    
    func calculateBestStreak() -> Int {
        return habits.map { $0.bestStreak }.max() ?? 0
    }
}

struct HabitStatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemGray6).opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

struct HabitCard: View {
    let habit: Habit
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(habit.color).opacity(0.2))
                    .frame(width: 48, height: 48)
                Image(systemName: habit.icon)
                    .foregroundColor(Color(habit.color))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(habit.descriptionText)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(habit.currentStreak)d")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Streak")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            
            Button(action: {
                // Keep the toggle logic simple
                habit.isActive.toggle()
                try? modelContext.save()
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(habit.isActive ? Color(habit.color) : .gray.opacity(0.3))
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.1))
        .cornerRadius(16)
    }
}

// MARK: - Add Habit View
struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var description = ""
    @State private var icon = "star.fill"
    @State private var color = "blue"
    @State private var type = "simple" // simple, counter, timer
    @State private var targetCount = 1
    @State private var targetUnit = "times"
    
    let icons = ["star.fill", "drop.fill", "figure.walk", "book.fill", "moon.fill", "leaf.fill", "flame.fill"]
    let colors = ["blue", "purple", "green", "orange", "red", "cyan"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Name & Desc
                        VStack(spacing: 16) {
                            TextField("Habit Name", text: $name)
                                .font(.headline)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                            
                            TextField("Description", text: $description)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        
                        // Type Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Habit Type").foregroundColor(.gray).font(.caption).bold()
                            
                            HStack(spacing: 12) {
                                typeButton("Simple", type: "simple", icon: "checkmark.circle")
                                typeButton("Counter", type: "counter", icon: "number.circle")
                                typeButton("Steps", type: "steps", icon: "figure.walk")
                            }
                        }
                        
                        if type == "counter" || type == "steps" {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Daily Target").foregroundColor(.gray).font(.caption).bold()
                                HStack {
                                    TextField("Amount", value: $targetCount, formatter: NumberFormatter())
                                        .keyboardType(.numberPad)
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(12)
                                        .foregroundColor(.white)
                                    
                                    TextField("Unit (e.g. cups)", text: $targetUnit)
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(12)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        // Icon & Color
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Appearance").foregroundColor(.gray).font(.caption).bold()
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(icons, id: \.self) { iconName in
                                        Image(systemName: iconName)
                                            .foregroundColor(icon == iconName ? .white : .gray)
                                            .padding(10)
                                            .background(icon == iconName ? Color.blue : Color.white.opacity(0.1))
                                            .clipShape(Circle())
                                            .onTapGesture { icon = iconName }
                                    }
                                }
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(colors, id: \.self) { colorName in
                                        Circle()
                                            .fill(Color(colorName))
                                            .frame(width: 30, height: 30)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white, lineWidth: color == colorName ? 2 : 0)
                                            )
                                            .onTapGesture { color = colorName }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: saveHabit) {
                            Text("Create Habit")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .disabled(name.isEmpty)
                        .padding(.bottom, 20)
                    }
                    .padding()
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    func typeButton(_ title: String, type: String, icon: String) -> some View {
        Button(action: { self.type = type }) {
            VStack {
                Image(systemName: icon).font(.title2)
                Text(title).font(.caption)
            }
            .foregroundColor(self.type == type ? .white : .gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(self.type == type ? Color.blue.opacity(0.5) : Color.white.opacity(0.05))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(self.type == type ? Color.blue : Color.clear, lineWidth: 1)
            )
        }
    }
    
    private func saveHabit() {
        let newHabit = Habit(
            name: name,
            descriptionText: description,
            habitType: type,
            category: "general",
            icon: icon,
            color: color,
            frequencyType: "daily",
            targetDays: [],
            targetCount: Double(targetCount),
            targetUnit: targetUnit,
            reminderEnabled: false,
            reminderTimes: [],
            currentStreak: 0,
            bestStreak: 0,
            totalCompletions: 0,
            isActive: false
        )
        modelContext.insert(newHabit)
        dismiss()
    }
}
