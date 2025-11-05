import XCTest
import GEOSwift

final class GeoJSON_CodableTests: CodableTestCase {
    func testCodableFeatureCollection() {
        let testPoint = Point<XY>(x: 1, y: 2)
        let testPointJson = #"{"coordinates":[1,2],"type":"Point"}"#
        let testFeatureWithNumberId = Feature(
            geometry: testPoint,
            properties: ["a": .string("b")],
            id: .number(0))
        let testFeatureJsonWithNumberId = #"{"geometry":\#(testPointJson),"id":0,"properties"#
            + #"":{"a":"b"},"type":"Feature"}"#
        let testFeatureWithNils = Feature<XY>(
            geometry: nil,
            properties: nil,
            id: nil)
        let testFeatureJsonWithNils = #"{"geometry":null,"properties":null,"type":"#
            + #""Feature"}"#
        let testFeatureCollection = FeatureCollection(
            features: [testFeatureWithNumberId, testFeatureWithNils])
        let testFeatureCollectionJson = #"{"features":[\#(testFeatureJsonWithNumberId),"#
            + #"\#(testFeatureJsonWithNils)],"type":"FeatureCollection"}"#

        verifyCodable(
            with: GeoJSON.featureCollection(testFeatureCollection),
            json: testFeatureCollectionJson)
    }

    func testCodableFeature() {
        let testPoint = Point<XY>(x: 1, y: 2)
        let testPointJson = #"{"coordinates":[1,2],"type":"Point"}"#
        let testFeatureWithNumberId = Feature(
            geometry: testPoint,
            properties: ["a": .string("b")],
            id: .number(0))
        let testFeatureJsonWithNumberId = #"{"geometry":\#(testPointJson),"id":0,"properties"#
            + #"":{"a":"b"},"type":"Feature"}"#

        verifyCodable(
            with: GeoJSON.feature(testFeatureWithNumberId),
            json: testFeatureJsonWithNumberId)
    }

    func testCodableGeometry() {
        let testPoint = Point<XY>(x: 1, y: 2)
        let testPointJson = #"{"coordinates":[1,2],"type":"Point"}"#

        verifyCodable(
            with: GeoJSON.geometry(.point(testPoint)),
            json: testPointJson)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: GeoJSON<XY>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
