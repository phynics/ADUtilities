/// A value stored under a `value` key: `{ "value": ... }`.
public struct ValueWrapped<Value> {
    public var value: Value

    public init(_ value: Value) {
        self.value = value
    }
}

extension ValueWrapped: Encodable where Value: Encodable {}
extension ValueWrapped: Decodable where Value: Decodable {}
extension ValueWrapped: Equatable where Value: Equatable {}
extension ValueWrapped: Hashable where Value: Hashable {}
extension ValueWrapped: Sendable where Value: Sendable {}
