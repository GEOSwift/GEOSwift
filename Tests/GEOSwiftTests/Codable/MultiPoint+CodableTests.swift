import XCTest
import GEOSwift

extension MultiPoint where C == XY {
    static let testValue = MultiPoint(points: [.testValue1, .testValue3])
    static let testJson = #"{"coordinates":[[1,2],[3,4]],"type":"MultiPoint"}"#
}

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
final class MultiPoint_CodableTests: CodableTestCase {
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
