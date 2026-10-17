#if canImport(SwiftUI)
import SwiftUI

extension View {
    /// Sizes a sheet as a form on macOS, where sheets otherwise fit their content tightly.
    /// Does nothing on other platforms.
    @ViewBuilder
    public func macosSheet() -> some View {
        #if os(macOS)
        presentationSizing(.form)
        #else
        self
        #endif
    }
}
#endif
