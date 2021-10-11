import XCTest
import GEOSwift

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
final class Geometry_CodableTests: CodableTestCase {
    func testCodablePoint() {
        verifyCodable(
            with: Geometry.point(.testValue1),
            json: Point.testJson1)
    }

    func testCodableMultiPoint() {
        verifyCodable(
            with: Geometry.multiPoint(.testValue),
            json: MultiPoint.testJson)
    }

    func testCodableLineString() {
        verifyCodable(
            with: Geometry.lineString(.testValue1),
            json: LineString.testJson1)
    }

    func testCodableMultiLineString() {
        verifyCodable(
            with: Geometry.multiLineString(.testValue),
            json: MultiLineString.testJson)
    }

    func testCodablePolygon() {
        verifyCodable(
            with: Geometry.polygon(.testValueWithHole),
            json: Polygon.testJsonWithHole)
    }

    func testCodableMultiPolygon() {
        verifyCodable(
            with: Geometry.multiPolygon(.testValue),
            json: MultiPolygon.testJson)
    }

    func testCodableGeometryCollection() {
        verifyCodable(
            with: Geometry.geometryCollection(.testValue),
            json: GeometryCollection.testJson)
    }

    func testDecodingInvalidType() {
        // point should be capitalized
        let json = #"{"coordinates":[1,2],"type":"point"}"#

        verifyDecodable(with: Geometry.self, json: json, expectedError: GEOSwiftError.invalidGeoJSONType)
    }

    func testDecodingFeature() {
        // Feature is not a geometry
        let json = #"{"type":"Feature"}"#

        verifyDecodable(with: Geometry.self, json: json, expectedError: GEOSwiftError.mismatchedGeoJSONType)
    }

    func testDecodingFeatureCollection() {
        // FeatureCollection is not a geometry
        let json = #"{"type":"FeatureCollection"}"#

        verifyDecodable(with: Geometry.self, json: json, expectedError: GEOSwiftError.mismatchedGeoJSONType)
    }
}
