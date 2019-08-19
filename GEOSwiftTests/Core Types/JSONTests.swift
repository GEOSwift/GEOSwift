import XCTest
import GEOSwift

final class JSONTests: XCTestCase {
    func testUntypedValue() {
        let json: JSON = [
            "a": ["y"],
            "b": true,
            "n": 1,
            "null": nil,
            "s": "x",
            "o": ["x": 123, "y": false, "z": nil]]

        let untypedValue = json.untypedValue as! NSDictionary

        let expected: NSDictionary = [
            "a": ["y"],
            "b": true,
            "n": 1,
            "null": NSNull(),
            "s": "x",
            "o": ["x": 123, "y": false, "z": NSNull()]]
        XCTAssertEqual(untypedValue, expected)
    }

    func testInitWithStringLiteral() {
        let json: JSON = "test"

        XCTAssertEqual(json, .string("test"))
    }

    func testInitWithIntegerLiteral() {
        let json: JSON = 1

        XCTAssertEqual(json, .number(1))
    }

    func testInitWithFloatLiteral() {
        let json: JSON = 2.0

        XCTAssertEqual(json, .number(2))
    }

    func testInitWithBooleanLiteral() {
        let json: JSON = true

        XCTAssertEqual(json, .boolean(true))
    }

    func testInitWithArrayLiteral() {
        let json: JSON = [true, false]

        XCTAssertEqual(json, .array([.boolean(true), .boolean(false)]))
    }

    func testInitWithDictionaryLiteral() {
        let json: JSON = ["a": true, "b": 1]

        XCTAssertEqual(json, .object(["a": .boolean(true), "b": .number(1)]))
    }

    func testInitWithNilLiteral() {
        let json: JSON = nil

        XCTAssertEqual(json, .null)
    }
}
