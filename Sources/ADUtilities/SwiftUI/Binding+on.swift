import SwiftUI

extension Binding {
    static func on<Root>(object root: Root, member: ReferenceWritableKeyPath<Root, Value>) -> Binding<Value> {
        return .init(get: {
            root[keyPath: member]
        }, set: {
            root[keyPath: member] = $0
        })
    }

    func arrayElement<ArrayElement>(at index: Array<ArrayElement>.Index) -> Binding<ArrayElement> where [ArrayElement] == Value {
        return .init(get: {
            self.wrappedValue[index]
        }, set: {
            self.wrappedValue[index] = $0
        })
    }

    func dictionaryElement<Key: Hashable, DictValue>(at index: Key) -> Binding<DictValue?> where [Key: DictValue] == Value {
        return .init(get: {
            self.wrappedValue[index]
        }, set: {
            self.wrappedValue[index] = $0
        })
    }

    public func `default`<OriginalValue>(to defaultValue: OriginalValue) -> Binding<OriginalValue> where Value == Optional<OriginalValue> {
        return .init(get: {
            self.wrappedValue ?? defaultValue
        }, set: {
            self.wrappedValue = $0
        })
    }
}
