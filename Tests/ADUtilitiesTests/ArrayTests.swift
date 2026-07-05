import XCTest

@testable import ADUtilities

final class ArrayTests: XCTestCase {
    func testAssumeSingle_withSingleElement() {
        let array = [1]
        XCTAssertEqual(array.assumeSingle, 1)
    }

    func testAssumeSingle_withMultipleElements() {
        let array = [1, 2, 3]
        // This should log a fault, but we can only assert the return value here.
        // Verifying logs usually requires a more complex setup or a custom log handler mock.
        XCTAssertEqual(array.assumeSingle, 1)
    }

    func testAssumeSingle_withEmptyArray() {
        let array: [Int] = []
        XCTAssertNil(array.assumeSingle)
    }
}
