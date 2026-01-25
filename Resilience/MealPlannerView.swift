import SwiftUI

struct MealPlannerView: View {
    @State private var selectedDay = "Monday"
    @State private var mealPlan: MealPlan?
    
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Meal Planner")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Fuel your body with the right nutrition")
                        .foregroundColor(.gray)
                }
                .padding(.top)
                
                // Day Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(days, id: \.self) { day in
                            Button(action: { selectedDay = day }) {
                                Text(day.prefix(3))
                                    .font(.headline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(selectedDay == day ? Color.green : Color(UIColor.systemGray6).opacity(0.2))
                                    .foregroundColor(selectedDay == day ? .black : .gray)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                if mealPlan != nil {
                    // Nutrition Summary
                    HStack(spacing: 16) {
                        NutritionCircle(label: "Calories", value: "2100", color: .orange)
                        NutritionCircle(label: "Protein", value: "150g", color: .red)
                        NutritionCircle(label: "Carbs", value: "200g", color: .blue)
                        NutritionCircle(label: "Fat", value: "70g", color: .yellow)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6).opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // Meals List
                    VStack(spacing: 16) {
                        MealCard(type: "Breakfast", title: "Oatmeal with Berries", calories: 450, time: "10 min")
                        MealCard(type: "Lunch", title: "Grilled Chicken Salad", calories: 650, time: "20 min")
                        MealCard(type: "Snack", title: "Greek Yogurt & Nuts", calories: 250, time: "5 min")
                        MealCard(type: "Dinner", title: "Salmon with Asparagus", calories: 750, time: "30 min")
                    }
                    .padding(.horizontal)
                    
                    // Grocery List Button
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "cart.fill")
                            Text("View Grocery List")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    
                } else {
                    // Empty State / Generator
                    VStack(spacing: 20) {
                        Image(systemName: "leaf.circle.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.green)
                        
                        Text("No Meal Plan Active")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Generate a personalized meal plan based on your goals and preferences.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        Button(action: generatePlan) {
                            Text("Generate Plan")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                    }
                    .padding(40)
                    .background(Color(UIColor.systemGray6).opacity(0.1))
                    .cornerRadius(20)
                    .padding()
                }
            }
            .padding(.bottom)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationTitle("Meal Planner")
    }
    
    func generatePlan() {
        // Mock generation
        mealPlan = MealPlan(
            id: UUID(),
            planName: "Healthy Balance",
            startDate: Date(),
            endDate: Date().addingTimeInterval(7*24*3600),
            dietaryPreferences: ["None"],
            dailyCalorieGoal: 2100,
            mealsPerDay: 3,
            weeklyMeals: [],
            groceryList: [],
            isActive: true,
            aiGenerated: true
        )
    }
}

struct NutritionCircle: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 4)
                    .frame(width: 50, height: 50)
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
            }
            
            Text(value)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }
}

struct MealCard: View {
    let type: String
    let title: String
    let calories: Int
    let time: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(type.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.caption2)
                    Text("\(calories) kcal")
                        .font(.caption)
                }
                .foregroundColor(.orange)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text(time)
                        .font(.caption)
                }
                .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.15))
        .cornerRadius(16)
    }
}
