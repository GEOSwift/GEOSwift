import XCTest
import GEOSwift

extension MultiPoint where C == XY {
    static let testValue = MultiPoint(points: [.testValue1, .testValue3])
    static let testJson = #"{"coordinates":[[1,2],[3,4]],"type":"MultiPoint"}"#
}

fileprivate extension MultiPoint where C == XYZ {
    static let testValue = MultiPoint(points: [
        Point(x: 1, y: 2, z: 3),
        Point(x: 4, y: 5, z: 6)
    ])
    static let testJson = #"{"coordinates":[[1,2,3],[4,5,6]],"type":"MultiPoint"}"#
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
    func testCodable() {
        verifyCodable(with: MultiPoint<XYZ>.testValue, json: MultiPoint<XYZ>.testJson)
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
