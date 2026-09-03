import Foundation
#if canImport(os)
import os
#endif

extension Collection {
    /// Returns the first element if the collection contains exactly one element.
    /// If the collection contains more than one element, it returns the first element but logs a fault.
    /// If failure is critical, validate the collection count before using this property.
    public var assumeSingle: Element? {
        if count > 1 {
#if canImport(os)
            let logger = Logger(subsystem: "com.adutilities", category: "Array")
            logger.fault("Expected single element but found \(count): \(String(describing: self))")
#else
            assertionFailure("Expected single element but found \(count): \(String(describing: self))")
#endif
        }
        return first
    }
}
