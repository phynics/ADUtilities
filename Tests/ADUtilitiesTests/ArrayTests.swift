import Testing

@testable import ADUtilities

struct ArrayTests {
    @Test func testAssumeSingle_withSingleElement() {
        let array = [1]
        #expect(array.assumeSingle == 1)
    }

    @Test func testAssumeSingle_withMultipleElements() {
        let array = [1, 2, 3]
        // This should log a fault, but we can only assert the return value here.
        // Verifying logs usually requires a more complex setup or a custom log handler mock.
        #expect(array.assumeSingle == 1)
    }

    @Test func testAssumeSingle_withEmptyArray() {
        let array: [Int] = []
        #expect(array.assumeSingle == nil)
    }
}
