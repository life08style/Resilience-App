import SwiftUI
import SwiftData

struct RecipeDetailsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var savedRecipes: [SavedRecipe]
    @Query private var pantryItems: [PantryItem]
    
    @State var recipe: RecipeModel
    @State private var isSaved: Bool = false
    @State private var showScheduleParams = false
    @State private var scheduleDate = Date()
    
    init(recipe: RecipeModel) {
        self._recipe = State(initialValue: recipe)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                RecipeHeroImage(image: recipe.image)
                
                VStack(alignment: .leading, spacing: 24) {
                    RecipeTitleHeader(recipe: recipe)
                    
                    RecipeActionButtons(
                        isSaved: isSaved,
                        onSchedule: { showScheduleParams = true },
                        onToggleSave: toggleSave
                    )
                    
                    Divider().background(Color.white.opacity(0.1))
                    
                    RecipeNutritionSection(nutrition: recipe.nutrition)
                    
                    Divider().background(Color.white.opacity(0.1))
                    
                    RecipeIngredientsSection(
                        ingredients: recipe.ingredients,
                        pantryItems: pantryItems,
                        onAddToCart: addToCart
                    )
                    
                    Divider().background(Color.white.opacity(0.1))
                    
                    RecipeInstructionsSection(instructions: recipe.instructions)
                    
                    CompletionButton(onComplete: {
                        HapticManager.shared.success()
                        logMealNutrition()
                    })
                }
                .padding()
            }
            .padding(.bottom, 100)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.top)
        .onAppear(perform: checkIfSaved)
        .onChange(of: savedRecipes) { _, _ in checkIfSaved() }
        .sheet(isPresented: $showScheduleParams) {
            ScheduleRecipeSheet(recipe: recipe)
        }
    }
    
    private func checkIfSaved() {
        isSaved = savedRecipes.contains { $0.recipeId == recipe.id }
    }
    
    private func toggleSave() {
        if isSaved {
            if let saved = savedRecipes.first(where: { $0.recipeId == recipe.id }) {
                modelContext.delete(saved)
            }
        } else {
            let newSave = SavedRecipe(recipeId: recipe.id, title: recipe.title)
            modelContext.insert(newSave)
        }
        isSaved.toggle()
    }
    
    private func addToCart(ingredient: String) {
        // Simple heuristic to name the cart item
        let cleanName = ingredient.replacingOccurrences(of: "\\d+", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
        
        let newItem = CartItem(name: cleanName, category: "Produce", quantity: 1.0, unit: "pc")
        modelContext.insert(newItem)
        HapticManager.shared.impact()
    }
    
    private func logMealNutrition() {
        let today = DailyNutritionLog.normalizedDate(Date())
        
        // Fetch existing log for today
        let descriptor = FetchDescriptor<DailyNutritionLog>(
            predicate: #Predicate<DailyNutritionLog> { log in
                log.date == today
            }
        )
        
        do {
            let logs = try modelContext.fetch(descriptor)
            if let existing = logs.first {
                existing.calories += Double(recipe.nutrition.calories)
                existing.protein += Double(recipe.nutrition.protein)
                existing.carbs += Double(recipe.nutrition.carbs)
                existing.fat += Double(recipe.nutrition.fat)
            } else {
                let newLog = DailyNutritionLog(
                    date: today,
                    calories: Double(recipe.nutrition.calories),
                    protein: Double(recipe.nutrition.protein),
                    carbs: Double(recipe.nutrition.carbs),
                    fat: Double(recipe.nutrition.fat)
                )
                modelContext.insert(newLog)
            }
        } catch {
            print("Failed to log nutrition: \(error)")
        }
    }
}

// MARK: - Subviews

struct RecipeHeroImage: View {
    let image: String
    
    var body: some View {
        AsyncImage(url: URL(string: image)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Color.gray.opacity(0.3)
        }
        .frame(height: 300)
        .clipped()
        .overlay(
            LinearGradient(colors: [.black.opacity(0.6), .clear], startPoint: .bottom, endPoint: .center)
        )
    }
}

struct RecipeTitleHeader: View {
    let recipe: RecipeModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(recipe.title)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            Text(recipe.description)
                .font(.body)
                .foregroundColor(.gray)
                .lineLimit(3)
            
