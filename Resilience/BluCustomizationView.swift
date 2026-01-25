import SwiftUI

struct BluCustomizationView: View {
    @State private var customization = BluCustomization.defaultCustomization
    @Environment(\.presentationMode) var presentationMode
    
    let expressions = ["happy", "excited", "focused", "chill", "determined"]
    let outfits = ["casual", "sporty", "formal", "superhero", "sleepwear"]
    let accessories = ["none", "glasses", "headband", "cap", "crown"]
    let colors = ["blue", "purple", "green", "orange", "pink"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Preview
                    VStack {
                        BluMascotView(customization: customization, size: 150)
                            .padding()
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 200, height: 200)
                            )
                        
                        Text("Your Personalized Blu")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // Customization Sections
                    customizationSection(title: "Expression", options: expressions, selection: $customization.expression)
                    customizationSection(title: "Outfit", options: outfits, selection: $customization.outfit)
                    customizationSection(title: "Accessory", options: accessories, selection: $customization.accessory)
                    colorSection
                    
                    Button(action: saveCustomization) {
                        Text("Save Changes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Customize Blu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    func customizationSection(title: String, options: [String], selection: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(options, id: \.self) { option in
                        Button(action: { selection.wrappedValue = option }) {
                            VStack {
                                // Mini Preview
                                BluMascotView(
                                    customization: previewCustomization(for: title, value: option),
                                    size: 40
                                )
                                
                                Text(option.capitalized)
                                    .font(.caption)
                                    .foregroundColor(selection.wrappedValue == option ? .white : .gray)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selection.wrappedValue == option ? Color.blue.opacity(0.2) : Color(UIColor.systemGray6).opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selection.wrappedValue == option ? Color.blue : Color.clear, lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    var colorSection: some View {
        VStack(alignment: .leading) {
            Text("Color Theme")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            HStack(spacing: 16) {
                ForEach(colors, id: \.self) { color in
                    Button(action: { customization.color = color }) {
                        Circle()
                            .fill(colorValue(for: color))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: customization.color == color ? 2 : 0)
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    func previewCustomization(for type: String, value: String) -> BluCustomization {
        var temp = customization
        switch type {
        case "Expression": temp.expression = value
        case "Outfit": temp.outfit = value
        case "Accessory": temp.accessory = value
        default: break
        }
        return temp
    }
    
    func colorValue(for name: String) -> Color {
        switch name {
        case "purple": return .purple
        case "green": return .green
        case "orange": return .orange
        case "pink": return .pink
        default: return .blue
        }
    }
    
    func saveCustomization() {
        // Save logic here (e.g., persist to UserDefaults or API)
        presentationMode.wrappedValue.dismiss()
    }
}
