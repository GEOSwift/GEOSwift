import XCTest
import GEOSwift

fileprivate extension MultiPoint where C == XY {
    static let testValue = MultiPoint(points: [Point(x: 1, y: 2), Point(x: 3, y: 4)])
    static let testJson = #"{"coordinates":[[1,2],[3,4]],"type":"MultiPoint"}"#
}

final class MultiPoint_CodableTestsXY: CodableTestCase {
    func testCodable() {
        verifyCodable(with: MultiPoint<XY>.testValue, json: MultiPoint<XY>.testJson)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: MultiPoint<XY>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: MultiPoint<XY>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}

final class MultiPoint_CodableTestsXYZ: CodableTestCase {
    // JSON string matching Fixtures.multiPoint
    // Contains point1 [1,2,0] and point3 [3,4,1]
    static let testJson = #"{"coordinates":[[1,2,0],[3,4,1]],"type":"MultiPoint"}"#

    func testCodable() {
        verifyCodable(with: MultiPoint<XYZ>(Fixtures.multiPoint), json: Self.testJson)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[[1,2,3]],"type":"Point"}"#

        verifyDecodable(with: MultiPoint<XYZ>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[[1,2,3]],"type":"p"}"#

        verifyDecodable(with: MultiPoint<XYZ>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
