import Foundation

extension String {
    /// A new random UUID's string, for IDs and placeholders.
    public static var uuidString: String {
        UUID().uuidString
    }
}
