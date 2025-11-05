import XCTest
import GEOSwift

fileprivate extension Point where C == XY {
    static let testValue1 = Point(x: 1, y: 2)
    static let testJson1 = #"{"coordinates":[1,2],"type":"Point"}"#

    static let testValue3 = Point(x: 3, y: 4)

    static let testValue5 = Point(x: 5, y: 6)

    static let testValue7 = Point(x: 7, y: 8)
}

final class Point_CodableTestsXY: CodableTestCase {
    func testCodable() {
        verifyCodable(with: Point<XY>.testValue1, json: Point<XY>.testJson1)
    }

    func testDecodableThrowsWithLessThanTwoValues() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: Point<XY>.self, json: json, expectedError: .invalidCoordinates)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"MultiPoint"}"#

        verifyDecodable(with: Point<XY>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: Point<XY>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}

final class Point_CodableTestsXYZ: CodableTestCase {
    // JSON string matching Fixtures.point1 (XYZM(1,2,0,0) -> XYZ(1,2,0))
    static let testJson1 = #"{"coordinates":[1,2,0],"type":"Point"}"#

    func testCodable() {
        verifyCodable(with: Point<XYZ>(Fixtures.point1), json: Self.testJson1)
    }

    func testDecodableThrowsWithLessThanTwoValues() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: Point<XYZ>.self, json: json, expectedError: .invalidCoordinates)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1,2,3],"type":"MultiPoint"}"#

        verifyDecodable(with: Point<XYZ>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1,2,3],"type":"p"}"#

        verifyDecodable(with: Point<XYZ>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
