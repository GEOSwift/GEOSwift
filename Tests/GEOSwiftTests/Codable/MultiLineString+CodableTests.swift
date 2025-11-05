import XCTest
import GEOSwift

fileprivate extension MultiLineString where C == XY {
    static let testValue = MultiLineString(lineStrings: [
        try! LineString(coordinates: [XY(1, 2), XY(3, 4)]),
        try! LineString(coordinates: [XY(5, 6), XY(7, 8)])
    ])
    static let testJson = #"{"coordinates":[[[1,2],[3,4]],[[5,6],[7,8]]],"type"#
        + #"":"MultiLineString"}"#
}


final class MultiLineString_CodableTestsXY: CodableTestCase {
    func testCodable() {
        verifyCodable(
            with: MultiLineString<XY>.testValue,
            json: MultiLineString<XY>.testJson)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: MultiLineString<XY>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: MultiLineString<XY>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}

final class MultiLineString_CodableTestsXYZ: CodableTestCase {
    // JSON string matching Fixtures.multiLineString
    // Contains lineString1 [[1,2,0],[3,4,1]] and lineString5 [[5,6,2],[7,8,3]]
    static let testJson = #"{"coordinates":[[[1,2,0],[3,4,1]],[[5,6,2],[7,8,3]]],"type"#
        + #"":"MultiLineString"}"#

    func testCodable() {
        verifyCodable(
            with: MultiLineString<XYZ>(Fixtures.multiLineString),
            json: Self.testJson)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: MultiLineString<XYZ>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: MultiLineString<XYZ>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
