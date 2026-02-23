import SwiftUI
import SwiftData

// MARK: - Fuzzy / autocorrect search helpers

private extension String {
    /// Levenshtein edit distance between self and another string.
    func editDistance(to other: String) -> Int {
        let s = Array(self.lowercased())
        let t = Array(other.lowercased())
        let m = s.count, n = t.count
        if m == 0 { return n }
        if n == 0 { return m }
        var prev = Array(0...n)
        var curr = [Int](repeating: 0, count: n + 1)
        for i in 1...m {
            curr[0] = i
            for j in 1...n {
                if s[i-1] == t[j-1] {
                    curr[j] = prev[j-1]
                } else {
                    curr[j] = 1 + Swift.min(prev[j], curr[j-1], prev[j-1])
                }
            }
            prev = curr
        }
        return prev[n]
    }

    /// True when this string approximately matches a query (prefix OR fuzzy distance).
    func fuzzyMatches(_ query: String) -> Bool {
        let q = query.lowercased().trimmingCharacters(in: .whitespaces)
        let s = self.lowercased()
        if s.contains(q) { return true }
        // Allow edit distance up to max(1, query.count/3) for typo tolerance
        let threshold = Swift.max(1, q.count / 3)
        // Check against each word in the item name
        let words = s.components(separatedBy: " ")
        for word in words where word.count >= q.count - threshold {
            if word.editDistance(to: q) <= threshold { return true }
        }
        return false
    }
}

// MARK: - FoodCatalog emoji mapping

private let foodEmojis: [String: String] = [
    "Apple": "🍎", "Banana": "🍌", "Orange": "🍊", "Strawberry": "🍓",
    "Blueberry": "🫐", "Mango": "🥭", "Pineapple": "🍍", "Watermelon": "🍉",
    "Grape": "🍇", "Peach": "🍑", "Avocado": "🥑", "Lemon": "🍋",
    "Lime": "🍋", "Raspberry": "🍓", "Blackberry": "🫐", "Pear": "🍐",
    "Cherry": "🍒", "Plum": "🍑", "Kiwi": "🥝", "Pomegranate": "🍎",
    "Carrot": "🥕", "Broccoli": "🥦", "Spinach": "🥬", "Kale": "🥬",
    "Tomato": "🍅", "Cucumber": "🥒", "Bell Pepper": "🫑", "Onion": "🧅",
    "Garlic": "🧄", "Potato": "🥔", "Sweet Potato": "🍠", "Zucchini": "🥒",
    "Eggplant": "🍆", "Asparagus": "🌿", "Cauliflower": "🥦", "Celery": "🌿",
    "Mushroom": "🍄", "Lettuce": "🥬", "Cabbage": "🥬", "Green Beans": "🌿",
    "Chicken Breast": "🍗", "Chicken Thigh": "🍗", "Ground Beef": "🥩",
    "Steak": "🥩", "Salmon": "🐟", "Tuna": "🐟", "Eggs": "🥚",
    "Tofu": "🧀", "Pork Chop": "🥩", "Turkey": "🦃", "Shrimp": "🦐",
    "Cod": "🐟", "Lentils": "🫘", "Chickpeas": "🫘", "Black Beans": "🫘",
    "Milk": "🥛", "Almond Milk": "🥛", "Oat Milk": "🥛",
    "Greek Yogurt": "🥛", "Cheddar Cheese": "🧀", "Mozzarella": "🧀",
    "Butter": "🧈", "Cottage Cheese": "🧀", "Cream Cheese": "🧀",
    "Sour Cream": "🥛", "White Rice": "🍚", "Brown Rice": "🍚",
    "Quinoa": "🌾", "Oats": "🌾", "Pasta": "🍝", "Bread": "🍞",
    "Flour": "🌾", "Sugar": "🍬", "Olive Oil": "🫙", "Coconut Oil": "🫙",
    "Honey": "🍯", "Maple Syrup": "🍁", "Peanut Butter": "🥜",
    "Almond Butter": "🥜", "Soy Sauce": "🍶", "Dark Chocolate": "🍫",
    "Almonds": "🥜", "Walnuts": "🥜", "Popcorn": "🍿", "Hummus": "🫙",
    "Apple Cider Vinegar": "🍶", "Baking Soda": "🧂", "Cinnamon": "🌰",
    "Black Pepper": "🌶️", "Sea Salt": "🧂"
]

