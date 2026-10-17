#if canImport(SwiftUI)
import SwiftUI

/// An error that can be shown as an alert: a title, a message, and optionally an action that
/// recovers from it.
public protocol AlertPresentableError {
    /// An action the alert offers besides OK.
    associatedtype RecoveryAction

    var alertTitle: String { get }
    var alertMessage: String { get }
    var recoveryAction: RecoveryAction? { get }
    /// The button title for `action`.
    func label(for action: RecoveryAction) -> String
}

extension AlertPresentableError where RecoveryAction == Never {
    public var recoveryAction: Never? { nil }
    public func label(for action: Never) -> String { switch action {} }
}

extension View {
    /// Shows `error` as an alert while it isn't `nil`. When the error has a recovery action the
    /// alert offers it and `perform` runs it; any button clears the error.
    public func errorAlert<E: AlertPresentableError>(
        _ error: Binding<E?>,
        dismissTitle: LocalizedStringKey = "OK",
        perform: @escaping (E.RecoveryAction) -> Void = { _ in }
    ) -> some View {
        alert(
            error.wrappedValue?.alertTitle ?? "",
            isPresented: Binding(
                get: { error.wrappedValue != nil },
                set: { isPresented in
                    if !isPresented { error.wrappedValue = nil }
                }
            ),
            presenting: error.wrappedValue
        ) { presented in
            if let recovery = presented.recoveryAction {
                Button(presented.label(for: recovery)) { perform(recovery) }
            }
            Button(dismissTitle, role: .cancel) {}
        } message: { presented in
            Text(presented.alertMessage)
        }
    }
}
#endif
