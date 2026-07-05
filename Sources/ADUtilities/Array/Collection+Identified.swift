extension Collection where Element: Identifiable {
    public subscript(identity identity: Element.ID) -> Element? {
        get {
            guard let index = firstIndex(where: { $0.id == identity }) else { return nil }
            return self[index]
        }
    }
}

extension Collection where Element: Equatable {
    public func contains(equatableElement: Element) -> Bool {
        if firstIndex(where: { $0 == equatableElement }) != nil {
            return true
        } else {
            return false
        }
    }
}

extension Array where Element: Identifiable {
    public subscript(identity identity: Element.ID) -> Element? {
        get {
            guard let index = firstIndex(where: { $0.id == identity }) else { return nil }
            return self[index]
        }
        set {
            guard let newValue else {
                return
            }
            if let index = firstIndex(where: { $0.id == identity }) {
                self[index] = newValue
            } else {
                self.append(newValue)
            }
        }
    }
}

extension Array where Element: Equatable {
    public mutating func remove(equatableElement: Element) {
        if let index = firstIndex(where: { $0 == equatableElement }) {
            self.remove(at: index)
        }
    }
}
