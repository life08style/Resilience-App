import SwiftUI

struct MindfulnessView: View {
    @State private var mainTab = "Meditation" // Default to Meditation as per image
    @Environment(\.presentationMode) var presentationMode
    
    // Filters
    @State private var selectedFilter = "All"
    @State private var selectedDuration: Int? = nil
    
    let meditationSessions: [MeditationSession] = [
        MeditationSession(title: "Morning Clarity", description: "Start your day with focused awareness.", duration: 5, focus: "Mindfulness", coverImage: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800"),
        MeditationSession(title: "Quick Reset", description: "Brief mindfulness practice for instant calm.", duration: 5, focus: "Mindfulness", coverImage: "https://images.unsplash.com/photo-1499209974431-9dac3adaf471?w=800"),
        MeditationSession(title: "Deep Sleep Release", description: "Drift off with guided visualization.", duration: 20, focus: "Sleep", coverImage: "https://images.unsplash.com/photo-1519834785169-98be25ec3f84?w=800"),
        MeditationSession(title: "Evening Wind Down", description: "Calm the mind before rest.", duration: 10, focus: "Sleep", coverImage: "https://images.unsplash.com/photo-1515377905703-c4788e51af15?w=800"),
        MeditationSession(title: "Anxiety SOS", description: "Breathwork for anxiety moments.", duration: 10, focus: "Breathing", coverImage: "https://images.unsplash.com/photo-1447452001602-7090c71201eb?w=800"),
        MeditationSession(title: "Body Scan", description: "Relax tension in the body.", duration: 15, focus: "Body Scan", coverImage: "https://images.unsplash.com/photo-1474418397713-7ded61d46e18?w=800")
    ]
    
    let stretchWorkouts: [StretchWorkout] = [
        StretchWorkout(title: "Morning Wake Up", description: "Gentle full body stretch.", duration: 10, category: "Full Body", coverImage: "https://images.unsplash.com/photo-1544367563-12123d8965cd?w=800"),
        StretchWorkout(title: "Desk Relief", description: "Neck and shoulders.", duration: 5, category: "Upper Body", coverImage: "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800")
    ]
    
    var filteredSessions: [MeditationSession] {
        meditationSessions.filter { session in
            let focusMatch = selectedFilter == "All" || session.focus == selectedFilter
            let durationMatch = selectedDuration == nil || session.duration <= selectedDuration!
            return focusMatch && durationMatch
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero Header
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?w=800")) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: { Color.gray }
                    .frame(height: 250)
                    .clipped()
                    .overlay(LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(.white)
                            .font(.subheadline)
                        }
                        .padding(.bottom, 20)
                        
                        Text("Mindfulness\n& Recovery")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .lineLimit(2)
                        
                        Text("Meditation and stretching for body and mind")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                
                // Tabs
                HStack(spacing: 0) {
                    TabButton(text: "Meditation", isSelected: mainTab == "Meditation") { mainTab = "Meditation" }
                    TabButton(text: "Stretching", isSelected: mainTab == "Stretching") { mainTab = "Stretching" }
                }
                .background(Color(UIColor.systemGray6).opacity(0.3))
                .cornerRadius(12)
                .padding(.horizontal)
                
                if mainTab == "Meditation" {
                    // Filters
                    VStack(spacing: 16) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                FilterChip(text: "All", isSelected: selectedFilter == "All") { selectedFilter = "All" }
                                FilterChip(text: "Mindfulness", isSelected: selectedFilter == "Mindfulness") { selectedFilter = "Mindfulness" }
                                FilterChip(text: "Breathing", isSelected: selectedFilter == "Breathing") { selectedFilter = "Breathing" }
                                FilterChip(text: "Body Scan", isSelected: selectedFilter == "Body Scan") { selectedFilter = "Body Scan" }
                                FilterChip(text: "Sleep", isSelected: selectedFilter == "Sleep") { selectedFilter = "Sleep" }
                            }
                            .padding(.horizontal)
                        }
                        
                        HStack {
                            Text("Duration").font(.caption).foregroundColor(.gray)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    DurationChip(text: "< 5 min", isSelected: selectedDuration == 5) { selectedDuration = (selectedDuration == 5 ? nil : 5) }
                                    DurationChip(text: "< 10 min", isSelected: selectedDuration == 10) { selectedDuration = (selectedDuration == 10 ? nil : 10) }
                                    DurationChip(text: "< 15 min", isSelected: selectedDuration == 15) { selectedDuration = (selectedDuration == 15 ? nil : 15) }
                                    DurationChip(text: "< 20 min", isSelected: selectedDuration == 20) { selectedDuration = (selectedDuration == 20 ? nil : 20) }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Session Count
                    HStack {
                        Text("\(filteredSessions.count) Sessions Available")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // List
                    LazyVStack(spacing: 16) {
                        ForEach(filteredSessions) { session in
                            MindfulnessCard(session: session)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                } else {
                    // Reuse StretchWorkoutsView logic or put a placeholder for now
                    Text("Stretching Content Coming Soon")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
    }
}

// Components
struct TabButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(isSelected ? .white : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color.purple : Color.clear)
                .cornerRadius(12)
        }
    }
}

struct FilterChip: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .black : .white)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(isSelected ? Color.purple : Color(UIColor.systemGray6).opacity(0.3))
                .cornerRadius(20)
        }
    }
}

struct DurationChip: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color.purple.opacity(0.5) : Color(UIColor.systemGray6).opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 1)
                )
        }
    }
}

struct MindfulnessCard: View {
    let session: MeditationSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(session.title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(session.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text("\(session.duration) min")
                }
                
                Text("•")
                
                Text(session.focus)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.purple.opacity(0.2))
                    .cornerRadius(4)
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            HStack {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                        Text("Schedule")
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Start Now")
                    }
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.orange)
                    .cornerRadius(8)
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
