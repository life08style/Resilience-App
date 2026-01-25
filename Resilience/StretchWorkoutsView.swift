import SwiftUI

struct StretchWorkout: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let duration: Int // minutes
    let category: String
    let coverImage: String
}

struct MeditationSession: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let duration: Int
    let focus: String
    let coverImage: String
}

struct StretchWorkoutsView: View {
    @State private var mainTab = "Stretching" // Stretching vs Meditation
    
    // Stretching Filters
    @State private var activeStretchArea = "Full Body"
    @State private var selectedStretchDuration: Int? = nil
    
    // Meditation Filters
    @State private var activeMeditationFocus = "All"
    @State private var selectedMeditationDuration: Int? = nil
    
    let stretchWorkouts: [StretchWorkout] = [
        StretchWorkout(title: "Morning Wake Up", description: "Gentle full body stretch to start your day.", duration: 10, category: "Full Body", coverImage: "https://images.unsplash.com/photo-1544367563-12123d8965cd?w=800"),
        StretchWorkout(title: "Desk Relief", description: "Quick stretches for neck and shoulders.", duration: 5, category: "Upper Body", coverImage: "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800"),
        StretchWorkout(title: "Post-Run Legs", description: "Deep hip and hamstring release.", duration: 15, category: "Lower Body", coverImage: "https://images.unsplash.com/photo-1566241440091-ec10de8db2e1?w=800"),
        StretchWorkout(title: "Hip Flexor Release", description: "Targeted stretches for tight hip flexors.", duration: 12, category: "Lower Body", coverImage: "https://images.unsplash.com/photo-1552196564-972b2c9f7272?w=800"),
        StretchWorkout(title: "Dynamic Shoulder Flow", description: "Improve mobility and posture.", duration: 10, category: "Upper Body", coverImage: "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800"),
        StretchWorkout(title: "Full Body Reset", description: "Holistic restoration for the entire body.", duration: 25, category: "Full Body", coverImage: "https://images.unsplash.com/photo-1588282322671-c0f7049ef82b?w=800"),
        StretchWorkout(title: "Bedtime Yoga", description: "Calming stretches to prepare for sleep.", duration: 20, category: "Full Body", coverImage: "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800"),
        StretchWorkout(title: "Upper Back Fix", description: "Open up chest and shoulders.", duration: 12, category: "Upper Body", coverImage: "https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=800")
    ]
    
