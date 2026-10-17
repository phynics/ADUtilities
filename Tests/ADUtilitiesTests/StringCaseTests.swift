import Foundation
import Testing

@testable import ADUtilities

struct StringCaseTests {
    @Test(arguments: [
        ("animal companion (ranger)", "Animal Companion (Ranger)"),
        ("hand of the apprentice", "Hand of the Apprentice"),
        ("the rite of passage", "The Rite of Passage"),
        ("half-elf", "Half-Elf"),
        ("o'connor's blade", "O'Connor's Blade"),
        ("power attack (of the DC +1)", "Power Attack (Of the DC +1)"),
        ("", ""),
    ])
    func displayTitle(_ input: String, _ expected: String) {
        #expect(input.displayTitle == expected)
    }

    @Test func titleCased_customLowercaseWords() {
        #expect("war for the crown".titleCased(keepingLowercase: ["for"]) == "War for The Crown")
    }

    @Test(arguments: [
        ("divine-font", "divineFont"),
        ("a-b-c", "aBC"),
        ("plain", "plain"),
    ])
    func kebabToCamelCase(_ input: String, _ expected: String) {
        #expect(input.kebabToCamelCase == expected)
    }

    @Test func uuidString_isAFreshUUID() {
        #expect(UUID(uuidString: String.uuidString) != nil)
        #expect(String.uuidString != String.uuidString)
    }
}
