extension Array {
    public subscript(safely index: Index) -> Element? {
        guard endIndex >= index else { return nil }
        return self[index]
    }
}

extension Array where Element: Identifiable {
    public mutating func replaceOrInsert(_ element: Element) {
        let index = self.firstIndex { $0.id == element.id }

        if let index {
            self[index] = element
        } else {
            self.append(element)
        }
    }
}
