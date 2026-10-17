#if canImport(SwiftUI)
import SwiftUI

/// How a shared view asks the window to present something. A view in a framework module can't
/// name the app's ``Router``, whose item type the app chooses, so the app shell puts this in the
/// environment and views present values of their own types. The shell turns the values it knows
/// into router items (see ``Router/presentAction(_:)``).
public struct PresentAction {
    private let handler: @MainActor (AnyHashable, Style) -> Void

    /// How a presented value appears.
    public enum Style: Hashable, Sendable {
        case sheet
        case popover
    }

    public init(_ handler: @escaping @MainActor (AnyHashable, Style) -> Void) {
        self.handler = handler
    }

    /// Presents `value` as a sheet, or as a popover that adapts to a sheet where there's no room.
    @MainActor
    public func callAsFunction<Value: Hashable>(_ value: Value, style: Style = .sheet) {
        handler(AnyHashable(value), style)
    }

    /// Does nothing: the default where no shell presents (a preview). Debug builds say so.
    ///
    /// `nonisolated(unsafe)`: `PresentAction` isn't `Sendable`; this is a constant that never changes.
    nonisolated(unsafe) public static let unavailable = PresentAction { value, _ in
        assertionFailure("Nothing presents \(value): the window's shell didn't set the present action.")
    }
}

extension EnvironmentValues {
    @Entry public var present: PresentAction = .unavailable
}

extension Router {
    /// A present action that forwards the values `transform` accepts to this router. A value it
    /// returns `nil` for isn't shown (and asserts in debug builds).
    public func presentAction(_ transform: @escaping (AnyHashable) -> Item?) -> PresentAction {
        PresentAction { [weak self] value, style in
            guard let item = transform(value) else {
                assertionFailure("This window can't present \(value).")
                return
            }
            self?.present(item, style: style == .popover ? .popover : .sheet)
        }
    }
}
#endif
