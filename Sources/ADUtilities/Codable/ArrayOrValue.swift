/// A list that decodes from either a JSON array or a single value.
///
/// Encodes a single element as a bare value and any other count as an array, so a value
/// round-trips in the shape it was written.
public struct ArrayOrValue<Value: Codable>: Codable {
    public private(set) var values: [Value]

    public init(_ values: [Value]) {
        self.values = values
    }

    public init(_ value: Value) {
        self.values = [value]
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let array = try? container.decode([Value].self) { // probes the array shape; the single-value decode reports the error
            self.values = array
        } else {
            self.values = [try container.decode(Value.self)]
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        if values.count == 1, let value = values.first {
            try container.encode(value)
        } else {
            try container.encode(values)
        }
    }
}

extension ArrayOrValue: Equatable where Value: Equatable {}
extension ArrayOrValue: Hashable where Value: Hashable {}
extension ArrayOrValue: Sendable where Value: Sendable {}

extension ArrayOrValue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Value...) {
        self.values = elements
    }
}
