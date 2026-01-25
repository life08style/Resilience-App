import SwiftUI
import SwiftData

struct FoodLogSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DailyNutritionLog.date, order: .reverse) private var nutritionLogs: [DailyNutritionLog]
    
    @State private var searchText = ""
    @State private var selectedFood: CatalogFoodItem?
    @State private var quantity: Double = 1.0
    @State private var showManualEntry = false
    
    // Manual Entry State
    @State private var manualName = ""
    @State private var manualCalories = ""
    @State private var manualProtein = ""
    @State private var manualCarbs = ""
    @State private var manualFat = ""
    
    var filteredFoods: [CatalogFoodItem] {
        if searchText.isEmpty {
            return []
        }
        return FoodCatalog.items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    if showManualEntry {
                        manualEntryForm
                    } else if let food = selectedFood {
                        loggingForm(for: food)
                    } else {
                        searchView
                    }
                }
                .padding()
                .navigationTitle(showManualEntry ? "Manual Log" : (selectedFood != nil ? "Log Quantity" : "Log Food"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                    if selectedFood != nil || showManualEntry {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Back") {
                                selectedFood = nil
                                showManualEntry = false
                            }
                        }
                    }
                }
            }
        }
        .accentColor(.green)
    }
    
    private var searchView: some View {
        VStack(spacing: 16) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search 10,000+ foods...", text: $searchText)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color(UIColor.systemGray6).opacity(0.2))
            .cornerRadius(12)
            
            // Manual Option
            Button(action: { showManualEntry = true }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Manual Entry")
                }
                .font(.headline)
                .foregroundColor(.green)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }
            
            // Results List
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(filteredFoods) { food in
                        Button(action: { selectedFood = food }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(food.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(food.category)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text(food.defaultUnit)
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }
    
    private func loggingForm(for food: CatalogFoodItem) -> some View {
        VStack(spacing: 30) {
            VStack(spacing: 12) {
                Text(food.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(food.category)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Quantity (\(food.defaultUnit))")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack {
                    TextField("1.0", value: $quantity, format: .number)
                        .keyboardType(.decimalPad)
                        .font(.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(16)
                    
                    Stepper("", value: $quantity, in: 0.1...1000, step: 0.1)
                        .labelsHidden()
                }
            }
            
            // Preview Nutrition
            VStack(spacing: 16) {
                HStack {
                    NutritionColumn(label: "Calories", value: "\(Int(Double(food.caloriesPerUnit) * quantity))")
                    NutritionColumn(label: "Prot.", value: String(format: "%.1fg", food.proteinPerUnit * quantity))
                    NutritionColumn(label: "Carbs", value: String(format: "%.1fg", food.carbsPerUnit * quantity))
                    NutritionColumn(label: "Fat", value: String(format: "%.1fg", food.fatPerUnit * quantity))
                }
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(16)
            
            Spacer()
            
            Button(action: { saveLog(food: food) }) {
                Text("LOG FOOD")
                    .fontWeight(.black)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.green)
                    .cornerRadius(30)
            }
        }
    }
    
    private var manualEntryForm: some View {
        ScrollView {
            VStack(spacing: 20) {
                LogField(label: "Food Name", value: $manualName, icon: "text.cursor", color: .green)
                LogField(label: "Calories", value: $manualCalories, icon: "flame.fill", color: .orange)
                LogField(label: "Protein (g)", value: $manualProtein, icon: "stronghold", color: .blue)
                LogField(label: "Carbohydrates (g)", value: $manualCarbs, icon: "leaf.fill", color: .green)
                LogField(label: "Fat (g)", value: $manualFat, icon: "drop.fill", color: .yellow)
                
                Spacer().frame(height: 20)
                
                Button(action: saveManual) {
                    Text("SAVE MANUAL LOG")
                        .fontWeight(.black)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(manualName.isEmpty ? Color.gray : Color.green)
                        .cornerRadius(30)
                }
                .disabled(manualName.isEmpty)
            }
        }
    }
    
    private func saveLog(food: CatalogFoodItem) {
        let cal = Double(food.caloriesPerUnit) * quantity
        let pro = food.proteinPerUnit * quantity
        let carb = food.carbsPerUnit * quantity
        let fat = food.fatPerUnit * quantity
        
        updateDailyLog(cal: cal, pro: pro, carb: carb, fat: fat)
    }
    
    private func saveManual() {
        let cal = Double(manualCalories) ?? 0
        let pro = Double(manualProtein) ?? 0
        let carb = Double(manualCarbs) ?? 0
        let fat = Double(manualFat) ?? 0
        
        updateDailyLog(cal: cal, pro: pro, carb: carb, fat: fat)
    }
    
    private func updateDailyLog(cal: Double, pro: Double, carb: Double, fat: Double) {
        let today = DailyNutritionLog.normalizedDate(Date())
        
        if let existing = nutritionLogs.first(where: { DailyNutritionLog.normalizedDate($0.date) == today }) {
            existing.calories += cal
            existing.protein += pro
            existing.carbs += carb
            existing.fat += fat
        } else {
            let newLog = DailyNutritionLog(date: today, calories: cal, protein: pro, carbs: carb, fat: fat)
            modelContext.insert(newLog)
        }
        
        dismiss()
    }
}

struct NutritionColumn: View {
    let label: String
    let value: String
    var body: some View {
        VStack(spacing: 4) {
            Text(label).font(.caption2).foregroundColor(.gray)
            Text(value).font(.headline).foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    FoodLogSheet()
}
