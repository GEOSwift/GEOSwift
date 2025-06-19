import XCTest
import GEOSwift

extension Point {
    static let testValue1 = Point(x: 1, y: 2)
    static let testJson1 = #"{"coordinates":[1,2],"type":"Point"}"#

    static let testValue3 = Point(x: 3, y: 4)

    static let testValue5 = Point(x: 5, y: 6)

    static let testValue7 = Point(x: 7, y: 8)
    
    static let testValueZ1 = Point(x: 1, y: 2, z: 3)
    static let testJsonZ1 = #"{"coordinates":[1,2,3],"type":"Point"}"#
    
    static let testValueZ2 = Point(x: 4, y: 5, z: 6)
}

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
final class Point_CodableTests: CodableTestCase {
    func testCodable() {
        verifyCodable(with: Point.testValue1, json: Point.testJson1)
    }
    
    func testCodableWithZ() {
        verifyCodable(with: Point.testValueZ1, json: Point.testJsonZ1)
    }

    func testDecodableThrowsWithLessThanTwoValues() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: Point.self, json: json, expectedError: .invalidCoordinates)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"MultiPoint"}"#

        verifyDecodable(with: Point.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: Point.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
