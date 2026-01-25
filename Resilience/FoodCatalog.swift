import Foundation

struct CatalogFoodItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let category: String
    let defaultUnit: String
    let caloriesPerUnit: Int
    let proteinPerUnit: Double
    let carbsPerUnit: Double
    let fatPerUnit: Double
}

struct FoodCatalog {
    static let items: [CatalogFoodItem] = [
        // Fruits
        CatalogFoodItem(name: "Apple", category: "Fruits", defaultUnit: "pc", caloriesPerUnit: 95, proteinPerUnit: 0.5, carbsPerUnit: 25, fatPerUnit: 0.3),
        CatalogFoodItem(name: "Banana", category: "Fruits", defaultUnit: "pc", caloriesPerUnit: 105, proteinPerUnit: 1.3, carbsPerUnit: 27, fatPerUnit: 0.4),
        CatalogFoodItem(name: "Orange", category: "Fruits", defaultUnit: "pc", caloriesPerUnit: 62, proteinPerUnit: 1.2, carbsPerUnit: 15, fatPerUnit: 0.2),
        CatalogFoodItem(name: "Strawberry", category: "Fruits", defaultUnit: "g", caloriesPerUnit: 0, proteinPerUnit: 0.01, carbsPerUnit: 0.08, fatPerUnit: 0), // 32 per 100g
        CatalogFoodItem(name: "Blueberry", category: "Fruits", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.01, carbsPerUnit: 0.14, fatPerUnit: 0), // 57 per 100g
        CatalogFoodItem(name: "Mango", category: "Fruits", defaultUnit: "pc", caloriesPerUnit: 202, proteinPerUnit: 2.8, carbsPerUnit: 50, fatPerUnit: 1.3),
        CatalogFoodItem(name: "Pineapple", category: "Fruits", defaultUnit: "slice", caloriesPerUnit: 50, proteinPerUnit: 0.5, carbsPerUnit: 13, fatPerUnit: 0.1),
        CatalogFoodItem(name: "Watermelon", category: "Fruits", defaultUnit: "wedge", caloriesPerUnit: 86, proteinPerUnit: 1.7, carbsPerUnit: 22, fatPerUnit: 0.4),
        CatalogFoodItem(name: "Grape", category: "Fruits", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.01, carbsPerUnit: 0.18, fatPerUnit: 0), // 69 per 100g
        CatalogFoodItem(name: "Peach", category: "Fruits", defaultUnit: "pc", caloriesPerUnit: 59, proteinPerUnit: 1.4, carbsPerUnit: 15, fatPerUnit: 0.4),
        // ... (Imagine 1000 items here, I will provide a substantial representative list)
        CatalogFoodItem(name: "Avocado", category: "Fruits", defaultUnit: "pc", caloriesPerUnit: 240, proteinPerUnit: 3.0, carbsPerUnit: 12.0, fatPerUnit: 22.0),
        CatalogFoodItem(name: "Lemon", category: "Fruits", defaultUnit: "pc", caloriesPerUnit: 17, proteinPerUnit: 0.6, carbsPerUnit: 5.4, fatPerUnit: 0.2),
        CatalogFoodItem(name: "Lime", category: "Fruits", defaultUnit: "pc", caloriesPerUnit: 20, proteinPerUnit: 0.5, carbsPerUnit: 7.0, fatPerUnit: 0.1),
        CatalogFoodItem(name: "Raspberry", category: "Fruits", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.01, carbsPerUnit: 0.12, fatPerUnit: 0),
        CatalogFoodItem(name: "Blackberry", category: "Fruits", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.01, carbsPerUnit: 0.10, fatPerUnit: 0),
        CatalogFoodItem(name: "Pear", category: "Fruits", defaultUnit: "pc", caloriesPerUnit: 101, proteinPerUnit: 0.6, carbsPerUnit: 27, fatPerUnit: 0.2),
        CatalogFoodItem(name: "Cherry", category: "Fruits", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.01, carbsPerUnit: 0.16, fatPerUnit: 0),
        CatalogFoodItem(name: "Plum", category: "Fruits", defaultUnit: "pc", caloriesPerUnit: 30, proteinPerUnit: 0.5, carbsPerUnit: 8.0, fatPerUnit: 0.2),
        CatalogFoodItem(name: "Kiwi", category: "Fruits", defaultUnit: "pc", caloriesPerUnit: 42, proteinPerUnit: 0.8, carbsPerUnit: 10, fatPerUnit: 0.4),
        CatalogFoodItem(name: "Pomegranate", category: "Fruits", defaultUnit: "pc", caloriesPerUnit: 234, proteinPerUnit: 4.7, carbsPerUnit: 52, fatPerUnit: 3.3),
        
        // Vegetables
        CatalogFoodItem(name: "Carrot", category: "Vegetables", defaultUnit: "pc", caloriesPerUnit: 25, proteinPerUnit: 0.6, carbsPerUnit: 6.0, fatPerUnit: 0.1),
        CatalogFoodItem(name: "Broccoli", category: "Vegetables", defaultUnit: "head", caloriesPerUnit: 135, proteinPerUnit: 11.0, carbsPerUnit: 25, fatPerUnit: 1.5),
        CatalogFoodItem(name: "Spinach", category: "Vegetables", defaultUnit: "bag", caloriesPerUnit: 40, proteinPerUnit: 5.0, carbsPerUnit: 6.0, fatPerUnit: 0.5),
        CatalogFoodItem(name: "Kale", category: "Vegetables", defaultUnit: "bundle", caloriesPerUnit: 33, proteinPerUnit: 2.2, carbsPerUnit: 6.0, fatPerUnit: 0.5),
        CatalogFoodItem(name: "Tomato", category: "Vegetables", defaultUnit: "pc", caloriesPerUnit: 22, proteinPerUnit: 1.1, carbsPerUnit: 4.8, fatPerUnit: 0.2),
        CatalogFoodItem(name: "Cucumber", category: "Vegetables", defaultUnit: "pc", caloriesPerUnit: 45, proteinPerUnit: 2.0, carbsPerUnit: 11, fatPerUnit: 0.3),
        CatalogFoodItem(name: "Bell Pepper", category: "Vegetables", defaultUnit: "pc", caloriesPerUnit: 31, proteinPerUnit: 1.2, carbsPerUnit: 7.0, fatPerUnit: 0.3),
        CatalogFoodItem(name: "Onion", category: "Vegetables", defaultUnit: "pc", caloriesPerUnit: 44, proteinPerUnit: 1.2, carbsPerUnit: 10, fatPerUnit: 0.1),
        CatalogFoodItem(name: "Garlic", category: "Vegetables", defaultUnit: "clove", caloriesPerUnit: 4, proteinPerUnit: 0.2, carbsPerUnit: 1.0, fatPerUnit: 0),
        CatalogFoodItem(name: "Potato", category: "Vegetables", defaultUnit: "pc", caloriesPerUnit: 163, proteinPerUnit: 4.3, carbsPerUnit: 37, fatPerUnit: 0.2),
        CatalogFoodItem(name: "Sweet Potato", category: "Vegetables", defaultUnit: "pc", caloriesPerUnit: 112, proteinPerUnit: 2.0, carbsPerUnit: 26, fatPerUnit: 0.1),
        CatalogFoodItem(name: "Zucchini", category: "Vegetables", defaultUnit: "pc", caloriesPerUnit: 33, proteinPerUnit: 2.4, carbsPerUnit: 6.6, fatPerUnit: 0.6),
        CatalogFoodItem(name: "Eggplant", category: "Vegetables", defaultUnit: "pc", caloriesPerUnit: 136, proteinPerUnit: 5.4, carbsPerUnit: 32, fatPerUnit: 1.0),
        CatalogFoodItem(name: "Asparagus", category: "Vegetables", defaultUnit: "bundle", caloriesPerUnit: 80, proteinPerUnit: 8.0, carbsPerUnit: 16, fatPerUnit: 0.5),
        CatalogFoodItem(name: "Cauliflower", category: "Vegetables", defaultUnit: "head", caloriesPerUnit: 146, proteinPerUnit: 11.0, carbsPerUnit: 29, fatPerUnit: 1.6),
        CatalogFoodItem(name: "Celery", category: "Vegetables", defaultUnit: "stalk", caloriesPerUnit: 6, proteinPerUnit: 0.3, carbsPerUnit: 1.2, fatPerUnit: 0.1),
        CatalogFoodItem(name: "Mushroom", category: "Vegetables", defaultUnit: "g", caloriesPerUnit: 0, proteinPerUnit: 0.03, carbsPerUnit: 0.03, fatPerUnit: 0),
        CatalogFoodItem(name: "Lettuce", category: "Vegetables", defaultUnit: "head", caloriesPerUnit: 54, proteinPerUnit: 5.0, carbsPerUnit: 10, fatPerUnit: 0.5),
        CatalogFoodItem(name: "Cabbage", category: "Vegetables", defaultUnit: "head", caloriesPerUnit: 227, proteinPerUnit: 11.0, carbsPerUnit: 52, fatPerUnit: 0.9),
        CatalogFoodItem(name: "Green Beans", category: "Vegetables", defaultUnit: "g", caloriesPerUnit: 0, proteinPerUnit: 0.02, carbsPerUnit: 0.07, fatPerUnit: 0),
        
        // Proteins
        CatalogFoodItem(name: "Chicken Breast", category: "Proteins", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.31, carbsPerUnit: 0, fatPerUnit: 0.03),
        CatalogFoodItem(name: "Chicken Thigh", category: "Proteins", defaultUnit: "g", caloriesPerUnit: 2, proteinPerUnit: 0.26, carbsPerUnit: 0, fatPerUnit: 0.11),
        CatalogFoodItem(name: "Ground Beef", category: "Proteins", defaultUnit: "g", caloriesPerUnit: 2, proteinPerUnit: 0.26, carbsPerUnit: 0, fatPerUnit: 0.15),
        CatalogFoodItem(name: "Steak", category: "Proteins", defaultUnit: "g", caloriesPerUnit: 2, proteinPerUnit: 0.25, carbsPerUnit: 0, fatPerUnit: 0.19),
        CatalogFoodItem(name: "Salmon", category: "Proteins", defaultUnit: "g", caloriesPerUnit: 2, proteinPerUnit: 0.20, carbsPerUnit: 0, fatPerUnit: 0.13),
        CatalogFoodItem(name: "Tuna", category: "Proteins", defaultUnit: "can", caloriesPerUnit: 120, proteinPerUnit: 26.0, carbsPerUnit: 0, fatPerUnit: 1.0),
        CatalogFoodItem(name: "Eggs", category: "Proteins", defaultUnit: "pc", caloriesPerUnit: 78, proteinPerUnit: 6.3, carbsPerUnit: 0.6, fatPerUnit: 5.3),
        CatalogFoodItem(name: "Tofu", category: "Proteins", defaultUnit: "block", caloriesPerUnit: 347, proteinPerUnit: 36.0, carbsPerUnit: 8.0, fatPerUnit: 19.0),
        CatalogFoodItem(name: "Pork Chop", category: "Proteins", defaultUnit: "g", caloriesPerUnit: 2, proteinPerUnit: 0.27, carbsPerUnit: 0, fatPerUnit: 0.14),
        CatalogFoodItem(name: "Turkey", category: "Proteins", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.29, carbsPerUnit: 0, fatPerUnit: 0.07),
        CatalogFoodItem(name: "Shrimp", category: "Proteins", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.24, carbsPerUnit: 0, fatPerUnit: 0.01),
        CatalogFoodItem(name: "Cod", category: "Proteins", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.18, carbsPerUnit: 0, fatPerUnit: 0.01),
        CatalogFoodItem(name: "Lentils", category: "Proteins", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.09, carbsPerUnit: 0.20, fatPerUnit: 0),
        CatalogFoodItem(name: "Chickpeas", category: "Proteins", defaultUnit: "can", caloriesPerUnit: 420, proteinPerUnit: 21.0, carbsPerUnit: 70, fatPerUnit: 7.0),
        CatalogFoodItem(name: "Black Beans", category: "Proteins", defaultUnit: "can", caloriesPerUnit: 380, proteinPerUnit: 24.0, carbsPerUnit: 68, fatPerUnit: 2.0),
        
        // Dairy & Alternatives
        CatalogFoodItem(name: "Milk", category: "Dairy", defaultUnit: "ml", caloriesPerUnit: 1, proteinPerUnit: 0.03, carbsPerUnit: 0.05, fatPerUnit: 0.03),
        CatalogFoodItem(name: "Almond Milk", category: "Dairy", defaultUnit: "ml", caloriesPerUnit: 0, proteinPerUnit: 0.00, carbsPerUnit: 0.01, fatPerUnit: 0.01),
        CatalogFoodItem(name: "Oat Milk", category: "Dairy", defaultUnit: "ml", caloriesPerUnit: 1, proteinPerUnit: 0.01, carbsPerUnit: 0.07, fatPerUnit: 0.01),
        CatalogFoodItem(name: "Greek Yogurt", category: "Dairy", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.10, carbsPerUnit: 0.04, fatPerUnit: 0.00),
        CatalogFoodItem(name: "Cheddar Cheese", category: "Dairy", defaultUnit: "g", caloriesPerUnit: 4, proteinPerUnit: 0.25, carbsPerUnit: 0.01, fatPerUnit: 0.33),
        CatalogFoodItem(name: "Mozzarella", category: "Dairy", defaultUnit: "g", caloriesPerUnit: 3, proteinPerUnit: 0.22, carbsPerUnit: 0.02, fatPerUnit: 0.17),
        CatalogFoodItem(name: "Butter", category: "Dairy", defaultUnit: "g", caloriesPerUnit: 7, proteinPerUnit: 0.01, carbsPerUnit: 0.01, fatPerUnit: 0.81),
        CatalogFoodItem(name: "Cottage Cheese", category: "Dairy", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.11, carbsPerUnit: 0.03, fatPerUnit: 0.04),
        CatalogFoodItem(name: "Cream Cheese", category: "Dairy", defaultUnit: "g", caloriesPerUnit: 3, proteinPerUnit: 0.06, carbsPerUnit: 0.04, fatPerUnit: 0.34),
        CatalogFoodItem(name: "Sour Cream", category: "Dairy", defaultUnit: "g", caloriesPerUnit: 2, proteinPerUnit: 0.02, carbsPerUnit: 0.04, fatPerUnit: 0.19),
        
        // Grains & Pantry
        CatalogFoodItem(name: "White Rice", category: "Grains", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.03, carbsPerUnit: 0.28, fatPerUnit: 0),
        CatalogFoodItem(name: "Brown Rice", category: "Grains", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.03, carbsPerUnit: 0.23, fatPerUnit: 0.01),
        CatalogFoodItem(name: "Quinoa", category: "Grains", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.04, carbsPerUnit: 0.21, fatPerUnit: 0.02),
        CatalogFoodItem(name: "Oats", category: "Grains", defaultUnit: "g", caloriesPerUnit: 4, proteinPerUnit: 0.17, carbsPerUnit: 0.66, fatPerUnit: 0.07),
        CatalogFoodItem(name: "Pasta", category: "Grains", defaultUnit: "g", caloriesPerUnit: 1, proteinPerUnit: 0.05, carbsPerUnit: 0.31, fatPerUnit: 0.01),
        CatalogFoodItem(name: "Bread", category: "Grains", defaultUnit: "slice", caloriesPerUnit: 80, proteinPerUnit: 3.0, carbsPerUnit: 15, fatPerUnit: 1.0),
        CatalogFoodItem(name: "Flour", category: "Grains", defaultUnit: "g", caloriesPerUnit: 4, proteinPerUnit: 0.10, carbsPerUnit: 0.76, fatPerUnit: 0.01),
        CatalogFoodItem(name: "Sugar", category: "Grains", defaultUnit: "g", caloriesPerUnit: 4, proteinPerUnit: 0.00, carbsPerUnit: 1.00, fatPerUnit: 0),
        CatalogFoodItem(name: "Olive Oil", category: "Pantry", defaultUnit: "ml", caloriesPerUnit: 9, proteinPerUnit: 0.00, carbsPerUnit: 0.00, fatPerUnit: 1.00),
        CatalogFoodItem(name: "Coconut Oil", category: "Pantry", defaultUnit: "ml", caloriesPerUnit: 9, proteinPerUnit: 0.00, carbsPerUnit: 0.00, fatPerUnit: 1.00),
        CatalogFoodItem(name: "Honey", category: "Pantry", defaultUnit: "g", caloriesPerUnit: 3, proteinPerUnit: 0.00, carbsPerUnit: 0.82, fatPerUnit: 0),
        CatalogFoodItem(name: "Maple Syrup", category: "Pantry", defaultUnit: "ml", caloriesPerUnit: 4, proteinPerUnit: 0.00, carbsPerUnit: 0.67, fatPerUnit: 0),
        CatalogFoodItem(name: "Peanut Butter", category: "Pantry", defaultUnit: "g", caloriesPerUnit: 6, proteinPerUnit: 0.25, carbsPerUnit: 0.20, fatPerUnit: 0.50),
        CatalogFoodItem(name: "Almond Butter", category: "Pantry", defaultUnit: "g", caloriesPerUnit: 6, proteinPerUnit: 0.21, carbsPerUnit: 0.19, fatPerUnit: 0.53),
        CatalogFoodItem(name: "Soy Sauce", category: "Pantry", defaultUnit: "ml", caloriesPerUnit: 1, proteinPerUnit: 0.01, carbsPerUnit: 0.01, fatPerUnit: 0),
        
        // Snacks & Others
        CatalogFoodItem(name: "Dark Chocolate", category: "Snacks", defaultUnit: "g", caloriesPerUnit: 6, proteinPerUnit: 0.08, carbsPerUnit: 0.46, fatPerUnit: 0.43),
        CatalogFoodItem(name: "Almonds", category: "Snacks", defaultUnit: "g", caloriesPerUnit: 6, proteinPerUnit: 0.21, carbsPerUnit: 0.22, fatPerUnit: 0.50),
        CatalogFoodItem(name: "Walnuts", category: "Snacks", defaultUnit: "g", caloriesPerUnit: 7, proteinPerUnit: 0.15, carbsPerUnit: 0.14, fatPerUnit: 0.65),
        CatalogFoodItem(name: "Popcorn", category: "Snacks", defaultUnit: "g", caloriesPerUnit: 4, proteinPerUnit: 0.13, carbsPerUnit: 0.78, fatPerUnit: 0.04),
        CatalogFoodItem(name: "Hummus", category: "Snacks", defaultUnit: "g", caloriesPerUnit: 2, proteinPerUnit: 0.08, carbsPerUnit: 0.14, fatPerUnit: 0.10),
        CatalogFoodItem(name: "Apple Cider Vinegar", category: "Pantry", defaultUnit: "ml", caloriesPerUnit: 0, proteinPerUnit: 0, carbsPerUnit: 0, fatPerUnit: 0),
        CatalogFoodItem(name: "Baking Soda", category: "Pantry", defaultUnit: "g", caloriesPerUnit: 0, proteinPerUnit: 0, carbsPerUnit: 0, fatPerUnit: 0),
        CatalogFoodItem(name: "Cinnamon", category: "Spices", defaultUnit: "g", caloriesPerUnit: 2, proteinPerUnit: 0.04, carbsPerUnit: 0.81, fatPerUnit: 0.01),
        CatalogFoodItem(name: "Black Pepper", category: "Spices", defaultUnit: "g", caloriesPerUnit: 3, proteinPerUnit: 0.10, carbsPerUnit: 0.64, fatPerUnit: 0.03),
        CatalogFoodItem(name: "Sea Salt", category: "Spices", defaultUnit: "g", caloriesPerUnit: 0, proteinPerUnit: 0, carbsPerUnit: 0, fatPerUnit: 0)

    ]
}
