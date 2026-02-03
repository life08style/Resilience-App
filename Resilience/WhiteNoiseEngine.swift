import Foundation
import AVFoundation

class WhiteNoiseEngine: NSObject {
    static let shared = WhiteNoiseEngine()
    
    private var players: [String: AVAudioPlayer] = [:]
    
    // Maintain a reference to active sounds to restore them if needed, 
    // though the players dict effectively does this.
    
    private override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            // .playback with .mixWithOthers allows background audio (like Spotify) to continue 
            // but might duck or mix depending on requirements. 
            // For white noise, mixing is usually preferred.
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session in WhiteNoiseEngine: \(error)")
        }
    }
    
    /// Toggles a sound loop on or off.
    /// - Parameter name: The name of the sound file (without extension), e.g., "Ocean".
    /// - Returns: True if the sound started playing, false if it stopped or failed to start.
    func toggleSound(named name: String) -> Bool {
        if let player = players[name], player.isPlaying {
            player.stop()
            players.removeValue(forKey: name)
            return false
        } else {
            // Try to start playing
            if playSound(named: name) {
                return true
            } else {
                return false
            }
        }
    }
    
    /// Plays a specific sound loop.
    private func playSound(named name: String) -> Bool {
        // Attempt to find the file with common extensions
        let extensions = ["mp3", "wav", "m4a"]
        var url: URL?
        
        for ext in extensions {
            if let fileUrl = Bundle.main.url(forResource: name, withExtension: ext) {
                url = fileUrl
                break
            }
            // Also try lowercase
            if let fileUrl = Bundle.main.url(forResource: name.lowercased(), withExtension: ext) {
                url = fileUrl
                break
            }
        }
        
        guard let soundUrl = url else {
            print("Sound file not found for: \(name)")
            return false
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: soundUrl)
            player.numberOfLoops = -1 // Infinite loop
            player.prepareToPlay()
            player.play()
            players[name] = player
            return true
        } catch {
            print("Error loading sound \(name): \(error)")
            return false
        }
    }
    
    func stopAll() {
        for player in players.values {
            player.stop()
        }
        players.removeAll()
    }
    
    func isPlaying(named name: String) -> Bool {
        return players[name]?.isPlaying ?? false
    }
}
