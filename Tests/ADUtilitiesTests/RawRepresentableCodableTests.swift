import Foundation
import Testing

@testable import ADUtilities

struct RawRepresentableCodableTests {

    enum TestEnum: String, Codable {
        case case1 = "case1"
        case case2 = "case2"
    }

    // The extension applies to RawRepresentable where RawValue == String, Self: Codable.
    // However, Swift's default synthesis for Codable enums usually handles this.
    // The extension in ADUtilities seems to override this to encode/decode as an unkeyed container?
    // Let's check the source again.

    /*
    extension RawRepresentable where RawValue == String, Self: Codable {
        init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            let rawValue = try container.decode(String.self)
            do {
                self.init(rawValue: rawValue)!
            }
        }
    
        func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(rawValue)
        }
    }
    */

    // This looks like it forces the enum to be encoded as an array of one string `["case1"]` instead of just `"case1"`.
    // Let's verify this behavior.

    @Test func testEncode_encodesAsArray() throws {
        let value = TestEnum.case1
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        let jsonString = String(data: data, encoding: .utf8)

        #expect(jsonString == "[\"case1\"]")
    }

    @Test func testDecode_decodesFromArray() throws {
        let json = "[\"case2\"]"
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let value = try decoder.decode(TestEnum.self, from: data)

        #expect(value == .case2)
    }

    @Test func testDecode_decodesFromSingleString_fails() {
        let json = "\"case1\""
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()

        #expect(throws: (any Error).self) {
            try decoder.decode(TestEnum.self, from: data)
        }
    }

    @Test func testDecode_withUnknownRawValueThrows() {
        let json = "[\"case3\"]"
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()

        #expect(throws: (any Error).self) {
            try decoder.decode(TestEnum.self, from: data)
        }
    }
}
