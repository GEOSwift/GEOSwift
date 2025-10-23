import XCTest
import GEOSwift

extension MultiLineString where C == XY {
    static let testValue = MultiLineString(
        lineStrings: [.testValue1, .testValue5])
    static let testJson = #"{"coordinates":[[[1,2],[3,4]],[[5,6],[7,8]]],"type"#
        + #"":"MultiLineString"}"#
}

final class MultiLineString_CodableTests: CodableTestCase {
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
