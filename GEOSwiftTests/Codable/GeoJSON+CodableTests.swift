import XCTest
import GEOSwift

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
final class GeoJSON_CodableTests: CodableTestCase {
    func testCodableFeatureCollection() {
        verifyCodable(
            with: GeoJSON.featureCollection(.testValue),
            json: FeatureCollection.testJson)
    }

    func testCodableFeature() {
        verifyCodable(
            with: GeoJSON.feature(.testValueWithNumberId),
            json: Feature.testJsonWithNumberId)
    }

    func testCodableGeometry() {
        verifyCodable(
            with: GeoJSON.geometry(.point(.testValue1)),
            json: Point.testJson1)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: GeoJSON.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
