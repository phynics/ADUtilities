import Testing

@testable import ADUtilities

struct ArrayExtensionTests {

    // MARK: - Safely Subscript

    @Test func testSafelySubscript_withValidIndex_returnsElement() {
        let array = [1, 2, 3]
        #expect(array[safely: 0] == 1)
        #expect(array[safely: 2] == 3)
    }

    @Test func testSafelySubscript_withInvalidIndex_returnsNil() {
        let array = [1, 2, 3]
        #expect(array[safely: -1] == nil)
        #expect(array[safely: 3] == nil)
        #expect(array[safely: 100] == nil)
    }

    // MARK: - Replace or Insert

    struct Item: Identifiable, Equatable {
        let id: Int
        var value: String
    }

    @Test func testReplaceOrInsert_withExistingElement_replacesElement() {
        var items = [Item(id: 1, value: "A"), Item(id: 2, value: "B")]
        let newItem = Item(id: 1, value: "Updated")

        items.replaceOrInsert(newItem)

        #expect(items.count == 2)
        #expect(items[0].value == "Updated")
        #expect(items[1].value == "B")
    }

    @Test func testReplaceOrInsert_withNewElement_appendsElement() {
        var items = [Item(id: 1, value: "A")]
        let newItem = Item(id: 2, value: "B")

        items.replaceOrInsert(newItem)

        #expect(items.count == 2)
        #expect(items[0].value == "A")
        #expect(items[1].value == "B")
    }
}
