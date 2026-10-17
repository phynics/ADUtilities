extension String {
    /// `divine-font` → `divineFont`. A string without hyphens is returned unchanged.
    public var kebabToCamelCase: String {
        let parts = split(separator: "-")
        guard parts.count > 1 else { return self }
        return String(parts[0]) + parts.dropFirst().map { $0.prefix(1).uppercased() + $0.dropFirst() }.joined()
    }
}
