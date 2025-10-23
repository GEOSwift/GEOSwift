import XCTest
import GEOSwift

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

        verifyDecodable(with: GeoJSON<XY>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
