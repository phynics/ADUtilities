import SwiftUI
import XCTest

@testable import ADUtilities

final class LocalizedStringKeyTests: XCTestCase {
    func testStringKey_withPlainKeyReturnsKey() {
        XCTAssertEqual(LocalizedStringKey("hello").stringKey, "hello")
    }

    func testStringKey_withInterpolatedKeyReturnsFormatKey() {
        XCTAssertEqual(LocalizedStringKey("count \(1)").stringKey, "count %lld")
    }
}
