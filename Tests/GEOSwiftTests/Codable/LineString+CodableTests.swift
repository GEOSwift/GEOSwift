import XCTest
import GEOSwift

fileprivate extension LineString where C == XY {
    static let testValue1 = try! LineString(coordinates: [XY(1, 2), XY(3, 4)])
    static let testJson1 = #"{"coordinates":[[1,2],[3,4]],"type":"LineString"}"#

    static let testValue5 = try! LineString(coordinates: [XY(5, 6), XY(7, 8)])
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
    // JSON string matching Fixtures.lineString1 (XYZ(1,2,0), XYZ(3,4,1))
    static let testJson1 = #"{"coordinates":[[1,2,0],[3,4,1]],"type":"LineString"}"#

    func testCodable() {
        verifyCodable(with: LineString<XYZ>(Fixtures.lineString1), json: Self.testJson1)
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
