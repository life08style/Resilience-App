import SwiftUI
import SwiftData

struct PantryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PantryItem.name) private var pantryItems: [PantryItem]
    @Query private var cartItems: [CartItem]
    
    @State private var searchQuery = ""
    @State private var showCustomAdd = false
    
    var filteredCatalog: [CatalogFoodItem] {
        if searchQuery.isEmpty { return [] }
        return FoodCatalog.items.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
    }
    
    var groupedPantry: [String: [PantryItem]] {
        Dictionary(grouping: pantryItems, by: { $0.category })
    }
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
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
                        TextField("Search 1,000+ items...", text: $searchQuery)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                        
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
                    
                    // Search Suggestions (Catalog)
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
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                        }
                        .frame(maxHeight: 250)
                    }
                }
                .padding(.horizontal)
                .zIndex(10)
                
                // Pantry List
                ScrollView {
                    VStack(spacing: 24) {
                        if pantryItems.isEmpty && searchQuery.isEmpty {
                            EmptyPantryView()
                        } else {
                            ForEach(groupedPantry.keys.sorted(), id: \.self) { category in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(category.uppercased())
                                        .font(.caption)
                                        .fontWeight(.black)
                                        .foregroundColor(.gray)
                                        .padding(.horizontal)
                                    
                                    ForEach(groupedPantry[category] ?? []) { item in
                                        PantryItemRow(item: item)
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

struct CatalogSearchRow: View {
    let item: CatalogFoodItem
    let onAddPantry: () -> Void
    let onAddCart: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name).foregroundColor(.white)
                Text(item.category).font(.caption2).foregroundColor(.gray)
            }
            Spacer()
            
            Button("Pantry", action: onAddPantry)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.3))
                .cornerRadius(4)
            
            Button("Cart", action: onAddCart)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.3))
                .cornerRadius(4)
        }
        .padding()
    }
}

struct PantryItemRow: View {
    @Bindable var item: PantryItem
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
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

struct EmptyPantryView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "refrigerator")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.3))
            Text("Pantry empty.")
                .foregroundColor(.gray)
            Text("Search for items to get started.")
                .font(.caption)
                .foregroundColor(Color.gray.opacity(0.7))
        }
        .padding(.top, 50)
    }
}
