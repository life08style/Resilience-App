import Foundation
import UIKit

class MusicManager {
    static let shared = MusicManager()
    
    func openPlaylist(_ playlist: Playlist) {
        let service = UserSettings.shared.preferredMusicService
        
        if service == "spotify" {
            // Spotify Deep Link
            let spotifyUrlString = "spotify:playlist:\(playlist.id.uuidString)" // Placeholder ID logic
            if let url = URL(string: spotifyUrlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                // Fallback to web or app store
                if let webUrl = URL(string: "https://open.spotify.com") {
                    UIApplication.shared.open(webUrl)
                }
            }
        } else {
            // Apple Music Deep Link
            let appleMusicUrlString = "music://music.apple.com" // Placeholder
            if let url = URL(string: appleMusicUrlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                if let webUrl = URL(string: "https://music.apple.com") {
                    UIApplication.shared.open(webUrl)
                }
            }
        }
    }
}
