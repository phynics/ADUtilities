import SwiftUI
import Testing

@testable import ADUtilities

struct LocalizedStringKeyTests {
    @Test func testStringKey_withPlainKeyReturnsKey() {
        #expect(LocalizedStringKey("hello").stringKey == "hello")
    }

    @Test func testStringKey_withInterpolatedKeyReturnsFormatKey() {
        #expect(LocalizedStringKey("count \(1)").stringKey == "count %lld")
    }
}
