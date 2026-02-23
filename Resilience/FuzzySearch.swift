import Foundation

/// Lightweight fuzzy search utility for food/recipe matching.
/// Supports token-prefix matching and edit-distance (Levenshtein) fallback
/// so users don't need perfect spelling.
struct FuzzySearch {

    /// A scored match result used for sorting by relevance.
    struct ScoredItem<T> {
        let item: T
        let score: Int // lower = better match
    }

    // MARK: - Public API

    /// Returns items whose `name` fuzzy-matches the `query`, sorted by relevance.
    /// - Parameters:
    ///   - query: The user's search text (may contain typos).
    ///   - items: The full list of items to search.
    ///   - keyPath: A key path to the string field to match against.
    ///   - maxDistance: Maximum allowed Levenshtein distance for single-word fuzzy fallback.
    static func search<T>(
        query: String,
        in items: [T],
        by keyPath: KeyPath<T, String>,
        maxDistance: Int = 2
    ) -> [T] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else { return [] }

        var scored: [ScoredItem<T>] = []

        for item in items {
            let name = item[keyPath: keyPath].lowercased()

            // 1) Exact prefix — best score
            if name.hasPrefix(trimmed) {
                scored.append(ScoredItem(item: item, score: 0))
                continue
            }

            // 2) Substring contains — very good score
            if name.contains(trimmed) {
                scored.append(ScoredItem(item: item, score: 1))
                continue
            }

            // 3) Token-prefix matching
            //    "chic bre" matches "Chicken Breast" because
            //    "chic" is a prefix of "chicken" and "bre" is a prefix of "breast"
            let queryTokens = trimmed.split(separator: " ").map(String.init)
            let nameTokens = name.split(separator: " ").map(String.init)

            if queryTokens.count > 1 {
                let allTokensMatch = queryTokens.allSatisfy { qt in
                    nameTokens.contains { nt in nt.hasPrefix(qt) }
                }
                if allTokensMatch {
                    scored.append(ScoredItem(item: item, score: 2))
                    continue
                }
            }

            // 4) Fuzzy match on individual tokens — allows typos
            //    "brocoli" matches "broccoli" (edit distance 1)
            if queryTokens.count == 1 {
                // Compare against each token in the name
                let bestDist = nameTokens.map { nt in
                    levenshteinPrefix(source: trimmed, target: nt)
                }.min() ?? Int.max

                if bestDist <= maxDistance {
                    scored.append(ScoredItem(item: item, score: 3 + bestDist))
                    continue
                }
            } else {
                // Multi-word fuzzy: each query token must fuzzy-match some name token
                let allFuzzy = queryTokens.allSatisfy { qt in
                    nameTokens.contains { nt in
                        nt.hasPrefix(qt) || levenshtein(qt, String(nt.prefix(qt.count + maxDistance))) <= maxDistance
                    }
                }
                if allFuzzy {
                    scored.append(ScoredItem(item: item, score: 4))
                    continue
                }
            }
        }

        return scored.sorted { $0.score < $1.score }.map(\.item)
    }

    /// Convenience overload that also searches across multiple string fields.
    static func search<T>(
        query: String,
        in items: [T],
        by keyPaths: [KeyPath<T, String>],
        maxDistance: Int = 2
    ) -> [T] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else { return [] }

        var scored: [ScoredItem<T>] = []

        for item in items {
            var bestScore = Int.max

            for kp in keyPaths {
                let name = item[keyPath: kp].lowercased()
                let s = matchScore(query: trimmed, target: name, maxDistance: maxDistance)
                bestScore = min(bestScore, s)
            }

            if bestScore < Int.max {
                scored.append(ScoredItem(item: item, score: bestScore))
            }
        }

        // Deduplicate by keeping unique items in score order
        var seen = Set<Int>()
        var result: [T] = []
        for s in scored.sorted(where: { $0.score < $1.score }) {
            let hash = ObjectIdentifier(type(of: s.item)).hashValue ^ "\(s.item)".hashValue
            if seen.insert(hash).inserted {
                result.append(s.item)
            }
        }
        return result
    }

    // MARK: - Scoring

    private static func matchScore(query: String, target: String, maxDistance: Int) -> Int {
        if target.hasPrefix(query) { return 0 }
        if target.contains(query) { return 1 }

        let queryTokens = query.split(separator: " ").map(String.init)
        let nameTokens = target.split(separator: " ").map(String.init)

        if queryTokens.count > 1 {
            let allMatch = queryTokens.allSatisfy { qt in
                nameTokens.contains { nt in nt.hasPrefix(qt) }
            }
            if allMatch { return 2 }
        }

        if queryTokens.count == 1 {
            let bestDist = nameTokens.map { nt in
                levenshteinPrefix(source: query, target: nt)
            }.min() ?? Int.max
            if bestDist <= maxDistance { return 3 + bestDist }
        } else {
            let allFuzzy = queryTokens.allSatisfy { qt in
                nameTokens.contains { nt in
                    nt.hasPrefix(qt) || levenshtein(qt, String(nt.prefix(qt.count + maxDistance))) <= maxDistance
                }
            }
            if allFuzzy { return 4 }
        }

        return Int.max
    }

    // MARK: - Levenshtein Distance

    /// Standard Levenshtein distance between two strings.
    static func levenshtein(_ s: String, _ t: String) -> Int {
        let sArr = Array(s)
        let tArr = Array(t)
        let m = sArr.count
        let n = tArr.count

        if m == 0 { return n }
        if n == 0 { return m }

        var prev = Array(0...n)
        var curr = Array(repeating: 0, count: n + 1)

        for i in 1...m {
            curr[0] = i
            for j in 1...n {
                let cost = sArr[i - 1] == tArr[j - 1] ? 0 : 1
                curr[j] = min(
                    prev[j] + 1,       // deletion
                    curr[j - 1] + 1,    // insertion
                    prev[j - 1] + cost  // substitution
                )
            }
            prev = curr
        }
        return prev[n]
    }

    /// Prefix-aware Levenshtein: measures how well `source` matches the beginning of `target`.
    /// This is more lenient for short queries against long words.
    private static func levenshteinPrefix(source: String, target: String) -> Int {
        // If the query is shorter, compare against a prefix of the target
        let targetPrefix = String(target.prefix(source.count + 2))
        return levenshtein(source, targetPrefix)
    }
}

// MARK: - Array sorting helper
extension Array {
    func sorted(where areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        return self.sorted(by: areInIncreasingOrder)
    }
}
