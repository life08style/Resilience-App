import SwiftUI

struct WorkoutPlansPage: View {
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            // Other icons
                            Image(systemName: "trophy.fill").foregroundColor(.orange)
                            Text("Resilience").font(.headline).fontWeight(.black).foregroundColor(.white)
                            Image(systemName: "music.note").foregroundColor(.purple)
                            Image(systemName: "gearshape.fill").foregroundColor(.gray)
                        }
                        
                        Text("Workout Plans")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundColor(.gray)
                            TextField("Search plans...", text: $searchText)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6).opacity(0.3))
                        .cornerRadius(12)
                    }
                    .padding()
                    
                    // Large Action Buttons
                    HStack(spacing: 16) {
                        // Create Plan
                        Button(action: {}) {
                            VStack(alignment: .leading, spacing: 12) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.cyan)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Create Plan")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text("Build manually")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .frame(height: 140)
                            .background(Color(UIColor.systemGray6).opacity(0.2))
                            .cornerRadius(16)
                        }
                        
                        // AI Generate
                        Button(action: {}) {
                            VStack(alignment: .leading, spacing: 12) {
                                Image(systemName: "sparkles")
                                    .font(.largeTitle)
                                    .foregroundColor(.purple)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("AI Generate")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text("Let Coach create")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .frame(height: 140)
                            .background(Color(UIColor.systemGray6).opacity(0.2))
                            .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Empty State
                    VStack(spacing: 16) {
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("No workout plans yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Create your first plan to get started!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 100)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}
