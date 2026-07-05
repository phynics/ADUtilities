import XCTest

@testable import ADUtilities

final class ArrayExtensionTests: XCTestCase {

    // MARK: - Safely Subscript

    func testSafelySubscript_withValidIndex_returnsElement() {
        let array = [1, 2, 3]
        XCTAssertEqual(array[safely: 0], 1)
        XCTAssertEqual(array[safely: 2], 3)
    }

    func testSafelySubscript_withInvalidIndex_returnsNil() {
        let array = [1, 2, 3]
        XCTAssertNil(array[safely: -1])
        XCTAssertNil(array[safely: 3])
        XCTAssertNil(array[safely: 100])
    }

    // MARK: - Replace or Insert

    struct Item: Identifiable, Equatable {
        let id: Int
        var value: String
    }

    func testReplaceOrInsert_withExistingElement_replacesElement() {
        var items = [Item(id: 1, value: "A"), Item(id: 2, value: "B")]
        let newItem = Item(id: 1, value: "Updated")

        items.replaceOrInsert(newItem)

        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].value, "Updated")
        XCTAssertEqual(items[1].value, "B")
    }

    func testReplaceOrInsert_withNewElement_appendsElement() {
        var items = [Item(id: 1, value: "A")]
        let newItem = Item(id: 2, value: "B")

        items.replaceOrInsert(newItem)

        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].value, "A")
        XCTAssertEqual(items[1].value, "B")
    }
}
