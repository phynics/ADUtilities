#if canImport(SwiftUI) && (canImport(UIKit) || canImport(AppKit))
import SwiftUI
#if canImport(os)
import os
#endif

extension String {
    /// The string parsed as HTML, styled with the body font and primary color. Empty when the
    /// string is empty or isn't valid HTML (the failure is logged).
    ///
    /// The system HTML importer runs on the main thread, so this is main-actor isolated.
    @MainActor
    public var formattedAsHtml: AttributedString {
        formattedAsHtml(font: .body, color: .primary)
    }

    /// The string parsed as HTML, styled with `font` and `color`. Empty when the string is empty
    /// or isn't valid HTML (the failure is logged).
    @MainActor
    public func formattedAsHtml(font: Font, color: Color) -> AttributedString {
        guard !isEmpty else { return AttributedString() }
        do {
            let imported = try NSAttributedString(
                data: Data(utf8),
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue,
                ],
                documentAttributes: nil
            )
            var attributed = AttributedString(imported)
            attributed.foregroundColor = color
            attributed.font = font
            return attributed
        } catch {
            #if canImport(os)
            Logger(subsystem: "com.adutilities", category: "String")
                .error("HTML didn't parse: \(error.localizedDescription, privacy: .public)")
            #endif
            return AttributedString()
        }
    }
}
#endif