            HStack(spacing: 20) {
                MetaBadge(icon: "clock", text: recipe.time)
                MetaBadge(icon: "flame", text: "\(recipe.nutrition.calories) kcal")
                MetaBadge(icon: "person.2", text: "\(recipe.servings) serv")
                MetaBadge(icon: "star", text: recipe.difficulty)
            }
        }
    }
}

struct RecipeActionButtons: View {
    let isSaved: Bool
    let onSchedule: () -> Void
    let onToggleSave: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onSchedule) {
                HStack {
                    Image(systemName: "calendar.badge.plus")
                    Text("Schedule")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            
            Button(action: onToggleSave) {
                HStack {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    Text(isSaved ? "Saved" : "Save")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor.systemGray6).opacity(0.1))
                .foregroundColor(isSaved ? .blue : .white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSaved ? Color.blue : Color.white.opacity(0.2), lineWidth: 1)
                )
            }
        }
    }
}

struct RecipeNutritionSection: View {
    let nutrition: NutritionInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Nutrition per serving")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                NutritionCard(label: "Protein", value: "\(nutrition.protein)g", color: .green)
                NutritionCard(label: "Carbs", value: "\(nutrition.carbs)g", color: .orange)
                NutritionCard(label: "Fat", value: "\(nutrition.fat)g", color: .red)
                NutritionCard(label: "Fiber", value: "\(nutrition.fiber)g", color: .blue)
            }
        }
    }
}

struct RecipeIngredientsSection: View {
    let ingredients: [String]
    let pantryItems: [PantryItem]
    let onAddToCart: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "fork.knife")
                    .foregroundColor(.green)
                Text("Ingredients")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            .padding(.bottom, 4)
            
            VStack(spacing: 12) {
                ForEach(ingredients, id: \.self) { ingredient in
                    IngredientRow(ingredient: ingredient, pantryItems: pantryItems, onAddToCart: onAddToCart)
                }
            }
        }
        .padding()
        .background(Color(hex: "1A2530")) // Darker blue background for the section
        .cornerRadius(24)
    }
}

struct IngredientRow: View {
    let ingredient: String
    let pantryItems: [PantryItem]
    let onAddToCart: (String) -> Void
    
    @State private var isAdded: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Text(ingredient)
                .font(.body)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: { 
                if !isAdded {
                    onAddToCart(ingredient)
                    withAnimation { isAdded = true }
                    HapticManager.shared.success()
                }
            }) {
                HStack(spacing: 4) {
                    if isAdded {
                        Image(systemName: "checkmark")
                    }
                    Text(isAdded ? "Added" : "Add")
                }
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isAdded ? Color.green : Color.blue)
                .cornerRadius(8)
            }
            .disabled(isAdded)
        }
        .padding()
        .background(isAdded ? Color.green.opacity(0.2) : Color(hex: "243447")) // Card background with highlighting
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isAdded ? Color.green : Color.clear, lineWidth: 1)
        )
        .animation(.spring(), value: isAdded)
    }
}

struct RecipeInstructionsSection: View {
    let instructions: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Instructions")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            ForEach(Array(instructions.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 16) {
                    Text("\(index + 1)")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(width: 28, height: 28)
                        .background(Color.white)
                        .clipShape(Circle())
                    
                    Text(step)
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(4)
                }
            }
        }
    }
}

struct CompletionButton: View {
    let onComplete: () -> Void
    
    var body: some View {
        Button(action: onComplete) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                Text("I completed this meal!")
            }
            .font(.headline)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .cornerRadius(12)
            .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.top, 24)
    }
}

struct MetaBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.caption)
        .foregroundColor(.gray)
    }
}

struct NutritionCard: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemGray6).opacity(0.1))
        .cornerRadius(12)
    }
}

struct ScheduleRecipeSheet: View {
    let recipe: RecipeModel
    @Environment(\.dismiss) var dismiss
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Schedule \(recipe.title)")
                        .font(.headline)
                    Text("This will add a 30-minute block to your calendar.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Section {
                    DatePicker("Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section {
                    Button("Confirm Schedule") {
                        CalendarManager.shared.scheduleMeal(recipe: recipe, date: date)
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Schedule Meal")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
