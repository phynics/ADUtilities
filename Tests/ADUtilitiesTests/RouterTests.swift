#if canImport(SwiftUI)
import Testing

@testable import ADUtilities

@MainActor
struct RouterTests {
    @Test func push_and_pop() {
        let router = Router<String>()
        router.push(1)
        router.push("two")
        #expect(router.depth == 2)
        router.pop()
        #expect(router.depth == 1)
        router.pop(5)
        #expect(router.depth == 0)
    }

    @Test func navigate_replacesPath() {
        let router = Router<String>()
        router.push(1)
        router.navigate(to: [1, 2, 3])
        #expect(router.depth == 3)
        router.popToRoot()
        #expect(router.depth == 0)
    }

    @Test func present_stacksPresentations() {
        let router = Router<String>()
        router.present("a")
        router.present("b", style: .popover)
        #expect(router.presentations.map(\.item) == ["a", "b"])
        #expect(router.presented?.style == .popover)
        router.dismissTop()
        #expect(router.presented?.item == "a")
    }

    @Test func dismiss_removesPresentationAndThoseAbove() {
        let router = Router<String>()
        let first = router.present("a")
        router.present("b")
        router.present("c")
        router.dismiss(first.id)
        #expect(router.presentations.isEmpty)
    }

    @Test func dismiss_unknownID_doesNothing() {
        let router = Router<String>()
        router.present("a")
        router.dismiss(UUID())
        #expect(router.presentations.count == 1)
    }

    @Test func presentAction_forwardsAcceptedValues() {
        let router = Router<String>()
        let present = router.presentAction { $0.base as? String }
        present("x", style: .popover)
        #expect(router.presented?.item == "x")
        #expect(router.presented?.style == .popover)
    }
}
#endif