/// The "popular" items shown as suggestions when search is empty.
private let suggestedItemNames: [String] = [
    "Apple", "Banana", "Eggs", "Chicken Breast", "Milk",
    "Salmon", "Avocado", "Broccoli", "Greek Yogurt", "Oats",
    "Tomato", "Bread", "Spinach", "Orange", "Blueberry",
    "Strawberry", "Carrot", "Pasta", "Potato", "Mango"
]

// MARK: - PantryView

struct PantryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PantryItem.name) private var pantryItems: [PantryItem]
    @Query private var cartItems: [CartItem]

    @State private var searchQuery = ""
    @State private var showCustomAdd = false

    var showBackButton: Bool = true

    // Fuzzy + contains search results
    var filteredCatalog: [CatalogFoodItem] {
        let q = searchQuery.trimmingCharacters(in: .whitespaces)
        if q.isEmpty { return [] }
        let exact   = FoodCatalog.items.filter { $0.name.localizedCaseInsensitiveContains(q) }
        let fuzzy   = FoodCatalog.items.filter { !$0.name.localizedCaseInsensitiveContains(q) && $0.name.fuzzyMatches(q) }
        return (exact + fuzzy).prefix(12).map { $0 }
    }

    var suggestedItems: [CatalogFoodItem] {
        suggestedItemNames.compactMap { name in
            FoodCatalog.items.first { $0.name == name }
        }
    }

    var groupedPantry: [String: [PantryItem]] {
        Dictionary(grouping: pantryItems, by: { $0.category })
    }

    var body: some View {
        ResiliencePage(showBackButton: showBackButton) {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Pantry & Fridge")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()

                    NavigationLink(destination: CartView()) {
                        HStack {
                            Image(systemName: "cart.fill")
                            Text("Cart")
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .overlay(
                            badgeOverlay(count: cartItems.count),
                            alignment: .topTrailing
                        )
                    }
                }
                .padding()

                // Search Bar
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search or add items…", text: $searchQuery)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .autocorrectionDisabled(true)

                        if !searchQuery.isEmpty {
                            Button(action: { searchQuery = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)

                    // Search results (autocorrect / fuzzy)
                    if !filteredCatalog.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(filteredCatalog) { item in
                                    CatalogSearchRow(item: item, onAddPantry: {
                                        addToPantry(item)
                                        searchQuery = ""
                                    }, onAddCart: {
                                        addToCart(item)
                                        searchQuery = ""
                                    })
                                    Divider().background(Color.gray.opacity(0.2))
                                }
                            }
                            .background(Color(UIColor.systemGray6).opacity(0.3))
                            .cornerRadius(12)
                        }
                        .frame(maxHeight: 260)
                    } else if !searchQuery.isEmpty {
                        // No results hint
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.gray)
                            Text("No matches found. Try a different spelling?")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal)
                .zIndex(10)

                // Main scroll area
                ScrollView {
                    VStack(spacing: 24) {
                        // Suggested items grid (only when search is empty)
                        if searchQuery.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("SUGGESTED ITEMS")
                                    .font(.caption)
                                    .fontWeight(.black)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)

                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 12) {
                                    ForEach(suggestedItems) { item in
                                        SuggestedItemCard(item: item, onTap: {
                                            addToPantry(item)
                                        })
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        // Pantry list
                        if pantryItems.isEmpty && searchQuery.isEmpty {
                            EmptyPantryView()
                        } else if !pantryItems.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("YOUR PANTRY")
                                    .font(.caption)
                                    .fontWeight(.black)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)

                                ForEach(groupedPantry.keys.sorted(), id: \.self) { category in
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text(category.uppercased())
                                            .font(.caption2)
                                            .fontWeight(.black)
                                            .foregroundColor(.gray.opacity(0.7))
                                            .padding(.horizontal)

                                        ForEach(groupedPantry[category] ?? []) { item in
                                            PantryItemRow(item: item)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top)
                    .padding(.bottom, 100)
                }
            }
        }
    }

    // MARK: - Actions

    private func addToPantry(_ catalogItem: CatalogFoodItem) {
        if let existing = pantryItems.first(where: { $0.name.lowercased() == catalogItem.name.lowercased() }) {
            existing.quantity += 1
        } else {
            let newItem = PantryItem(name: catalogItem.name, category: catalogItem.category, quantity: 1, unit: catalogItem.defaultUnit)
            modelContext.insert(newItem)
        }
    }

    private func addToCart(_ catalogItem: CatalogFoodItem) {
        if let existing = cartItems.first(where: { $0.name.lowercased() == catalogItem.name.lowercased() }) {
            existing.quantity += 1
        } else {
            let newItem = CartItem(name: catalogItem.name, category: catalogItem.category, quantity: 1, unit: catalogItem.defaultUnit)
            modelContext.insert(newItem)
        }
    }

    @ViewBuilder
    private func badgeOverlay(count: Int) -> some View {
        if count > 0 {
            Text("\(count)")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Color.red)
                .clipShape(Circle())
                .offset(x: 10, y: -10)
        }
    }
}

