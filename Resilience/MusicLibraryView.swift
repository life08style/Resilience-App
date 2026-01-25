import SwiftUI

struct MusicLibraryView: View {
    @State private var playlists: [Playlist] = [
        Playlist(id: UUID(), name: "Workout Hype", description: "High energy tracks", service: "spotify", playlistUrl: nil, coverColor: "red", category: "workout", tracks: []),
        Playlist(id: UUID(), name: "Focus Flow", description: "Deep work beats", service: "apple_music", playlistUrl: nil, coverColor: "blue", category: "focus", tracks: []),
        Playlist(id: UUID(), name: "Sleep Sounds", description: "Calming ambient noise", service: "custom", playlistUrl: nil, coverColor: "purple", category: "sleep", tracks: [])
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                Text("Music Library")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                
                // Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        CategoryPill(title: "All", isSelected: true)
                        CategoryPill(title: "Workout", isSelected: false)
                        CategoryPill(title: "Focus", isSelected: false)
                        CategoryPill(title: "Sleep", isSelected: false)
                    }
                    .padding(.horizontal)
                }
                
                // Playlists Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(playlists) { playlist in
                        PlaylistCard(playlist: playlist)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationTitle("Music")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Picker("Service", selection: $settings.preferredMusicService) {
                    Image(systemName: "applelogo").tag("apple_music")
                    Image(systemName: "waveform.circle.fill").tag("spotify")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 100)
            }
        }
    }
    
    @ObservedObject var settings = UserSettings.shared
}

struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(isSelected ? Color.white : Color(UIColor.systemGray6).opacity(0.3))
            .foregroundColor(isSelected ? .black : .white)
            .cornerRadius(20)
    }
}

struct PlaylistCard: View {
    let playlist: Playlist
    
    var body: some View {
        VStack(alignment: .leading) {
            // Cover Art Placeholder
            Rectangle()
                .fill(color(for: playlist.coverColor))
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(12)
                .overlay(
                    Image(systemName: "music.note")
                        .font(.largeTitle)
                        .foregroundColor(.white.opacity(0.5))
                )
            
            Text(playlist.name)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(playlist.description)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
            
            HStack {
                Image(systemName: serviceIcon(for: playlist.service))
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(playlist.service.capitalized.replacingOccurrences(of: "_", with: " "))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
    
    func color(for name: String) -> Color {
        switch name {
        case "red": return .red
        case "blue": return .blue
        case "purple": return .purple
        default: return .gray
        }
    }
    
    func serviceIcon(for service: String) -> String {
        switch service {
        case "spotify": return "waveform.circle.fill"
        case "apple_music": return "applelogo"
        default: return "music.note.list"
        }
    }
}
