import Foundation
import Testing

@testable import ADUtilities

struct FoundationUtilityTests {
    // MARK: UUID v5

    @Test func uuidV5_matchesKnownVector() {
        // Python: uuid.uuid5(uuid.NAMESPACE_DNS, "python.org")
        let id = UUID(v5Name: "python.org", namespace: .namespaceDNS)
        #expect(id.uuidString == "886313E1-3B8A-5372-9B90-0C9AEE199E5D")
    }

    @Test func uuidV5_isDeterministicAndNamespaced() {
        let namespace = UUID()
        #expect(UUIDV5.make(name: "a", namespace: namespace) == UUID(v5Name: "a", namespace: namespace))
        #expect(UUID(v5Name: "a", namespace: namespace) != UUID(v5Name: "b", namespace: namespace))
        #expect(UUID(v5Name: "a", namespace: namespace) != UUID(v5Name: "a", namespace: UUID()))
    }

    // MARK: UUID text order

    @Test func textOrder_matchesUUIDStringOrder() {
        let ids = (0..<200).map { _ in UUID() }
        let byText = ids.sorted { $0.uuidString < $1.uuidString }
        #expect(ids.sorted { $0.isOrderedBeforeAsText($1) } == byText)
        #expect(ids.sorted { $0.textOrderKey < $1.textOrderKey } == byText)
    }

    @Test func textOrder_isStrict() {
        let id = UUID()
        #expect(!id.isOrderedBeforeAsText(id))
    }

    // MARK: Error

    struct Described: LocalizedError {
        var errorDescription: String? { "described" }
    }

    enum Plain: Error {
        case failed(code: Int)
    }

    @Test func diagnosticDescription_prefersErrorDescription() {
        #expect(Described().diagnosticDescription == "described")
    }

    @Test func diagnosticDescription_fallsBackToDescribing() {
        #expect(Plain.failed(code: 3).diagnosticDescription == "failed(code: 3)")
    }

    // MARK: URL

    @Test func relativePath_insideRoot() {
        let root = URL(fileURLWithPath: "/x/y", isDirectory: true)
        #expect(URL(fileURLWithPath: "/x/y/src/a.txt").relativePath(from: root) == "src/a.txt")
        #expect(URL(fileURLWithPath: "/x/y/z/../a.txt").relativePath(from: root) == "a.txt")
        #expect(URL(fileURLWithPath: "/x/y").relativePath(from: root) == "")
    }

    @Test func relativePath_outsideRoot_isNil() {
        let root = URL(fileURLWithPath: "/x/y")
        #expect(URL(fileURLWithPath: "/x/yz/a.txt").relativePath(from: root) == nil)
        #expect(URL(fileURLWithPath: "/other/x/y/a.txt").relativePath(from: root) == nil)
    }

    // MARK: Optional

    @Test func isNil_throughTypeErasure() {
        let none: Any = Int?.none
        let some: Any = Int?.some(1)
        #expect((none as? any AnyOptional)?.isNil == true)
        #expect((some as? any AnyOptional)?.isNil == false)
        #expect((1 as Any) as? any AnyOptional == nil)
    }
}
