import SwiftUI

struct PlyometricWorkout: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let duration: Int
    let type: String // Boxing, Explosivity, Agility
    let image: String
}

struct PlyometricsView: View {
    @State private var selectedDuration: Int? = nil
    @State private var selectedType: String? = nil
    
    let workouts: [PlyometricWorkout] = [
        PlyometricWorkout(title: "Heavy Bag HIIT", description: "High intensity boxing rounds.", duration: 20, type: "Boxing", image: "https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?w=800"),
        PlyometricWorkout(title: "Box Jumps & Power", description: "Build explosive leg power.", duration: 30, type: "Explosivity", image: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800"),
        PlyometricWorkout(title: "Ladder Drills", description: "Improve footwork and speed.", duration: 15, type: "Agility", image: "https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=800"),
        PlyometricWorkout(title: "Lateral Bound Series", description: "Focus on lateral power and stability.", duration: 25, type: "Agility", image: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800"),
        PlyometricWorkout(title: "Depth Jump Mastery", description: "Advanced vertical leap training.", duration: 40, type: "Explosivity", image: "https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?w=800"),
        PlyometricWorkout(title: "Reflex Boxing", description: "Focus on head movement and speed.", duration: 20, type: "Boxing", image: "https://images.unsplash.com/photo-1552072092-2f9b1603ee0a?w=800"),
        PlyometricWorkout(title: "Speed Shuttle Runs", description: "Quick change of direction drills.", duration: 20, type: "Agility", image: "https://images.unsplash.com/photo-1538805060514-97d9cc17730c?w=800"),
        PlyometricWorkout(title: "Shadow Boxing", description: "Technique focus without equipment.", duration: 15, type: "Boxing", image: "https://images.unsplash.com/photo-1595078475328-1ab05d0a6a0e?w=800"),
        PlyometricWorkout(title: "Vertical Jump Pro", description: "Advanced plyometrics for height.", duration: 45, type: "Explosivity", image: "https://images.unsplash.com/photo-1434608519344-49d77a699ded?w=800"),
        PlyometricWorkout(title: "Cone Drills", description: "Multi-directional agility work.", duration: 30, type: "Agility", image: "https://images.unsplash.com/photo-1606335543042-57c525922933?w=800")
    ]
    
    var filteredWorkouts: [PlyometricWorkout] {
        workouts.filter { workout in
            let durationMatch = selectedDuration == nil || workout.duration <= selectedDuration!
            let typeMatch = selectedType == nil || workout.type == selectedType
            return durationMatch && typeMatch
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                         Button(action: {}) {
                             Image(systemName: "arrow.left")
                                 .foregroundColor(.white)
                                 .font(.title2)
                         } 
                         Spacer()
                    }
                    .padding(.bottom, 8)
                    
                    Text("Plyometrics & Agility")
                        .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass").foregroundColor(.gray)
                        Text("Search workouts...").foregroundColor(.gray)
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6).opacity(0.3))
                    .cornerRadius(12)
                }
                .padding()
                
                // Filters
                VStack(alignment: .leading, spacing: 12) {
                    Text("FILTERS").font(.caption).fontWeight(.bold).foregroundColor(.gray).padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            Text("Difficulty").foregroundColor(.gray).font(.subheadline)
                            FilterBubble(text: "All", isSelected: true)
                            FilterBubble(text: "Beginner", isSelected: false)
                            FilterBubble(text: "Intermediate", isSelected: false)
                            FilterBubble(text: "Advanced", isSelected: false)
                        }
                        .padding(.horizontal)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            Text("Duration").foregroundColor(.gray).font(.subheadline)
                            FilterBubble(text: "All", isSelected: true)
                            FilterBubble(text: "10 min", isSelected: false)
                            FilterBubble(text: "20 min", isSelected: false)
                            FilterBubble(text: "30 min", isSelected: false)
                        }
                        .padding(.horizontal)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            Text("Focus").foregroundColor(.gray).font(.subheadline)
                            FilterBubble(text: "All", isSelected: true)
                            FilterBubble(text: "Plyometrics", isSelected: false)
                            FilterBubble(text: "Boxing", isSelected: false)
                            FilterBubble(text: "Cardio", isSelected: false)
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Workout List
                VStack(alignment: .leading) {
                    Text("\(filteredWorkouts.count) workouts").font(.caption).foregroundColor(.gray).padding(.horizontal)
                    
                    LazyVStack(spacing: 16) {
                        ForEach(filteredWorkouts) { workout in
                            PlyoWorkoutCard(workout: workout)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 50)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
    }
}

struct FilterBubble: View {
    let text: String
    let isSelected: Bool
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(isSelected ? .black : .white)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(isSelected ? Color.cyan : Color(UIColor.systemGray6).opacity(0.3))
            .cornerRadius(20)
    }
}

struct PlyoWorkoutCard: View {
    let workout: PlyometricWorkout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(workout.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            
            Text(workout.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Circle().fill(Color.green).frame(width: 8, height: 8)
                    Text("Beginner")
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text("\(workout.duration) min")
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text("4 rounds")
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "hand.raised.fill")
                        .foregroundColor(.orange)
                    Text("Technique")
                        .foregroundColor(.orange)
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.15))
        .cornerRadius(16)
    }
}
