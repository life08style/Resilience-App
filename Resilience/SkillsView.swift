import SwiftUI

struct SkillsView: View {
    var body: some View {
        ResiliencePage(showBackButton: true) {
            VStack(spacing: 24) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Skill Mastery")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        Text("Master your craft.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "brain.head.profile")
                        .font(.largeTitle)
                        .foregroundColor(.purple)
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.purple.opacity(0.3))
                    Text("Skills Tracker Coming Soon")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Define, track, and level up your core skills through consistent daily practice.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    SkillsView()
        .background(Color.black)
}
