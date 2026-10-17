#if canImport(SwiftUI)
import Observation
import SwiftUI

/// One window's navigation: a path of pushed routes and a stack of presentations, each dismissed
/// on its own. The path holds routes of any `Hashable` type, so one stack can mix route types.
///
/// Everything is a value, so what is shown can be restored, linked to and tested without
/// rendering. The app shell creates the `NavigationStack` (bound to ``path``) and applies
/// ``SwiftUI/View/presentations(_:providesChrome:content:)``; views push routes and present
/// values on the router.
@MainActor @Observable
public final class Router<Item: Hashable> {
    /// How a presentation appears. A popover adapts to a sheet where there's no room.
    public enum Style: Hashable, Sendable {
        case sheet
        case popover
    }

    /// One presented value.
    public struct Presentation: Identifiable, Hashable {
        public let id: UUID
        public let style: Style
        public let item: Item

        public init(id: UUID = UUID(), style: Style = .sheet, item: Item) {
            self.id = id
            self.style = style
            self.item = item
        }
    }

    /// The pushed routes, bottom first.
    public var path = NavigationPath()
    /// What is presented, bottom first: a popover can open over a sheet.
    public private(set) var presentations: [Presentation] = []

    public init() {}

    // MARK: Pushing

    /// How many routes are pushed.
    public var depth: Int { path.count }

    public func push<Route: Hashable>(_ route: Route) { path.append(route) }

    /// Pushes a route that can be saved: a path made only of these has a `codable` form.
    public func push<Route: Hashable & Codable>(_ route: Route) { path.append(route) }

    /// Replaces the path, as opening a link does.
    public func navigate<Route: Hashable>(to routes: [Route]) {
        path = NavigationPath(routes)
    }

    public func navigate<Route: Hashable & Codable>(to routes: [Route]) {
        path = NavigationPath(routes)
    }

    /// Removes the last `count` routes (or all of them, if fewer are pushed).
    public func pop(_ count: Int = 1) { path.removeLast(min(count, path.count)) }

    public func popToRoot() { path = NavigationPath() }

    // MARK: Presenting

    /// Presents `item` over everything shown so far, and returns the presentation.
    @discardableResult
    public func present(_ item: Item, style: Style = .sheet) -> Presentation {
        let presentation = Presentation(style: style, item: item)
        presentations.append(presentation)
        return presentation
    }

    /// Dismisses the topmost presentation.
    public func dismissTop() { _ = presentations.popLast() }

    /// Dismisses a presentation and everything presented over it. Dismissing one that is already
    /// gone does nothing.
    public func dismiss(_ id: Presentation.ID) {
        guard let index = presentations.firstIndex(where: { $0.id == id }) else { return }
        presentations.removeSubrange(index...)
    }

    public func dismissAll() { presentations.removeAll() }

    /// The topmost presentation, if any.
    public var presented: Presentation? { presentations.last }
}

extension View {
    /// Renders the router's presentations: the first as a sheet or popover over this view, the
    /// next over that, and so on. Each is wrapped in ``presentationChrome(doneTitle:)`` so it has
    /// its own navigation stack and a Done button, and dismisses on its own.
    ///
    /// - Parameter providesChrome: whether an item brings its own navigation stack and
    ///   controls (an editor with Cancel and Save), so the router doesn't wrap it.
    @MainActor
    public func presentations<Item: Hashable, Body: View>(
        _ router: Router<Item>,
        providesChrome: @escaping (Item) -> Bool = { _ in false },
        @ViewBuilder content: @escaping (Item) -> Body
    ) -> some View {
        modifier(PresentationLevel(router: router, level: 0, providesChrome: providesChrome, content: content))
    }

    /// The chrome of a presented screen: its own navigation stack, and a Done button that
    /// dismisses it. Pass `nil` to leave out the button.
    @MainActor
    public func presentationChrome(doneTitle: LocalizedStringKey? = "Done") -> some View {
        modifier(PresentationChrome(doneTitle: doneTitle))
    }
}

/// A navigation stack for a presented screen or a preview.
public struct PresentationStack<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        NavigationStack { content }
    }
}

private struct PresentationChrome: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    let doneTitle: LocalizedStringKey?

    func body(content: Content) -> some View {
        PresentationStack {
            content
                .toolbar {
                    if let doneTitle {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(doneTitle) { dismiss() }
                        }
                    }
                }
        }
    }
}

private struct PresentationLevel<Item: Hashable, Body: View>: ViewModifier {
    let router: Router<Item>
    let level: Int
    let providesChrome: (Item) -> Bool
    let content: (Item) -> Body

    private var current: Router<Item>.Presentation? {
        router.presentations[safely: level]
    }

    private func binding(_ style: Router<Item>.Style) -> Binding<Router<Item>.Presentation?> {
        Binding(
            get: { current?.style == style ? current : nil },
            set: { newValue in
                if newValue == nil, let current { router.dismiss(current.id) }
            }
        )
    }

    func body(content host: Content) -> some View {
        host
            .sheet(item: binding(.sheet)) { presentation in
                presented(presentation)
            }
            .popover(item: binding(.popover)) { presentation in
                presented(presentation)
            }
    }

    private func presented(_ presentation: Router<Item>.Presentation) -> some View {
        chromed(presentation.item)
            .modifier(PresentationLevel(router: router, level: level + 1, providesChrome: providesChrome, content: content))
    }

    @ViewBuilder
    private func chromed(_ item: Item) -> some View {
        if providesChrome(item) {
            content(item)
        } else {
            content(item).presentationChrome()
        }
    }
}
#endif
