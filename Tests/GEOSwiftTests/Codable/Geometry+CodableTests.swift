import XCTest
import GEOSwift

final class Geometry_CodableTestsXY: CodableTestCase {
    func testCodablePoint() {
        let point = Point<XY>(x: 1, y: 2)
        let json = #"{"coordinates":[1,2],"type":"Point"}"#

        verifyCodable(
            with: Geometry.point(point),
            json: json)
    }

    func testCodableMultiPoint() {
        let multiPoint = MultiPoint(points: [Point(x: 1, y: 2), Point(x: 3, y: 4)])
        let json = #"{"coordinates":[[1,2],[3,4]],"type":"MultiPoint"}"#

        verifyCodable(
            with: Geometry.multiPoint(multiPoint),
            json: json)
    }

    func testCodableLineString() {
        let lineString = try! LineString(coordinates: [XY(1, 2), XY(3, 4)])
        let json = #"{"coordinates":[[1,2],[3,4]],"type":"LineString"}"#

        verifyCodable(
            with: Geometry.lineString(lineString),
            json: json)
    }

    func testCodableMultiLineString() {
        let multiLineString = MultiLineString(
            lineStrings: [
                try! LineString(coordinates: [XY(1, 2), XY(3, 4)]),
                try! LineString(coordinates: [XY(5, 6), XY(7, 8)])])
        let json = #"{"coordinates":[[[1,2],[3,4]],[[5,6],[7,8]]],"type":"MultiLineString"}"#

        verifyCodable(
            with: Geometry.multiLineString(multiLineString),
            json: json)
    }

    func testCodablePolygon() {
        let polygon = Polygon(
            exterior: try! Polygon.LinearRing(coordinates: [
                XY(2, 2), XY(-2, 2), XY(-2, -2), XY(2, -2), XY(2, 2)]),
            holes: [try! Polygon.LinearRing(coordinates: [
                XY(1, 1), XY(1, -1), XY(-1, -1), XY(-1, 1), XY(1, 1)])])
        let json = #"{"coordinates":[[[2,2],[-2,2],[-2,-2],[2,-2],[2,2]],[[1,1],[1,-1],[-1,-1],[-1,1],[1,1]]],"type":"Polygon"}"#

        verifyCodable(
            with: Geometry.polygon(polygon),
            json: json)
    }

    func testCodableMultiPolygon() {
        let multiPolygon = MultiPolygon(
            polygons: [
                Polygon(
                    exterior: try! Polygon.LinearRing(coordinates: [
                        XY(2, 2), XY(-2, 2), XY(-2, -2), XY(2, -2), XY(2, 2)]),
                    holes: [try! Polygon.LinearRing(coordinates: [
                        XY(1, 1), XY(1, -1), XY(-1, -1), XY(-1, 1), XY(1, 1)])]),
                Polygon(
                    exterior: try! Polygon.LinearRing(coordinates: [
                        XY(7, 2), XY(3, 2), XY(3, -2), XY(7, -2), XY(7, 2)]))])
        let json = #"{"coordinates":[[[[2,2],[-2,2],[-2,-2],[2,-2],[2,2]],[[1,1],[1,-1],[-1,-1],[-1,1],[1,1]]],[[[7,2],[3,2],[3,-2],[7,-2],[7,2]]]],"type":"MultiPolygon"}"#

        verifyCodable(
            with: Geometry.multiPolygon(multiPolygon),
            json: json)
    }

    func testCodableGeometryCollection() {
        let geometryCollection = GeometryCollection(
            geometries: [
                Point(x: 1, y: 2),
                MultiPoint(points: [Point(x: 1, y: 2), Point(x: 3, y: 4)]),
                try! LineString(coordinates: [XY(1, 2), XY(3, 4)]),
                MultiLineString(
                    lineStrings: [
                        try! LineString(coordinates: [XY(1, 2), XY(3, 4)]),
                        try! LineString(coordinates: [XY(5, 6), XY(7, 8)])]),
                Polygon(
                    exterior: try! Polygon.LinearRing(coordinates: [
                        XY(2, 2), XY(-2, 2), XY(-2, -2), XY(2, -2), XY(2, 2)]),
                    holes: [try! Polygon.LinearRing(coordinates: [
                        XY(1, 1), XY(1, -1), XY(-1, -1), XY(-1, 1), XY(1, 1)])]),
                MultiPolygon(
                    polygons: [
                        Polygon(
                            exterior: try! Polygon.LinearRing(coordinates: [
                                XY(2, 2), XY(-2, 2), XY(-2, -2), XY(2, -2), XY(2, 2)]),
                            holes: [try! Polygon.LinearRing(coordinates: [
                                XY(1, 1), XY(1, -1), XY(-1, -1), XY(-1, 1), XY(1, 1)])]),
                        Polygon(
                            exterior: try! Polygon.LinearRing(coordinates: [
                                XY(7, 2), XY(3, 2), XY(3, -2), XY(7, -2), XY(7, 2)]))])])
        let json = #"{"geometries":[{"coordinates":[1,2],"type":"Point"},"#
            + #"{"coordinates":[[1,2],[3,4]],"type":"MultiPoint"},"#
            + #"{"coordinates":[[1,2],[3,4]],"type":"LineString"},"#
            + #"{"coordinates":[[[1,2],[3,4]],[[5,6],[7,8]]],"type":"MultiLineString"},"#
            + #"{"coordinates":[[[2,2],[-2,2],[-2,-2],[2,-2],[2,2]],[[1,1],[1,-1],[-1,-1],[-1,1],[1,1]]],"type":"Polygon"},"#
            + #"{"coordinates":[[[[2,2],[-2,2],[-2,-2],[2,-2],[2,2]],[[1,1],[1,-1],[-1,-1],[-1,1],[1,1]]],[[[7,2],[3,2],[3,-2],[7,-2],[7,2]]]],"type":"MultiPolygon"}],"type":"GeometryCollection"}"#

        verifyCodable(
            with: Geometry.geometryCollection(geometryCollection),
            json: json)
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
            exterior: try! Polygon.LinearRing(coordinates: [
                XYZ(2, 2, 1),
                XYZ(-2, 2, 2),
                XYZ(-2, -2, 3),
                XYZ(2, -2, 4),
                XYZ(2, 2, 1)]),
            holes: [try! Polygon.LinearRing(coordinates: [
                XYZ(1, 1, 5),
                XYZ(1, -1, 6),
                XYZ(-1, -1, 7),
                XYZ(-1, 1, 8),
                XYZ(1, 1, 5)])])
        let json = #"{"coordinates":[[[2,2,1],[-2,2,2],[-2,-2,3],[2,-"#
            + #"2,4],[2,2,1]],[[1,1,5],[1,-1,6],[-1,-1,7],[-1,1,8],[1,1,5]]],"type":"Polygon"}"#
        verifyCodable(with: Geometry.polygon(polygon), json: json)
    }

    func testCodableMultiPolygon() {
        let polygon1 = Polygon(
            exterior: try! Polygon.LinearRing(coordinates: [
                XYZ(0, 0, 1),
                XYZ(4, 0, 2),
                XYZ(4, 4, 3),
                XYZ(0, 4, 4),
                XYZ(0, 0, 1)]))
        let polygon2 = Polygon(
            exterior: try! Polygon.LinearRing(coordinates: [
                XYZ(8, 0, 11),
                XYZ(12, 0, 12),
                XYZ(12, 4, 13),
                XYZ(8, 4, 14),
                XYZ(8, 0, 11)]))
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
