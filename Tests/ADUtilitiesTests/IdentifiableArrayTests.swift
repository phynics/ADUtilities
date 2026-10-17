import Testing

@testable import ADUtilities

struct IdentifiableArrayTests {
    struct Item: Identifiable, Equatable {
        let id: Int
        var value: String
    }

    @Test func safelySetter_replacesAtValidIndex() {
        var array = [1, 2, 3]
        array[safely: 1] = 20
        #expect(array == [1, 20, 3])
    }

    @Test func safelySetter_ignoresInvalidIndexAndNil() {
        var array = [1, 2, 3]
        array[safely: 3] = 4
        array[safely: -1] = 0
        array[safely: 0] = nil
        #expect(array == [1, 2, 3])
    }

    @Test func replaceIfExists_replacesMatchingElement() {
        var items = [Item(id: 1, value: "A"), Item(id: 2, value: "B")]
        items.replaceIfExists(Item(id: 2, value: "Updated"))
        #expect(items == [Item(id: 1, value: "A"), Item(id: 2, value: "Updated")])
    }

    @Test func replaceIfExists_doesNotAppendMissingElement() {
        var items = [Item(id: 1, value: "A")]
        items.replaceIfExists(Item(id: 2, value: "B"))
        #expect(items == [Item(id: 1, value: "A")])
    }

    @Test func firstIndexOfIdentifiable_matchesByID() {
        let items = [Item(id: 1, value: "A"), Item(id: 2, value: "B")]
        #expect(items.firstIndex(ofIdentifiable: Item(id: 2, value: "other")) == 1)
        #expect(items.firstIndex(ofIdentifiable: Item(id: 3, value: "C")) == nil)
    }

    @Test func containsIdentifiable_matchesByID() {
        let items = [Item(id: 1, value: "A")]
        #expect(items.contains(identifiable: Item(id: 1, value: "other")))
        #expect(!items.contains(identifiable: Item(id: 2, value: "A")))
    }
}
