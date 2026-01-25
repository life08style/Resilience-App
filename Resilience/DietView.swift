import SwiftUI

struct DietView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var showFilters = false
    @State private var showFoodLog = false
    
    let categories = ["All", "Breakfast", "Lunch", "Dinner", "Snacks"]
    let database = RecipeDatabase.shared
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            ScrollView {
                VStack(spacing: 24) {
                    // Row 1: AI Meal Plan & Meal Planner
                    HStack(spacing: 16) {
                        DietHeaderCard(
                            title: "AI Meal Plan",
                            subtitle: "Personalized",
                            icon: "sparkles",
                            color: Color.purple.opacity(0.15),
                            accentColor: .purple
                        )
                        
                        DietHeaderCard(
                            title: "Meal Planner",
                            subtitle: "Build your own",
                            icon: "pencil.and.outline",
                            color: Color.green.opacity(0.15),
                            accentColor: .green
                        )
                    }
                    .padding(.horizontal)
                    
                    // Row 2: Search
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search for recipes...", text: $searchText)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6).opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Row 3: Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                CategoryChip(title: category, isSelected: selectedCategory == category) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Row 4: Nutrition Filters
                    Button(action: { showFilters = true }) {
                        HStack {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(.white)
                            Text("Nutrition Filters")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Row 5: Saved Recipes & Shopping List
                    HStack(spacing: 16) {
                        NavigationLink(destination: SavedHubView()) {
                            DietActionCard(
                                title: "Saved Recipes",
                                subtitle: "View saved",
                                icon: "heart.fill",
                                color: Color.red.opacity(0.15),
                                accentColor: .red
                            )
                        }
                        
                        NavigationLink(destination: PantryView()) {
                            DietActionCard(
                                title: "Shopping List",
                                subtitle: "View pantry",
                                icon: "cart.fill",
                                color: Color.blue.opacity(0.15),
                                accentColor: .blue
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Row 6: Recipe Discovery
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "bolt.fill")
                                .foregroundColor(.yellow)
                            Text(filteredRecipes.count > 0 ? "Recipe Discovery (\(filteredRecipes.count))" : "Discover Meals")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        if filteredRecipes.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "fork.knife")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("No recipes found matching \"\(searchText)\"")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(filteredRecipes) { recipe in
                                    NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                                        RecipeSquareCard(recipe: recipe)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer().frame(height: 120)
                } 
            }
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showFoodLog = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.black)
                                .frame(width: 70, height: 70)
                                .background(Color.green)
                                .clipShape(Circle())
                                .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.trailing, 25)
                        .padding(.bottom, 100)
                    }
                }
            )
            .sheet(isPresented: $showFoodLog) {
                FoodLogSheet()
            }
        }
    }
    
    private var filteredRecipes: [RecipeModel] {
        let recipes = randomizedRecipes
        return recipes.filter { recipe in
            let matchesCategory = selectedCategory == "All" || recipe.category == selectedCategory
            let matchesSearch = searchText.isEmpty || recipe.title.localizedCaseInsensitiveContains(searchText) || recipe.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            return matchesCategory && matchesSearch
        }
    }
    
    private var randomizedRecipes: [RecipeModel] {
        let calendar = Calendar.current
        let daySeed = calendar.component(.day, from: Date()) + calendar.component(.month, from: Date()) * 100
        var shuffled = database.recipes
        
        // Simple seeded shuffle
        var generator = SplitMix64(seed: UInt64(daySeed))
        for i in (1..<shuffled.count).reversed() {
            let j = Int(generator.next() % UInt64(i + 1))
            shuffled.swapAt(i, j)
        }
        return shuffled
    }
}

// MARK: - Randomization Utils
struct SplitMix64 {
    private var state: UInt64
    init(seed: UInt64) { self.state = seed }
    mutating func next() -> UInt64 {
        state &+= 0x9e3779b97f4a7c15
        var z = state
        z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z >> 27)) &* 0x94d049bb133111eb
        return z ^ (z >> 31)
    }
}
 // End struct DietView (line 3)


struct DietHeaderCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white)
                .padding(10)
                .background(accentColor.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(accentColor.opacity(0.2), lineWidth: 1))
    }
}

struct DietActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(accentColor)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color)
        .cornerRadius(20)
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if title == "All" { Image(systemName: "fork.knife") }
                else if title == "Breakfast" { Image(systemName: "cup.and.saucer.fill") }
                else if title == "Lunch" { Image(systemName: "takeoutbag.and.cup.and.can.fill") }
                
                Text(title)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.green : Color(UIColor.systemGray6).opacity(0.2))
            .foregroundColor(.white)
            .cornerRadius(25)
        }
    }
}

struct RecipeSquareCard: View {
    let recipe: RecipeModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: recipe.image)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 200, height: 160)
                .clipped()
                
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                    Image(systemName: "heart")
                }
                .foregroundColor(.white)
                .padding(10)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text("\(recipe.nutrition.calories) kcal")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(12)
            .frame(width: 200, alignment: .leading)
            .background(Color(UIColor.systemGray6).opacity(0.1))
        }
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}
