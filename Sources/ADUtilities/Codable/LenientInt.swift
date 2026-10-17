import Foundation

/// An integer that decodes from either a JSON number or a numeric string (`3` or `"3"`).
///
/// Always encodes as a number.
public struct LenientInt: RawRepresentable, Codable, Hashable, Sendable {
    public var rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public init(_ value: Int) {
        self.rawValue = value
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Int.self) { // probes the number shape; the string decode reports the error
            rawValue = value
            return
        }
        let string = try container.decode(String.self)
        guard let value = Int(string.trimmingCharacters(in: .whitespaces)) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot convert \"\(string)\" to Int."
            )
        }
        rawValue = value
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension LenientInt: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.rawValue = value
    }
}

extension LenientInt: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
