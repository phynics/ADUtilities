import Foundation

extension RawRepresentable where RawValue == String, Self: Codable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let rawValue = try container.decode(String.self)
        guard let value = Self(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot initialize \(Self.self) from invalid raw value \(rawValue)."
            )
        }
        self = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(rawValue)
    }
}
