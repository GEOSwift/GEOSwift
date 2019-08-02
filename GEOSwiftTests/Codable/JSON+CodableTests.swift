import XCTest
import GEOSwift

extension JSON {
    static let testValue: JSON = [
        "a": ["y"],
        "b": true,
        "n": 1,
        "null": nil,
        "s": "x"]
    static let testJson = #"{"a":["y"],"b":true,"n":1,"null":null,"s":"x"}"#
}

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
final class JSON_CodableTests: CodableTestCase {
    func testCodable() {
        verifyCodable(with: JSON.testValue, json: JSON.testJson)
    }
}
