import XCTest
import GEOSwift

final class JSONTests: XCTestCase {
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
