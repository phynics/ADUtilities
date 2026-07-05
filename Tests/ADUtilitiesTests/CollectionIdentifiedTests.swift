import XCTest

@testable import ADUtilities

final class CollectionIdentifiedTests: XCTestCase {

    struct Item: Identifiable, Equatable {
        let id: Int
        let value: String
    }

    // MARK: - Collection Subscript (Identity)

    func testCollectionSubscriptIdentity_withExistingID_returnsElement() {
        let items = [Item(id: 1, value: "A"), Item(id: 2, value: "B")]
        XCTAssertEqual(items[identity: 1]?.value, "A")
    }

    func testCollectionSubscriptIdentity_withNonExistingID_returnsNil() {
        let items = [Item(id: 1, value: "A")]
        XCTAssertNil(items[identity: 999])
    }

    // MARK: - Collection Contains Equatable

    func testCollectionContains_withExistingItem_returnsTrue() {
        let items = [Item(id: 1, value: "A"), Item(id: 2, value: "B")]
        XCTAssertTrue(items.contains(equatableElement: Item(id: 1, value: "A")))
    }

    func testCollectionContains_withNonExistingItem_returnsFalse() {
        let items = [Item(id: 1, value: "A")]
        XCTAssertFalse(items.contains(equatableElement: Item(id: 1, value: "B")))
    }

    // MARK: - Array Subscript (Identity) Get/Set

    func testArraySubscriptIdentity_get_returnsElement() {
        let items = [Item(id: 1, value: "A")]
        XCTAssertEqual(items[identity: 1]?.value, "A")
    }

    func testArraySubscriptIdentity_set_replacesElement() {
        var items = [Item(id: 1, value: "A"), Item(id: 2, value: "B")]
        items[identity: 1] = Item(id: 1, value: "NewA")

        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].value, "NewA")
    }

    func testArraySubscriptIdentity_set_appendsNewElement() {
        var items = [Item(id: 1, value: "A")]
        items[identity: 2] = Item(id: 2, value: "B")

        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[1].value, "B")
        XCTAssertEqual(items[1].id, 2)
    }

    func testArraySubscriptIdentity_setNil_doesNothing() {
        var items = [Item(id: 1, value: "A")]
        // The implementation guard let newValue else { return } prevents deletion or update if nil is assigned
        // Wait, the subscript doesn't have an optional setter value?
        // Let's check the code: subscript(identity identity: Element.ID) -> Element?
        // It returns optional, so newValue is Element?.
        // The code says: guard let newValue else { return }
        // So assigning nil does nothing. It doesn't remove the element.

        items[identity: 1] = nil
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].value, "A")
    }

    // MARK: - Array Remove Equatable

    func testArrayRemoveEquatable_withExistingItem_removesItem() {
        var items = [Item(id: 1, value: "A"), Item(id: 2, value: "B")]
        items.remove(equatableElement: Item(id: 1, value: "A"))
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].value, "B")
    }

    func testArrayRemoveEquatable_withNonExistingItem_doesNothing() {
        var items = [Item(id: 1, value: "A")]
        items.remove(equatableElement: Item(id: 2, value: "B"))
        XCTAssertEqual(items.count, 1)
    }
}
