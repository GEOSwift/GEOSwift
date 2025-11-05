import XCTest
import GEOSwift

fileprivate extension JSON {
    static let testValue: JSON = [
        "a": ["y"],
        "b": true,
        "n": 1,
        "null": nil,
        "s": "x"]
    static let testJson = #"{"a":["y"],"b":true,"n":1,"null":null,"s":"x"}"#
}

final class JSON_CodableTests: CodableTestCase {
    func testCodable() {
        verifyCodable(with: JSON.testValue, json: JSON.testJson)
    }
}
