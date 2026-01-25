import SwiftUI
import SwiftData

struct SavedHubView: View {
    @State private var selectedTab = "Recipes"
    let tabs = ["Recipes", "Exercises", "Sleep", "Plans"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Saved")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .padding(.top, 40)
            
            // Tab Bar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(tabs, id: \.self) { tab in
                        Button(action: { selectedTab = tab }) {
                            VStack(spacing: 8) {
                                Text(tab)
                                    .fontWeight(.semibold)
                                    .foregroundColor(selectedTab == tab ? .white : .gray)
                                
                                Capsule()
                                    .fill(selectedTab == tab ? Color.blue : Color.clear)
                                    .frame(height: 3)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
            
            // Content
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if selectedTab == "Recipes" {
                    SavedRecipesView()
                } else if selectedTab == "Exercises" {
                    SavedExercisesView()
                } else if selectedTab == "Sleep" {
                    SavedSleepView()
                } else if selectedTab == "Plans" {
                    SavedPlansView()
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

// MARK: - Subviews
struct SavedRecipesView: View {
    @Query private var savedRecipes: [SavedRecipe]
    
    var body: some View {
        let recipes = RecipeDatabase.shared.recipes.filter { recipe in
            savedRecipes.contains { $0.recipeId == recipe.id }
        }
        
        ScrollView {
            if recipes.isEmpty {
                VStack {
                    Spacer()
                    Image(systemName: "bookmark.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                        .padding()
                    Text("No saved recipes yet")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: 400)
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(recipes) { recipe in
                        NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                            RecipeCardView(recipe: recipe)
                        }
                    }
                }
                .padding()
                .padding(.bottom, 100)
            }
        }
    }
}

struct SavedExercisesView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "dumbbell")
                .font(.system(size: 50))
                .foregroundColor(.gray)
                .padding()
            Text("No saved exercises yet")
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

struct SavedSleepView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "moon.zzz")
                .font(.system(size: 50))
                .foregroundColor(.gray)
                .padding()
            Text("No saved sleep schedules")
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

struct SavedPlansView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "list.clipboard")
                .font(.system(size: 50))
                .foregroundColor(.gray)
                .padding()
            Text("No saved plans yet")
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

struct RecipeCardView: View {
    let recipe: RecipeModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: recipe.image)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 120)
                .clipped()
                
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Circle().fill(Color.black.opacity(0.5)))
                    .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text(recipe.time)
                        .font(.caption2)
                    Spacer()
                    Text("\(recipe.nutrition.calories) kcal")
                        .font(.caption2)
                }
                .foregroundColor(.gray)
            }
            .padding(10)
            .background(Color(UIColor.systemGray6).opacity(0.2))
        }
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}
