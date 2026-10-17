extension String {
    /// The words ``titleCased(keepingLowercase:)`` keeps lower case by default.
    public static let defaultTitleLowercaseWords: Set<String> = ["a", "an", "and", "in", "of", "the", "to"]

    /// The string in Title Case, using ``defaultTitleLowercaseWords``.
    ///
    /// "hand of the apprentice" → "Hand of the Apprentice", "half-elf" → "Half-Elf".
    public var displayTitle: String {
        titleCased()
    }

    /// The string in Title Case: each word starts with a capital, except the words in
    /// `lowercaseWords` unless they start the string or a parenthetical.
    ///
    /// Hyphenated parts and the letter after a one-letter prefix and an apostrophe (O'Connor) are
    /// capitalised. Everything else is left as written, so "DC" and "+1" are unchanged.
    ///
    /// "animal companion (ranger)" → "Animal Companion (Ranger)".
    public func titleCased(keepingLowercase lowercaseWords: Set<String> = String.defaultTitleLowercaseWords) -> String {
        split(separator: " ", omittingEmptySubsequences: false).enumerated().map { index, token in
            let opening = token.prefix { $0 == "(" }
            let word = token.dropFirst(opening.count)
            let startsGroup = index == 0 || !opening.isEmpty
            if !startsGroup, lowercaseWords.contains(word.lowercased()) {
                return String(token)
            }
            let cased = word.split(separator: "-", omittingEmptySubsequences: false)
                .map(Self.capitalizingStart)
                .joined(separator: "-")
            return String(opening) + cased
        }.joined(separator: " ")
    }

    private static func capitalizingStart(of part: Substring) -> String {
        var tail = String(part.dropFirst())
        // O'Connor: a one-letter prefix, an apostrophe, then a name.
        if let apostrophe = tail.first, apostrophe == "'" || apostrophe == "\u{2019}", tail.count > 1 {
            tail = String(apostrophe) + tail.dropFirst().prefix(1).uppercased() + tail.dropFirst(2)
        }
        return part.prefix(1).uppercased() + tail
    }
}
