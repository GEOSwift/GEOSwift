import XCTest
import GEOSwift

extension LineString where C == XY {
    static let testValue1 = try! LineString(points: [.testValue1, .testValue3])
    static let testJson1 = #"{"coordinates":[[1,2],[3,4]],"type":"LineString"}"#

    static let testValue5 = try! LineString(points: [.testValue5, .testValue7])
}

fileprivate extension LineString where C == XYZ {
    static let testValue1 = try! LineString(points: [
        Point(x: 1, y: 2, z: 3),
        Point(x: 4, y: 5, z: 6)])
    static let testJson1 = #"{"coordinates":[[1,2,3],[4,5,6]],"type":"LineString"}"#

    static let testValue5 = try! LineString(points: [
        Point(x: 7, y: 8, z: 9),
        Point(x: 10, y: 11, z: 12)])
}

final class LineString_CodableTestsXY: CodableTestCase {
    func testCodable() {
        verifyCodable(with: LineString<XY>.testValue1, json: LineString<XY>.testJson1)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: LineString<XY>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: LineString<XY>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}

final class LineString_CodableTestsXYZ: CodableTestCase {
    func testCodable() {
        verifyCodable(with: LineString<XYZ>.testValue1, json: LineString<XYZ>.testJson1)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[[1,2,3]],"type":"Point"}"#

        verifyDecodable(with: LineString<XYZ>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[[1,2,3]],"type":"p"}"#

        verifyDecodable(with: LineString<XYZ>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
