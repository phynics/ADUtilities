#if canImport(CryptoKit)
import CryptoKit
#endif
import Foundation

extension UUID {
    /// A name-based (version 5, SHA-1) UUID, as RFC 9562 defines it: the same name in the same
    /// namespace always gives the same ID.
    public init(v5Name name: String, namespace: UUID) {
        var bytes = withUnsafeBytes(of: namespace.uuid) { Array($0) }
        bytes.append(contentsOf: Array(name.utf8))

        #if canImport(CryptoKit)
        var digest = Array(Insecure.SHA1.hash(data: Data(bytes)).prefix(16))
        #else
        var digest = Array(SHA1.hash(bytes).prefix(16))
        #endif
        digest[6] = (digest[6] & 0x0F) | 0x50
        digest[8] = (digest[8] & 0x3F) | 0x80

        self.init(uuid: (
            digest[0], digest[1], digest[2], digest[3],
            digest[4], digest[5], digest[6], digest[7],
            digest[8], digest[9], digest[10], digest[11],
            digest[12], digest[13], digest[14], digest[15]
        ))
    }

    /// The RFC 9562 namespace for fully qualified domain names.
    public static let namespaceDNS = UUID(uuidString: "6BA7B810-9DAD-11D1-80B4-00C04FD430C8")!
    /// The RFC 9562 namespace for URLs.
    public static let namespaceURL = UUID(uuidString: "6BA7B811-9DAD-11D1-80B4-00C04FD430C8")!
    /// The RFC 9562 namespace for ISO OIDs.
    public static let namespaceOID = UUID(uuidString: "6BA7B812-9DAD-11D1-80B4-00C04FD430C8")!
    /// The RFC 9562 namespace for X.500 DNs.
    public static let namespaceX500 = UUID(uuidString: "6BA7B814-9DAD-11D1-80B4-00C04FD430C8")!
}

/// Name-based UUIDs. Kept as a namespace so existing `UUIDV5.make` call sites move over unchanged.
public enum UUIDV5 {
    public static func make(name: String, namespace: UUID) -> UUID {
        UUID(v5Name: name, namespace: namespace)
    }
}

#if !canImport(CryptoKit)
/// A plain SHA-1 for platforms without CryptoKit. Used only to derive v5 UUIDs.
private enum SHA1 {
    static func hash(_ input: [UInt8]) -> [UInt8] {
        var message = input
        let bitLength = UInt64(message.count) * 8

        message.append(0x80)
        while message.count % 64 != 56 {
            message.append(0)
        }
        message.append(contentsOf: withUnsafeBytes(of: bitLength.bigEndian) { Array($0) })

        var state: [UInt32] = [0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0]

        for chunkStart in stride(from: 0, to: message.count, by: 64) {
            var words = [UInt32](repeating: 0, count: 80)
            for index in 0..<16 {
                let offset = chunkStart + index * 4
                words[index] = UInt32(message[offset]) << 24
                    | UInt32(message[offset + 1]) << 16
                    | UInt32(message[offset + 2]) << 8
                    | UInt32(message[offset + 3])
            }
            for index in 16..<80 {
                let value = words[index - 3] ^ words[index - 8] ^ words[index - 14] ^ words[index - 16]
                words[index] = (value << 1) | (value >> 31)
            }

            var a = state[0], b = state[1], c = state[2], d = state[3], e = state[4]

            for index in 0..<80 {
                let function: UInt32
                let constant: UInt32
                switch index {
                case 0..<20:
                    function = (b & c) | (~b & d)
                    constant = 0x5A827999
                case 20..<40:
                    function = b ^ c ^ d
                    constant = 0x6ED9EBA1
                case 40..<60:
                    function = (b & c) | (b & d) | (c & d)
                    constant = 0x8F1BBCDC
                default:
                    function = b ^ c ^ d
                    constant = 0xCA62C1D6
                }
                let temp = ((a << 5) | (a >> 27)) &+ function &+ e &+ constant &+ words[index]
                e = d
                d = c
                c = (b << 30) | (b >> 2)
                b = a
                a = temp
            }

            state[0] &+= a
            state[1] &+= b
            state[2] &+= c
            state[3] &+= d
            state[4] &+= e
        }

        return state.flatMap { value in
            [UInt8(truncatingIfNeeded: value >> 24), UInt8(truncatingIfNeeded: value >> 16),
             UInt8(truncatingIfNeeded: value >> 8), UInt8(truncatingIfNeeded: value)]
        }
    }
}
#endif
