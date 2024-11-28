import SwiftUI

public struct DismissButton: View {
    @Environment(\.presentationMode) var presentationMode

    public init() {}

    public var body: some View {
        Button("edit_done") {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
