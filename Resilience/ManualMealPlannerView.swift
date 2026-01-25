import SwiftUI
import SwiftData

struct ManualMealPlannerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var planName = "My Weekly Plan"
    @State private var selectedDay: String? = nil
    @State private var showingRecipePicker = false
    
    // Day -> [PlannedMeal]
    @State private var mealPlanData: [String: [PlannedMeal]] = [
        "Monday": [], "Tuesday": [], "Wednesday": [], "Thursday": [],
        "Friday": [], "Saturday": [], "Sunday": []
    ]
    
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Meal Planner")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    TextField("Plan Name", text: $planName)
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding(10)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Days Grid
                ForEach(days, id: \.self) { day in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(day)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                selectedDay = day
                                showingRecipePicker = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                            }
                        }
                        .padding(.horizontal)
                        
                        let meals = mealPlanData[day] ?? []
                        
                        if meals.isEmpty {
                            HStack {
                                Image(systemName: "fork.knife")
                                Text("No meals added")
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.systemGray6).opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(meals, id: \.recipeId) { meal in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(meal.recipeTitle)
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                            Text("\(Int(meal.calories)) kcal")
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Button(action: {
                                            mealPlanData[day]?.removeAll(where: { $0.recipeId == meal.recipeId })
                                        }) {
                                            Image(systemName: "minus.circle")
                                                .foregroundColor(.red.opacity(0.7))
                                        }
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                Button(action: savePlan) {
                    Text("Save Plan")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(16)
                }
                .padding()
                .padding(.bottom, 100)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showingRecipePicker) {
            RecipePickerSheet { recipe in
                if let day = selectedDay {
                    let planned = PlannedMeal(
                        mealType: "Meal",
                        recipeId: recipe.id.uuidString,
                        recipeTitle: recipe.title,
                        calories: Double(recipe.nutrition.calories),
                        protein: Double(recipe.nutrition.protein),
                        carbs: Double(recipe.nutrition.carbs),
                        fat: Double(recipe.nutrition.fat)
                    )
                    mealPlanData[day]?.append(planned)
                }
            }
        }
    }
    
    private func savePlan() {
        let weeklyPlans = mealPlanData.map { (day, meals) in
            DailyMealPlan(day: day, meals: meals)
        }
        
        let newPlan = MealPlan(
            planName: planName,
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
            dietaryPreferences: [],
            dailyCalorieGoal: 2000,
            mealsPerDay: 3,
            weeklyMeals: weeklyPlans,
            groceryList: [],
            isActive: true,
            aiGenerated: false
        )
        
        modelContext.insert(newPlan)
        HapticManager.shared.success()
        dismiss()
    }
}

struct RecipePickerSheet: View {
    @Environment(\.dismiss) var dismiss
    var onSelect: (RecipeModel) -> Void
    
    let recipes = RecipeDatabase.shared.recipes
    
    var body: some View {
        NavigationView {
            List(recipes) { recipe in
                Button(action: {
                    onSelect(recipe)
                    dismiss()
                }) {
                    HStack {
                        AsyncImage(url: URL(string: recipe.image)) { img in
                            img.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                        
                        VStack(alignment: .leading) {
                            Text(recipe.title)
                                .font(.headline)
                            Text(recipe.category)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Pick a Recipe")
            .toolbar {
                Button("Cancel") { dismiss() }
            }
        }
    }
}
