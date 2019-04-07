import XCTest
import GEOSwift

extension FeatureCollection {
    static let testValue = FeatureCollection(
        features: [.testValueWithNumberId, .testValueWithNils])
    static let testJson = #"{"features":[\#(Feature.testJsonWithNumberId),"#
        + #"\#(Feature.testJsonWithNils)],"type":"FeatureCollection"}"#
}

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
final class FeatureCollection_CodableTests: CodableTestCase {
    func testCodable() {
        verifyCodable(
            with: FeatureCollection.testValue,
            json: FeatureCollection.testJson)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: FeatureCollection.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: FeatureCollection.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
