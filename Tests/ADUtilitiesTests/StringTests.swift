import Testing

@testable import ADUtilities

struct StringTests {

    @Test func testLoremIpsum_returnsNonEmptyString() {
        let text = String.loremIpsum
        #expect(!text.isEmpty)
        #expect(text.contains("Lorem ipsum"))
    }
}
