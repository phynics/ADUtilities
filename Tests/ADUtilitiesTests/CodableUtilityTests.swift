import Foundation
import Testing

@testable import ADUtilities

struct CodableUtilityTests {
    private func decode<T: Decodable>(_ type: T.Type, _ json: String) throws -> T {
        try JSONDecoder().decode(T.self, from: Data(json.utf8))
    }

    private func encode<T: Encodable>(_ value: T) throws -> String {
        String(decoding: try value.encodeToData(), as: UTF8.self)
    }

    // MARK: ArrayOrValue

    @Test func arrayOrValue_decodesArray() throws {
        #expect(try decode(ArrayOrValue<Int>.self, "[1,2]").values == [1, 2])
    }

    @Test func arrayOrValue_decodesSingleValue() throws {
        #expect(try decode(ArrayOrValue<Int>.self, "3").values == [3])
    }

    @Test func arrayOrValue_encodesInOriginalShape() throws {
        #expect(try encode(ArrayOrValue(3)) == "3")
        #expect(try encode(ArrayOrValue([1, 2])) == "[1,2]")
        #expect(try encode(ArrayOrValue<Int>([])) == "[]")
    }

    @Test func arrayOrValue_rejectsWrongType() {
        #expect(throws: DecodingError.self) { try decode(ArrayOrValue<Int>.self, "\"a\"") }
    }

    // MARK: JSONValue

    @Test func jsonValue_roundTripsEveryShape() throws {
        let json = #"{"a":[1,2.5,"s",true,null],"b":{"c":false}}"#
        let value = try decode(JSONValue.self, json)
        let expected: JSONValue = ["a": [1, 2.5, "s", true, nil], "b": ["c": false]]
        #expect(value == expected)
        #expect(try decode(JSONValue.self, try encode(value)) == expected)
    }

    @Test func jsonValue_accessors() {
        let value: JSONValue = ["n": 2, "list": ["x"]]
        #expect(value["n"]?.intValue == 2)
        #expect(value["n"]?.doubleValue == 2)
        #expect(value["list"]?[0]?.stringValue == "x")
        #expect(value["list"]?[5] == nil)
        #expect(value["missing"] == nil)
        #expect(JSONValue.null.isNull)
    }

    // MARK: LenientInt

    @Test func lenientInt_decodesNumberAndString() throws {
        #expect(try decode(LenientInt.self, "4").rawValue == 4)
        #expect(try decode(LenientInt.self, "\"5\"").rawValue == 5)
        #expect(try decode(LenientInt.self, "\" 6 \"").rawValue == 6)
    }

    @Test func lenientInt_rejectsNonNumericString() {
        #expect(throws: DecodingError.self) { try decode(LenientInt.self, "\"five\"") }
    }

    @Test func lenientInt_encodesAsNumber() throws {
        #expect(try encode(LenientInt(7)) == "7")
    }

    // MARK: ValueWrapped

    @Test func valueWrapped_usesValueKey() throws {
        #expect(try encode(ValueWrapped("x")) == #"{"value":"x"}"#)
        #expect(try decode(ValueWrapped<Int>.self, #"{"value":3}"#).value == 3)
    }

    // MARK: Codable+Data

    struct Pair: Codable, Equatable {
        var b: Int
        var a: Int
    }

    @Test func encodeToData_sortsKeys() throws {
        #expect(try encode(Pair(b: 1, a: 2)) == #"{"a":2,"b":1}"#)
    }

    @Test func decodeFromData_roundTrips() throws {
        let pair = Pair(b: 1, a: 2)
        #expect(try Pair.decodeFromData(try pair.encodeToData()) == pair)
    }
}
