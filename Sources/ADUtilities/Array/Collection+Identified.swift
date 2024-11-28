public extension Collection where Element: Identifiable {
    subscript(identity identity: Element.ID) -> Element? {
        get {
            guard let index = firstIndex(where: { $0.id == identity }) else { return nil }
            return self[index]
        }
    }
}

public extension Collection where Element: Equatable {
    func contains(equatableElement: Element) -> Bool {
        if let index = firstIndex(where: { $0 == equatableElement }) {
            return true
        } else {
            return false
        }
    }
}

public extension Array where Element: Identifiable {
    subscript(identity identity: Element.ID) -> Element? {
        get {
            guard let index = firstIndex(where: { $0.id == identity }) else { return nil }
            return self[index]
        }
        set {
            guard let newValue else {
                return
            }
            guard let index = firstIndex(where: { $0.id == identity }) else {
                self.append(newValue)
                return
            }
            self[identity: identity] = newValue
        }
    }
}

public extension Array where Element: Equatable {
    mutating func remove(equatableElement: Element) {
        if let index = firstIndex(where: { $0 == equatableElement }) {
            self.remove(at: index)
        }
    }
}
