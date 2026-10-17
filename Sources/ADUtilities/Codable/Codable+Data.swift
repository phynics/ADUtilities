import Foundation

extension JSONEncoder {
    /// An encoder with sorted keys, so the same value always encodes to the same bytes.
    public static var sortedKeys: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }
}

extension Encodable {
    /// The value as JSON. The default encoder sorts keys, so output is stable.
    public func encodeToData(using encoder: JSONEncoder = .sortedKeys) throws -> Data {
        try encoder.encode(self)
    }
}

extension Decodable {
    /// Decodes a value of this type from JSON.
    public static func decodeFromData(_ data: Data, using decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        try decoder.decode(Self.self, from: data)
    }
}
