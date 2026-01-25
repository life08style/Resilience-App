import Foundation

class AIService {
    static let shared = AIService()
    
    // REPLACE WITH YOUR ACTUAL API KEY
    private let apiKey = "YOUR_GEMINI_API_KEY"
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"
    
    private init() {}
    
    func sendMessage(history: [ChatMessage], newMessage: String) async throws -> String {
        // Construct the prompt from history
        var contents: [[String: Any]] = []
        
        for message in history {
            let role = message.isUser ? "user" : "model"
            contents.append([
                "role": role,
                "parts": [
                    ["text": message.text]
                ]
            ])
        }
        
        // Add the new message
        contents.append([
            "role": "user",
            "parts": [
                ["text": newMessage]
            ]
        ])
        
        let body: [String: Any] = [
            "contents": contents
        ]
        
        return try await performRequest(body: body)
    }
    
    func generateWorkoutPlan(goal: String) async throws -> String {
        let prompt = """
        Generate a 4-week workout plan for a user with the goal: "\(goal)".
        Return ONLY valid JSON with the following structure:
        {
            "planName": "String",
            "goal": "String",
            "durationWeeks": 4,
            "workoutsPerWeek": Int,
            "workoutDurationMinutes": Int,
            "weeklySchedule": [
                {
                    "day": "Monday",
                    "workoutName": "String",
                    "exercises": ["String", "String"],
                    "notes": "String"
                }
            ]
        }
        """
        
        let body: [String: Any] = [
            "contents": [
                [
                    "role": "user",
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]
        
        return try await performRequest(body: body)
    }
    
    private func performRequest(body: [String: Any]) async throws -> String {
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Parse Gemini Response
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let candidates = json["candidates"] as? [[String: Any]],
           let firstCandidate = candidates.first,
           let content = firstCandidate["content"] as? [String: Any],
           let parts = content["parts"] as? [[String: Any]],
           let firstPart = parts.first,
           let text = firstPart["text"] as? String {
            return text
        }
        
        throw URLError(.cannotParseResponse)
    }
}
