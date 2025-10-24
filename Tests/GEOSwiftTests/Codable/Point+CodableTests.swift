import XCTest
import GEOSwift

extension Point where C == XY {
    static let testValue1 = Point(x: 1, y: 2)
    static let testJson1 = #"{"coordinates":[1,2],"type":"Point"}"#

    static let testValue3 = Point(x: 3, y: 4)

    static let testValue5 = Point(x: 5, y: 6)

    static let testValue7 = Point(x: 7, y: 8)
}

fileprivate extension Point where C == XYZ {
    static let testValue1 = Point(x: 1, y: 2, z: 3)
    static let testJson1 = #"{"coordinates":[1,2,3],"type":"Point"}"#

    static let testValue3 = Point(x: 4, y: 5, z: 6)

    static let testValue5 = Point(x: 7, y: 8, z: 9)

    static let testValue7 = Point(x: 10, y: 11, z: 12)
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
    func testCodable() {
        verifyCodable(with: Point<XYZ>.testValue1, json: Point<XYZ>.testJson1)
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
