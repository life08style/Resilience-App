import SwiftUI
import SwiftData

struct CartView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var cartItems: [CartItem]
    @Query private var pantryItems: [PantryItem]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Shopping Cart")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    
                    if !cartItems.isEmpty {
                        Button("Clear All") {
                            clearCart()
                        }
                        .foregroundColor(.red)
                        .font(.subheadline)
                    }
                }
                .padding()
                
                if cartItems.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "cart.fill.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.3))
                        Text("Your cart is empty.")
                            .foregroundColor(.gray)
                        Button("Go to Pantry") {
                            dismiss()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(cartItems) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(item.category)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Button(action: { updateQuantity(item, -1) }) {
                                        Image(systemName: "minus.circle")
                                    }
                                    Text("\(Int(item.quantity))")
                                        .frame(width: 30)
                                    Button(action: { updateQuantity(item, 1) }) {
                                        Image(systemName: "plus.circle")
                                    }
                                }
                                .foregroundColor(.white)
                                
                                Button(action: { modelContext.delete(item) }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .padding(.leading)
                            }
                            .listRowBackground(Color.white.opacity(0.05))
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain)
                    
                    // Checkout Button
                    Button(action: checkout) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("CHECK OUT")
                                .fontWeight(.black)
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.green)
                        .cornerRadius(30)
                    }
                    .padding()
                }
            }
        }
    }
    
    private func updateQuantity(_ item: CartItem, _ change: Double) {
        item.quantity = max(1, item.quantity + change)
    }
    
    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(cartItems[index])
        }
    }
    
    private func clearCart() {
        for item in cartItems {
            modelContext.delete(item)
        }
    }
    
    private func checkout() {
        for cartItem in cartItems {
            // Check if item already in pantry
            if let existingPantryItem = pantryItems.first(where: { $0.name.lowercased() == cartItem.name.lowercased() }) {
                existingPantryItem.quantity += cartItem.quantity
            } else {
                let newPantryItem = PantryItem(
                    name: cartItem.name,
                    category: cartItem.category,
                    quantity: cartItem.quantity,
                    unit: cartItem.unit
                )
                modelContext.insert(newPantryItem)
            }
            modelContext.delete(cartItem)
        }
        dismiss()
    }
}
