import Foundation

extension UUID {
    /// Whether this ID sorts before `other` by its text (`uuidString`), without making the text.
    ///
    /// `uuidString` is upper-case hex in fixed positions, so its character order is the byte
    /// order of the ID, and comparing bytes gives the same answer.
    public func isOrderedBeforeAsText(_ other: UUID) -> Bool {
        textOrderKey < other.textOrderKey
    }

    /// A key whose order is the order of ``isOrderedBeforeAsText(_:)``, for sorting many IDs
    /// without walking the bytes in every comparison.
    public var textOrderKey: (UInt64, UInt64) {
        let b = uuid
        let high = UInt64(b.0) << 56 | UInt64(b.1) << 48 | UInt64(b.2) << 40 | UInt64(b.3) << 32
            | UInt64(b.4) << 24 | UInt64(b.5) << 16 | UInt64(b.6) << 8 | UInt64(b.7)
        let low = UInt64(b.8) << 56 | UInt64(b.9) << 48 | UInt64(b.10) << 40 | UInt64(b.11) << 32
            | UInt64(b.12) << 24 | UInt64(b.13) << 16 | UInt64(b.14) << 8 | UInt64(b.15)
        return (high, low)
    }
}
