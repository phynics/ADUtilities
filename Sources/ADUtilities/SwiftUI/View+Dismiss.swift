import SwiftUI

public struct DismissWrapper<Content>: View where Content: View {
    @Environment(\.presentationMode) var presentationMode
    public let content: Content

    public var body: some View {
        content.toolbar {
#if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("edit_done") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
#else
            ToolbarItem(placement: .automatic) {
                Button("edit_done") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
#endif
        }
    }
}

extension View {
    public func dismissWithNavigation() -> some View {
        NavigationStack {
            DismissWrapper(content: self)
        }
    }
}
