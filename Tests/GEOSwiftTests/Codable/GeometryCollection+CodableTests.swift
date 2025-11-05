import XCTest
import GEOSwift

fileprivate extension GeometryCollection where C == XY {
    static let testValue = GeometryCollection(
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
    static let testJson = #"{"geometries":[{"coordinates":[1,2],"type":"Point"},"#
        + #"{"coordinates":[[1,2],[3,4]],"type":"MultiPoint"},"#
        + #"{"coordinates":[[1,2],[3,4]],"type":"LineString"},"#
        + #"{"coordinates":[[[1,2],[3,4]],[[5,6],[7,8]]],"type":"MultiLineString"},"#
        + #"{"coordinates":[[[2,2],[-2,2],[-2,-2],[2,-2],[2,2]],"#
        + #"[[1,1],[1,-1],[-1,-1],[-1,1],[1,1]]],"type":"Polygon"},"#
        + #"{"coordinates":[[[[2,2],[-2,2],[-2,-2],[2,-2],[2,2]],"#
        + #"[[1,1],[1,-1],[-1,-1],[-1,1],[1,1]]],[[[7,2],[3,2],[3,-2],[7,-2],[7,2]]]],"#
        + #""type":"MultiPolygon"}],"type":"GeometryCollection"}"#

    static let testValueWithRecursion = GeometryCollection(
        geometries: [GeometryCollection.testValue])
    static let testJsonWithRecursion = #"{"geometries":[\#(testJson)],"type":""#
        + #"GeometryCollection"}"#
}

final class GeometryCollection_CodableTestsXY: CodableTestCase {
    func testCodable() {
        verifyCodable(
            with: GeometryCollection<XY>.testValue,
            json: GeometryCollection<XY>.testJson)
    }

    func testCodableWithRecursion() {
        verifyCodable(
            with: GeometryCollection<XY>.testValueWithRecursion,
            json: GeometryCollection<XY>.testJsonWithRecursion)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: GeometryCollection<XY>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: GeometryCollection<XY>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}

final class GeometryCollection_CodableTestsXYZ: CodableTestCase {
    // JSON string matching Fixtures.geometryCollection
    // Contains: point1, multiPoint, lineString1, multiLineString, polygonWithHole, multiPolygon
    static let testJson =
        #"{"geometries":["#
        + #"{"coordinates":[1,2,0],"type":"Point"},"# // point1
        + #"{"coordinates":[[1,2,0],[3,4,1]],"type":"MultiPoint"},"# // multiPoint
        + #"{"coordinates":[[1,2,0],[3,4,1]],"type":"LineString"},"# // lineString1
        + #"{"coordinates":[[[1,2,0],[3,4,1]],[[5,6,2],[7,8,3]]],"type":"MultiLineString"},"# // multiLineString
        + #"{"coordinates":[[[2,2,0],[-2,2,0],[-2,-2,0],[2,-2,0],[2,2,1]],"#
        + #"[[1,1,0],[1,-1,0],[-1,-1,0],[-1,1,0],[1,1,1]]],"type":"Polygon"},"# // polygonWithHole
        + #"{"coordinates":[[[[2,2,0],[-2,2,0],[-2,-2,0],[2,-2,0],[2,2,1]],"#
        + #"[[1,1,0],[1,-1,0],[-1,-1,0],[-1,1,0],[1,1,1]]],"#
        + #"[[[7,2,0],[3,2,0],[3,-2,0],[7,-2,0],[7,2,1]]]],"type":"MultiPolygon"}"# // multiPolygon
        + #"],"type":"GeometryCollection"}"#

    static let testJsonWithRecursion = #"{"geometries":[\#(testJson)],"type":""#
        + #"GeometryCollection"}"#

    func testCodable() {
        verifyCodable(
            with: GeometryCollection<XYZ>(Fixtures.geometryCollection),
            json: Self.testJson)
    }

    func testCodableWithRecursion() {
        verifyCodable(
            with: GeometryCollection<XYZ>(Fixtures.recursiveGeometryCollection),
            json: Self.testJsonWithRecursion)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1,2,3],"type":"Point"}"#

        verifyDecodable(with: GeometryCollection<XYZ>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1,2,3],"type":"p"}"#

        verifyDecodable(with: GeometryCollection<XYZ>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
