import XCTest
import GEOSwift

extension GeometryCollection where C == XY {
    static let testValue = GeometryCollection(
        geometries: [
            Point.testValue1,
            MultiPoint.testValue,
            LineString.testValue1,
            MultiLineString.testValue,
            Polygon.testValueWithHole,
            MultiPolygon.testValue])
    static let testJson = #"{"geometries":[\#(Point.testJson1),"#
        + #"\#(MultiPoint.testJson),\#(LineString.testJson1),"#
        + #"\#(MultiLineString.testJson),\#(Polygon.testJsonWithHole),"#
        + #"\#(MultiPolygon.testJson)],"type":"GeometryCollection"}"#

    static let testValueWithRecursion = GeometryCollection(
        geometries: [GeometryCollection.testValue])
    static let testJsonWithRecursion = #"{"geometries":[\#(testJson)],"type":""#
        + #"GeometryCollection"}"#
}

fileprivate extension GeometryCollection where C == XYZ {
    static let testValue = GeometryCollection(
        geometries: [
            Point(x: 1, y: 2, z: 3),
            try! LineString(points: [
                Point(x: 1, y: 2, z: 3),
                Point(x: 4, y: 5, z: 6)
            ])])
    static let testJson = #"{"geometries":[{"coordinates":[1,2,3],"type":"Point"},"#
        + #"{"coordinates":[[1,2,3],[4,5,6]],"type":"LineString"}],"#
        + #""type":"GeometryCollection"}"#

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
    func testCodable() {
        verifyCodable(
            with: GeometryCollection<XYZ>.testValue,
            json: GeometryCollection<XYZ>.testJson)
    }

    func testCodableWithRecursion() {
        verifyCodable(
            with: GeometryCollection<XYZ>.testValueWithRecursion,
            json: GeometryCollection<XYZ>.testJsonWithRecursion)
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
