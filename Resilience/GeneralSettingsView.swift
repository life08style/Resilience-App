import SwiftUI

struct GeneralSettingsView: View {
    @ObservedObject var settings = UserSettings.shared
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            ScrollView {
                VStack(spacing: 24) {
                    Text("App Settings")
                        .font(DesignSystem.Fonts.titleLarge())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Units Section
                    VStack(alignment: .leading, spacing: 12) {
                        Label {
                            Text("Unit System")
                                .font(.headline)
                                .foregroundColor(.white)
                        } icon: {
                            Image(systemName: "ruler.fill")
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                        
                        Picker("Units", selection: $settings.unitSystem) {
                            Text("Imperial (lbs, miles)").tag(UserSettings.UnitSystem.imperial)
                            Text("Metric (kg, km)").tag(UserSettings.UnitSystem.metric)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        
                        Text("This updates all measurements across the app including weight tracking and exercise volume.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // Integrations
                    VStack(alignment: .leading, spacing: 16) {
                        Text("INTEGRATIONS")
                            .font(.caption2.bold())
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            ToggleRow(title: "Apple Health", icon: "heart.fill", color: .red, isOn: $settings.healthConnected)
                            Divider().background(Color.white.opacity(0.1)).padding(.leading, 50)
                            ToggleRow(title: "Notifications", icon: "bell.fill", color: .yellow, isOn: $settings.notificationsEnabled)
                        }
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(20)
                        .padding(.horizontal)
                    }
                    
                    // Data Management
                    VStack(alignment: .leading, spacing: 16) {
                        Text("DATA MANAGEMENT")
                            .font(.caption2.bold())
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        Button(action: {}) {
                            HStack {
                                Text("Clear App Cache")
                                Spacer()
                                Text("42 MB").foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                        .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct ToggleRow: View {
    let title: String
    let icon: String
    let color: Color
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 32)
            
            Text(title)
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.blue)
        }
        .padding()
    }
}

#Preview {
    GeneralSettingsView()
}
