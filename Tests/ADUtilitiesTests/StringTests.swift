import XCTest

@testable import ADUtilities

final class StringTests: XCTestCase {

    func testLoremIpsum_returnsNonEmptyString() {
        let text = String.loremIpsum
        XCTAssertFalse(text.isEmpty)
        XCTAssertTrue(text.contains("Lorem ipsum"))
    }
}
