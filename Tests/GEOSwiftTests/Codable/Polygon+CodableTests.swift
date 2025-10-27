import XCTest
import GEOSwift

extension Polygon.LinearRing where C == XY {
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

extension Polygon where C == XY {
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

fileprivate extension Polygon.LinearRing where C == XYZ {
    // counterclockwise
    static let testValueExterior2 = try! Polygon.LinearRing(coordinates: [
        XYZ(2, 2, 1),
        XYZ(-2, 2, 2),
        XYZ(-2, -2, 3),
        XYZ(2, -2, 4),
        XYZ(2, 2, 5)])

    // clockwise
    static let testValueHole1 = try! Polygon.LinearRing(coordinates: [
        XYZ(1, 1, 6),
        XYZ(1, -1, 7),
        XYZ(-1, -1, 8),
        XYZ(-1, 1, 9),
        XYZ(1, 1, 10)])

    // counterclockwise
    static let testValueExterior7 = try! Polygon.LinearRing(coordinates: [
        XYZ(7, 2, 11),
        XYZ(3, 2, 12),
        XYZ(3, -2, 13),
        XYZ(7, -2, 14),
        XYZ(7, 2, 15)])
}

fileprivate extension Polygon where C == XYZ {
    static let testValueWithHole = Polygon(
        exterior: Polygon<XYZ>.LinearRing.testValueExterior2,
        holes: [Polygon<XYZ>.LinearRing.testValueHole1])
    static let testJsonWithHole = #"{"coordinates":[[[2,2,1],[-2,2,2],[-2,-2,3],[2,-"#
        + #"2,4],[2,2,5]],[[1,1,6],[1,-1,7],[-1,-1,8],[-1,1,9],[1,1,10]]],"type":"Polygon"}"#

    static let testValueWithoutHole = Polygon(
        exterior: Polygon<XYZ>.LinearRing.testValueExterior7)
    static let testJsonWithoutHole = #"{"coordinates":[[[7,2,11],[3,2,12],[3,-2,13],[7,"#
        + #"-2,14],[7,2,15]]],"type":"Polygon"}"#
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
    func testCodableWithoutHoles() {
        verifyCodable(
            with: Polygon<XYZ>.testValueWithoutHole,
            json: Polygon<XYZ>.testJsonWithoutHole)
    }

    func testCodableWithHole() {
        verifyCodable(
            with: Polygon<XYZ>.testValueWithHole,
            json: Polygon<XYZ>.testJsonWithHole)
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
