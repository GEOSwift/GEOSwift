import XCTest
import GEOSwift

fileprivate extension Polygon.LinearRing where C == XY {
    // counterclockwise
    static let testValueExterior2 = try! Polygon.LinearRing(coordinates: [
        XY(2, 2),
        XY(-2, 2),
        XY(-2, -2),
        XY(2, -2),
        XY(2, 2)])

    // clockwise
    static let testValueHole1 = try! Polygon.LinearRing(coordinates: [
        XY(1, 1),
        XY(1, -1),
        XY(-1, -1),
        XY(-1, 1),
        XY(1, 1)])

    // counterclockwise
    static let testValueExterior7 = try! Polygon.LinearRing(coordinates: [
        XY(7, 2),
        XY(3, 2),
        XY(3, -2),
        XY(7, -2),
        XY(7, 2)])
}

fileprivate extension Polygon where C == XY {
    static let testValueWithHole = Polygon(
        exterior: Polygon<XY>.LinearRing.testValueExterior2,
        holes: [Polygon<XY>.LinearRing.testValueHole1])
    static let testJsonWithHole = #"{"coordinates":[[[2,2],[-2,2],[-2,-2],[2,-"#
        + #"2],[2,2]],[[1,1],[1,-1],[-1,-1],[-1,1],[1,1]]],"type":"Polygon"}"#

    static let testValueWithoutHole = Polygon(
        exterior: Polygon<XY>.LinearRing.testValueExterior7)
    static let testJsonWithoutHole = #"{"coordinates":[[[7,2],[3,2],[3,-2],[7,"#
        + #"-2],[7,2]]],"type":"Polygon"}"#
}

final class Polygon_CodableTestsXY: CodableTestCase {
    func testCodableWithoutHoles() {
        verifyCodable(
            with: Polygon<XY>.testValueWithoutHole,
            json: Polygon<XY>.testJsonWithoutHole)
    }

    func testCodableWithHole() {
        verifyCodable(
            with: Polygon<XY>.testValueWithHole,
            json: Polygon<XY>.testJsonWithHole)
    }

    func testDecodingPolygonWithTooFewRings() {
        let json = #"{"type":"Polygon","coordinates":[]}"#

        verifyDecodable(with: Polygon<XY>.self, json: json, expectedError: GEOSwiftError.tooFewRings)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: Polygon<XY>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: Polygon<XY>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}

final class Polygon_CodableTestsXYZ: CodableTestCase {
    // JSON strings matching Fixtures polygons
    // polygonWithHole: exterior [[2,2,0],[-2,2,0],[-2,-2,0],[2,-2,0],[2,2,1]]
    //                  hole [[1,1,0],[1,-1,0],[-1,-1,0],[-1,1,0],[1,1,1]]
    static let testJsonWithHole = #"{"coordinates":[[[2,2,0],[-2,2,0],[-2,-2,0],[2,-"#
        + #"2,0],[2,2,1]],[[1,1,0],[1,-1,0],[-1,-1,0],[-1,1,0],[1,1,1]]],"type":"Polygon"}"#

    // polygonWithoutHole: exterior [[7,2,0],[3,2,0],[3,-2,0],[7,-2,0],[7,2,1]]
    static let testJsonWithoutHole = #"{"coordinates":[[[7,2,0],[3,2,0],[3,-2,0],[7,"#
        + #"-2,0],[7,2,1]]],"type":"Polygon"}"#

    func testCodableWithoutHoles() {
        verifyCodable(
            with: Polygon<XYZ>(Fixtures.polygonWithoutHole),
            json: Self.testJsonWithoutHole)
    }

    func testCodableWithHole() {
        verifyCodable(
            with: Polygon<XYZ>(Fixtures.polygonWithHole),
            json: Self.testJsonWithHole)
    }

    func testDecodingPolygonWithTooFewRings() {
        let json = #"{"type":"Polygon","coordinates":[]}"#

        verifyDecodable(with: Polygon<XYZ>.self, json: json, expectedError: GEOSwiftError.tooFewRings)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1,2,3],"type":"Point"}"#

        verifyDecodable(with: Polygon<XYZ>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1,2,3],"type":"p"}"#

        verifyDecodable(with: Polygon<XYZ>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
