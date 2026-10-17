import Foundation

extension Error {
    /// A description for logs and diagnostics: the `errorDescription` of a `LocalizedError`,
    /// otherwise `String(describing:)`, which keeps the case name and associated values that
    /// `localizedDescription` hides.
    public var diagnosticDescription: String {
        if let localizedError = self as? any LocalizedError,
           let errorDescription = localizedError.errorDescription {
            return errorDescription
        }
        return String(describing: self)
    }
}
