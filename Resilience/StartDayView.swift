import SwiftUI
import SwiftData

struct StartDayView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoItem.order) private var todos: [TodoItem]
    @ObservedObject private var calendarManager = CalendarManager.shared
    
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Gradient Bloom
            RadialGradient(
                colors: [Color.blue.opacity(0.2), Color.black],
                center: .center,
                startRadius: 50,
                endRadius: 400
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                
                // Greeting
                VStack(spacing: 8) {
                    Text("Good Morning,")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text("Yakir")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.1), radius: 10)
                }
                .opacity(opacity)
                .animation(.easeIn.delay(0.2), value: opacity)
                
                // Blu Mascot
                BluMascotView(customization: BluCustomization.defaultCustomization, size: 150)
                    .shadow(color: .blue.opacity(0.4), radius: 30, x: 0, y: 10)
                    .opacity(opacity)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: opacity)
                
                // Summary Card
                VStack(spacing: 20) {
                    Text("Ready to conquer the day?")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 24) {
                        VStack {
                            Text("\(calendarManager.events.filter { Calendar.current.isDateInToday($0.date) }.count)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.cyan)
                            Text("Events")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        VStack {
                            Text("\(todos.filter { !$0.isCompleted }.count)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                            Text("Tasks")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(30)
                .background(Color(UIColor.systemGray6).opacity(0.15))
                .cornerRadius(24)
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.1), lineWidth: 1))
                .opacity(opacity)
                .animation(.easeOut(duration: 0.6).delay(0.6), value: opacity)
                
                Spacer()
                
                // Start Button
                Button(action: {
                    HapticManager.shared.notification(type: .success)
                    dismiss()
                }) {
                    Text("Let's Go")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                .opacity(opacity)
                .animation(.easeOut(duration: 0.5).delay(1.0), value: opacity)
            }
        }
        .onAppear {
            opacity = 1
        }
    }
}

#Preview {
    StartDayView()
}
