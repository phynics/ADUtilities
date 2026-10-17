/// An optional of any wrapped type, for checking `nil` on a value only known as `Any` or a
/// generic `T` (`(value as? any AnyOptional)?.isNil == true`).
public protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}