// MARK: - PressableButtonStyle

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.93 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - SuggestedItemCard

struct SuggestedItemCard: View {
    let item: CatalogFoodItem
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                FoodImage(itemName: item.name, size: 56)

                Text(item.name)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 4)
            .background(Color.white.opacity(0.07))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
        }
        .buttonStyle(PressableButtonStyle())
    }
}

// MARK: - FoodImage (image with emoji fallback)

struct FoodImage: View {
    let itemName: String
    let size: CGFloat

    private var assetName: String {
        itemName.lowercased()
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")
    }

    private var emoji: String {
        foodEmojis[itemName] ?? "🛒"
    }

    var body: some View {
        Group {
            if UIImage(named: assetName) != nil {
                Image(assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: size * 0.22))
            } else {
                Text(emoji)
                    .font(.system(size: size * 0.65))
                    .frame(width: size, height: size)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: size * 0.22))
            }
        }
    }
}

// MARK: - CatalogSearchRow

struct CatalogSearchRow: View {
    let item: CatalogFoodItem
    let onAddPantry: () -> Void
    let onAddCart: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            FoodImage(itemName: item.name, size: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .foregroundColor(.white)
                    .font(.subheadline)
                Text(item.category)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            Spacer()

            Button(action: onAddPantry) {
                Label("Pantry", systemImage: "refrigerator")
                    .font(.caption)
                    .labelStyle(.titleOnly)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Color.blue.opacity(0.3))
            .foregroundColor(.white)
            .cornerRadius(6)

            Button(action: onAddCart) {
                Label("Cart", systemImage: "cart")
                    .font(.caption)
                    .labelStyle(.titleOnly)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Color.green.opacity(0.3))
            .foregroundColor(.white)
            .cornerRadius(6)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

// MARK: - PantryItemRow

struct PantryItemRow: View {
    @Bindable var item: PantryItem
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        HStack(spacing: 12) {
            FoodImage(itemName: item.name, size: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(Int(item.quantity)) \(item.unit)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            HStack(spacing: 12) {
                Button(action: { item.quantity = max(0, item.quantity - 1) }) {
                    Image(systemName: "minus.circle")
                }

                Text("\(Int(item.quantity))")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(minWidth: 20)

                Button(action: { item.quantity += 1 }) {
                    Image(systemName: "plus.circle")
                }

                Button(action: { modelContext.delete(item) }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red.opacity(0.6))
                }
            }
            .foregroundColor(.white)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - EmptyPantryView

struct EmptyPantryView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "refrigerator")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.3))
            Text("Pantry empty.")
                .foregroundColor(.gray)
            Text("Tap a suggested item or search to get started.")
                .font(.caption)
                .foregroundColor(Color.gray.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 30)
    }
}
