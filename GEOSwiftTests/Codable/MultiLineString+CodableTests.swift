import XCTest
import GEOSwift

extension MultiLineString {
    static let testValue = MultiLineString(
        lineStrings: [.testValue1, .testValue5])
    static let testJson = #"{"coordinates":[[[1,2],[3,4]],[[5,6],[7,8]]],"type"#
        + #"":"MultiLineString"}"#
}

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
final class MultiLineString_CodableTests: CodableTestCase {
    func testCodable() {
        verifyCodable(
            with: MultiLineString.testValue,
            json: MultiLineString.testJson)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: MultiLineString.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: MultiLineString.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
