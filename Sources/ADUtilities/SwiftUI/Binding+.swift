import SwiftUI

extension Binding where Value: Equatable {
    public func `where`(valueIs: Value, defaultValue: Value) -> Binding<Bool> {
        return Binding<Bool> {
            return self.wrappedValue == valueIs
        } set: {
            if !$0 {
                self.wrappedValue = defaultValue
            }
        }

    }
}

extension Binding {
    public static func ??<Wrapped>(optional: Self, defaultValue: Wrapped) -> Binding<Wrapped> where Value == Wrapped? {
        .init {
            optional.wrappedValue ?? defaultValue
        } set: {
            optional.wrappedValue = $0
        }
    }

    public func forceUnwrap<Wrapped>() -> Binding<Wrapped> where Value == Wrapped? {
        .init {
            self.wrappedValue!
        } set: {
            self.wrappedValue = $0
        }
    }

    public var optional: Binding<Value?> {
        .init {
            Optional(self.wrappedValue)
        } set: {
            if let value = $0 {
                self.wrappedValue = value
            }
        }
    }

    public func map<TargetType>(_ keyPath: WritableKeyPath<Value, TargetType>) -> Binding<TargetType> {
        .init {
            wrappedValue[keyPath: keyPath]
        } set: {
            wrappedValue[keyPath: keyPath] = $0
        }
    }
}
