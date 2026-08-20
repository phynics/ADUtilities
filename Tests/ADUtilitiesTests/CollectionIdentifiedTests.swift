import Testing

@testable import ADUtilities

struct CollectionIdentifiedTests {

    struct Item: Identifiable, Equatable {
        let id: Int
        let value: String
    }

    // MARK: - Collection Subscript (Identity)

    @Test func testCollectionSubscriptIdentity_withExistingID_returnsElement() {
        let items = [Item(id: 1, value: "A"), Item(id: 2, value: "B")]
        #expect(items[identity: 1]?.value == "A")
    }

    @Test func testCollectionSubscriptIdentity_withNonExistingID_returnsNil() {
        let items = [Item(id: 1, value: "A")]
        #expect(items[identity: 999] == nil)
    }

    // MARK: - Collection Contains Equatable

    @Test func testCollectionContains_withExistingItem_returnsTrue() {
        let items = [Item(id: 1, value: "A"), Item(id: 2, value: "B")]
        #expect(items.contains(equatableElement: Item(id: 1, value: "A")))
    }

    @Test func testCollectionContains_withNonExistingItem_returnsFalse() {
        let items = [Item(id: 1, value: "A")]
        #expect(!items.contains(equatableElement: Item(id: 1, value: "B")))
    }

    // MARK: - Array Subscript (Identity) Get/Set

    @Test func testArraySubscriptIdentity_get_returnsElement() {
        let items = [Item(id: 1, value: "A")]
        #expect(items[identity: 1]?.value == "A")
    }

    @Test func testArraySubscriptIdentity_set_replacesElement() {
        var items = [Item(id: 1, value: "A"), Item(id: 2, value: "B")]
        items[identity: 1] = Item(id: 1, value: "NewA")

        #expect(items.count == 2)
        #expect(items[0].value == "NewA")
    }

    @Test func testArraySubscriptIdentity_set_appendsNewElement() {
        var items = [Item(id: 1, value: "A")]
        items[identity: 2] = Item(id: 2, value: "B")

        #expect(items.count == 2)
        #expect(items[1].value == "B")
        #expect(items[1].id == 2)
    }

    @Test func testArraySubscriptIdentity_setNil_doesNothing() {
        var items = [Item(id: 1, value: "A")]
        // The implementation guard let newValue else { return } prevents deletion or update if nil is assigned
        // Wait, the subscript doesn't have an optional setter value?
        // Let's check the code: subscript(identity identity: Element.ID) -> Element?
        // It returns optional, so newValue is Element?.
        // The code says: guard let newValue else { return }
        // So assigning nil does nothing. It doesn't remove the element.

        items[identity: 1] = nil
        #expect(items.count == 1)
        #expect(items[0].value == "A")
    }

    // MARK: - Array Remove Equatable

    @Test func testArrayRemoveEquatable_withExistingItem_removesItem() {
        var items = [Item(id: 1, value: "A"), Item(id: 2, value: "B")]
        items.remove(equatableElement: Item(id: 1, value: "A"))
        #expect(items.count == 1)
        #expect(items[0].value == "B")
    }

    @Test func testArrayRemoveEquatable_withNonExistingItem_doesNothing() {
        var items = [Item(id: 1, value: "A")]
        items.remove(equatableElement: Item(id: 2, value: "B"))
        #expect(items.count == 1)
    }
}
