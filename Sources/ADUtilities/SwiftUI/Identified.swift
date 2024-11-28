import Foundation

public struct Identified<T>: Identifiable, RawRepresentable {
    public let id: UUID
    public var rawValue: T

    public init(id: UUID, rawValue: T) {
        self.id = id
        self.rawValue = rawValue
    }

    public init(rawValue: T) {
        self.id = UUID()
        self.rawValue = rawValue
    }
}

extension Identified: Decodable where T: Decodable {}
extension Identified: Encodable where T: Encodable {}
extension Identified: Equatable where T: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
        && lhs.rawValue == rhs.rawValue
    }
}
extension Identified: Hashable where T: Hashable {}
