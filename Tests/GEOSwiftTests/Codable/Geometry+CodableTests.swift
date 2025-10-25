import XCTest
import GEOSwift

final class Geometry_CodableTestsXY: CodableTestCase {
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

        verifyDecodable(with: Geometry<XY>.self, json: json, expectedError: GEOSwiftError.invalidGeoJSONType)
    }

    func testDecodingFeature() {
        // Feature is not a geometry
        let json = #"{"type":"Feature"}"#

        verifyDecodable(with: Geometry<XY>.self, json: json, expectedError: GEOSwiftError.mismatchedGeoJSONType)
    }

    func testDecodingFeatureCollection() {
        // FeatureCollection is not a geometry
        let json = #"{"type":"FeatureCollection"}"#

        verifyDecodable(with: Geometry<XY>.self, json: json, expectedError: GEOSwiftError.mismatchedGeoJSONType)
    }
}

// MARK: - XYZ Tests

final class Geometry_CodableTestsXYZ: CodableTestCase {
    func testCodablePoint() {
        let point = Point<XYZ>(x: 1, y: 2, z: 3)
        let json = #"{"coordinates":[1,2,3],"type":"Point"}"#
        verifyCodable(with: Geometry.point(point), json: json)
    }

    func testCodableMultiPoint() {
        let multiPoint = MultiPoint(points: [
            Point(x: 1, y: 2, z: 3),
            Point(x: 4, y: 5, z: 6)])
        let json = #"{"coordinates":[[1,2,3],[4,5,6]],"type":"MultiPoint"}"#
        verifyCodable(with: Geometry.multiPoint(multiPoint), json: json)
    }

    func testCodableLineString() {
        let lineString = try! LineString(points: [
            Point(x: 1, y: 2, z: 3),
            Point(x: 4, y: 5, z: 6)])
        let json = #"{"coordinates":[[1,2,3],[4,5,6]],"type":"LineString"}"#
        verifyCodable(with: Geometry.lineString(lineString), json: json)
    }

    func testCodableMultiLineString() {
        let multiLineString = MultiLineString(
            lineStrings: [
                try! LineString(points: [
                    Point(x: 1, y: 2, z: 3),
                    Point(x: 4, y: 5, z: 6)]),
                try! LineString(points: [
                    Point(x: 7, y: 8, z: 9),
                    Point(x: 10, y: 11, z: 12)])])
        let json = #"{"coordinates":[[[1,2,3],[4,5,6]],[[7,8,9],[10,11,12]]],"type"#
            + #"":"MultiLineString"}"#
        verifyCodable(with: Geometry.multiLineString(multiLineString), json: json)
    }

    func testCodablePolygon() {
        let polygon = Polygon(
            exterior: try! Polygon.LinearRing(points: [
                Point(x: 2, y: 2, z: 1),
                Point(x: -2, y: 2, z: 2),
                Point(x: -2, y: -2, z: 3),
                Point(x: 2, y: -2, z: 4),
                Point(x: 2, y: 2, z: 1)]),
            holes: [try! Polygon.LinearRing(points: [
                Point(x: 1, y: 1, z: 5),
                Point(x: 1, y: -1, z: 6),
                Point(x: -1, y: -1, z: 7),
                Point(x: -1, y: 1, z: 8),
                Point(x: 1, y: 1, z: 5)])])
        let json = #"{"coordinates":[[[2,2,1],[-2,2,2],[-2,-2,3],[2,-"#
            + #"2,4],[2,2,1]],[[1,1,5],[1,-1,6],[-1,-1,7],[-1,1,8],[1,1,5]]],"type":"Polygon"}"#
        verifyCodable(with: Geometry.polygon(polygon), json: json)
    }

    func testCodableMultiPolygon() {
        let polygon1 = Polygon(
            exterior: try! Polygon.LinearRing(points: [
                Point(x: 0, y: 0, z: 1),
                Point(x: 4, y: 0, z: 2),
                Point(x: 4, y: 4, z: 3),
                Point(x: 0, y: 4, z: 4),
                Point(x: 0, y: 0, z: 1)]))
        let polygon2 = Polygon(
            exterior: try! Polygon.LinearRing(points: [
                Point(x: 8, y: 0, z: 11),
                Point(x: 12, y: 0, z: 12),
                Point(x: 12, y: 4, z: 13),
                Point(x: 8, y: 4, z: 14),
                Point(x: 8, y: 0, z: 11)]))
        let multiPolygon = MultiPolygon(polygons: [polygon1, polygon2])
        let json = #"{"coordinates":[[[[0,0,1],[4,0,2],[4,4,3],[0,4,4],"#
            + #"[0,0,1]]],[[[8,0,11],[12,0,12],[12,4,13],[8,4,14],[8,0,11]]]],"type":"MultiPolygon"}"#
        verifyCodable(with: Geometry.multiPolygon(multiPolygon), json: json)
    }

    func testCodableGeometryCollection() {
        let point = Point<XYZ>(x: 1, y: 2, z: 3)
        let lineString = try! LineString(points: [
            Point(x: 1, y: 2, z: 3),
            Point(x: 4, y: 5, z: 6)])
        let geometryCollection = GeometryCollection(geometries: [point, lineString])
        let json = #"{"geometries":[{"coordinates":[1,2,3],"type":"Point"},"#
            + #"{"coordinates":[[1,2,3],[4,5,6]],"type":"LineString"}],"#
            + #""type":"GeometryCollection"}"#
        verifyCodable(with: Geometry.geometryCollection(geometryCollection), json: json)
    }

    func testDecodingInvalidType() {
        // point should be capitalized
        let json = #"{"coordinates":[1,2,3],"type":"point"}"#

        verifyDecodable(with: Geometry<XYZ>.self, json: json, expectedError: GEOSwiftError.invalidGeoJSONType)
    }

    func testDecodingFeature() {
        // Feature is not a geometry
        let json = #"{"type":"Feature"}"#

        verifyDecodable(with: Geometry<XYZ>.self, json: json, expectedError: GEOSwiftError.mismatchedGeoJSONType)
    }

    func testDecodingFeatureCollection() {
        // FeatureCollection is not a geometry
        let json = #"{"type":"FeatureCollection"}"#

        verifyDecodable(with: Geometry<XYZ>.self, json: json, expectedError: GEOSwiftError.mismatchedGeoJSONType)
    }
}
