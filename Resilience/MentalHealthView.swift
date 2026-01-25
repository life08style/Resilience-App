import SwiftUI

struct MentalHealthView: View {
    let features = [
        MentalHealthFeature(title: "Meditation", icon: "wind", color: .teal, description: "Guided sessions"),
        MentalHealthFeature(title: "Journaling", icon: "book.fill", color: .orange, description: "Daily reflections"),
        MentalHealthFeature(title: "Mood", icon: "face.smiling.fill", color: .yellow, description: "Track emotions"),
        MentalHealthFeature(title: "Breathing", icon: "lungs.fill", color: .blue, description: "Box breathing"),
        MentalHealthFeature(title: "Therapy", icon: "person.2.fill", color: .purple, description: "Connect with pros"),
        MentalHealthFeature(title: "Community", icon: "heart.fill", color: .pink, description: "Support groups")
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerView
                dailyCheckInCard
                featuresGrid
            }
            .padding(.vertical)
        }
        .navigationTitle("Mental Health")
        .background(DesignSystem.Colors.background.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
    
    private var headerView: some View {
        VStack(alignment: .leading) {
            Text("Mental Wellness")
                .font(.largeTitle)
                .bold()
            Text("Take a moment for yourself")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
    
    private var dailyCheckInCard: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Daily Check-in")
                        .font(.headline)
                    Text("How are you feeling today?")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "sun.max.fill")
                    .font(.largeTitle)
                    .foregroundColor(.yellow)
            }
            
            HStack(spacing: 20) {
                ForEach(["😔", "😐", "🙂", "😄", "🤩"], id: \.self) { mood in
                    Text(mood)
                        .font(.title)
                        .padding(8)
                        .background(DesignSystem.Colors.surface)
                        .clipShape(Circle())
                }
            }
            .padding(.top)
        }
        .padding()
        .background(DesignSystem.Colors.surface.opacity(0.5))
        .cornerRadius(16)
        .padding(.horizontal)
    }
    
    private var featuresGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(features) { feature in
                MHFeatureCard(feature: feature)
            }
        }
        .padding(.horizontal)
    }
}

struct MentalHealthFeature: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let description: String
}

struct MHFeatureCard: View {
    let feature: MentalHealthFeature
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: feature.icon)
                .font(.title)
                .foregroundColor(feature.color)
                .padding(10)
                .background(feature.color.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(feature.title)
                    .font(.headline)
                Text(feature.description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DesignSystem.Colors.surface.opacity(0.5))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}