    let meditationSessions: [MeditationSession] = [
        MeditationSession(title: "Morning Focus", description: "Set your intentions for the day.", duration: 5, focus: "Focus", coverImage: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800"),
        MeditationSession(title: "Peak Performance", description: "Mental rehearsal for success.", duration: 15, focus: "Focus", coverImage: "https://images.unsplash.com/photo-1499209974431-9dac3adaf471?w=800"),
        MeditationSession(title: "Deep Sleep", description: "Drift off with guided visualization.", duration: 20, focus: "Sleep", coverImage: "https://images.unsplash.com/photo-1519834785169-98be25ec3f84?w=800"),
        MeditationSession(title: "Evening Wind Down", description: "Calm the mind before rest.", duration: 10, focus: "Sleep", coverImage: "https://images.unsplash.com/photo-1515377905703-c4788e51af15?w=800"),
        MeditationSession(title: "Stress Relief", description: "Breathwork for anxiety.", duration: 10, focus: "Stress", coverImage: "https://images.unsplash.com/photo-1447452001602-7090c71201eb?w=800"),
        MeditationSession(title: "Calm in Chaos", description: "Centering techniques for busy days.", duration: 8, focus: "Stress", coverImage: "https://images.unsplash.com/photo-1474418397713-7ded61d46e18?w=800"),
        MeditationSession(title: "Mindful Zen", description: "Brief moment of presence.", duration: 2, focus: "Focus", coverImage: "https://images.unsplash.com/photo-1528319725582-ddc096101511?w=800")
    ]
    
    var filteredStretches: [StretchWorkout] {
        stretchWorkouts.filter { workout in
            let areaMatch = workout.category == activeStretchArea
            let durationMatch = selectedStretchDuration == nil || workout.duration <= selectedStretchDuration!
            return areaMatch && durationMatch
        }
    }
    
    var filteredMeditations: [MeditationSession] {
        meditationSessions.filter { session in
            let focusMatch = activeMeditationFocus == "All" || session.focus == activeMeditationFocus
            let durationMatch = selectedMeditationDuration == nil || session.duration <= selectedMeditationDuration!
            return focusMatch && durationMatch
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Top Tabs (Stretching vs Meditation)
                    HStack {
                        Button(action: { mainTab = "Stretching" }) {
                            VStack {
                                Text("Stretching")
                                    .fontWeight(.bold)
                                    .foregroundColor(mainTab == "Stretching" ? .white : .gray)
                                Rectangle()
                                    .fill(mainTab == "Stretching" ? Color.teal : Color.clear)
                                    .frame(height: 3)
                            }
                        }
                        
                        Button(action: { mainTab = "Meditation" }) {
                            VStack {
                                Text("Meditation")
                                    .fontWeight(.bold)
                                    .foregroundColor(mainTab == "Meditation" ? .white : .gray)
                                Rectangle()
                                    .fill(mainTab == "Meditation" ? Color.purple : Color.clear)
                                    .frame(height: 3)
                            }
                        }
                    }
                    .padding(.top)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            if mainTab == "Stretching" {
                                // Stretching Controls
                                VStack(spacing: 16) {
                                    // Area Tabs
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(["Full Body", "Upper Body", "Lower Body"], id: \.self) { area in
                                                Button(action: { activeStretchArea = area }) {
                                                    Text(area)
                                                        .padding(.horizontal, 16)
                                                        .padding(.vertical, 8)
                                                        .background(activeStretchArea == area ? Color.teal : Color(UIColor.systemGray6).opacity(0.3))
                                                        .foregroundColor(.white)
                                                        .cornerRadius(20)
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    
                                    // Duration Filter
                                    HStack {
                                        Menu {
                                            Button("All Durations") { selectedStretchDuration = nil }
                                            Button("< 10 min") { selectedStretchDuration = 10 }
                                            Button("< 20 min") { selectedStretchDuration = 20 }
                                        } label: {
                                            FilterPill(text: selectedStretchDuration == nil ? "Duration" : "< \(selectedStretchDuration!) min")
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    
                                    // Stretch List
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                        ForEach(filteredStretches) { workout in
                                            NavigationLink(destination: ActiveStretchWorkoutView(workout: workout)) {
                                                WorkoutCard(title: workout.title, subtitle: workout.category, duration: workout.duration, image: workout.coverImage)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                
                            } else {
                                // Meditation Controls
                                VStack(spacing: 16) {
                                    // Focus Tabs
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(["All", "Focus", "Sleep", "Stress"], id: \.self) { focus in
                                                Button(action: { activeMeditationFocus = focus }) {
                                                    Text(focus)
                                                        .padding(.horizontal, 16)
                                                        .padding(.vertical, 8)
                                                        .background(activeMeditationFocus == focus ? Color.purple : Color(UIColor.systemGray6).opacity(0.3))
                                                        .foregroundColor(.white)
                                                        .cornerRadius(20)
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    
                                    HStack {
                                        Menu {
                                            Button("All Durations") { selectedMeditationDuration = nil }
                                            Button("< 10 min") { selectedMeditationDuration = 10 }
                                            Button("< 20 min") { selectedMeditationDuration = 20 }
                                        } label: {
                                            FilterPill(text: selectedMeditationDuration == nil ? "Duration" : "< \(selectedMeditationDuration!) min")
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    
                                    // Meditation List
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                        ForEach(filteredMeditations) { session in
                                            NavigationLink(destination: Text("Meditation Session Playing...").foregroundColor(.white)) {
                                                WorkoutCard(title: session.title, subtitle: session.focus, duration: session.duration, image: session.coverImage)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical)
                        .padding(.bottom, 50)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct WorkoutCard: View {
    let title: String
    let subtitle: String
    let duration: Int
    let image: String
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: image)) { img in
                img.resizable().aspectRatio(contentMode: .fill)
            } placeholder: { Color.gray }
            .frame(height: 140)
            .clipped()
            .cornerRadius(12)
            
            Text(title)
                .font(.headline).fontWeight(.bold).foregroundColor(.white).lineLimit(1)
            HStack {
                Text("\(duration) min")
                Spacer()
                Text(subtitle)
            }
            .font(.caption).foregroundColor(.gray)
        }
        .padding(8)
        .background(Color(UIColor.systemGray6).opacity(0.1))
        .cornerRadius(16)
    }
}
