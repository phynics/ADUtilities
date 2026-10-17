extension Array {
    /// The element at `index`, or `nil` when the index is out of bounds.
    ///
    /// Setting a non-`nil` value replaces the element at a valid index. Setting `nil`, or setting
    /// at an out-of-bounds index, does nothing.
    public subscript(safely index: Index) -> Element? {
        get {
            guard indices.contains(index) else { return nil }
            return self[index]
        }
        set {
            guard indices.contains(index), let newValue else { return }
            self[index] = newValue
        }
    }
}

extension Array where Element: Identifiable {
    /// Replaces the element with the same `id`, or appends `element` when there is none.
    public mutating func replaceOrInsert(_ element: Element) {
        if let index = firstIndex(ofIdentifiable: element) {
            self[index] = element
        } else {
            append(element)
        }
    }

    /// Replaces the element with the same `id`; does nothing when there is none.
    public mutating func replaceIfExists(_ element: Element) {
        if let index = firstIndex(ofIdentifiable: element) {
            self[index] = element
        }
    }
}

extension Collection where Element: Identifiable {
    /// The index of the first element with the same `id` as `element`.
    public func firstIndex(ofIdentifiable element: Element) -> Index? {
        firstIndex { $0.id == element.id }
    }

    /// Whether the collection has an element with the same `id` as `element`.
    public func contains(identifiable element: Element) -> Bool {
        contains { $0.id == element.id }
    }
}
