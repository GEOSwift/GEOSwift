import XCTest
import GEOSwift

extension GEOSwift.Polygon.LinearRing {
    // counterclockwise
    static let testValueExterior2 = try! GEOSwift.Polygon.LinearRing(points: [
        Point(x: 2, y: 2),
        Point(x: -2, y: 2),
        Point(x: -2, y: -2),
        Point(x: 2, y: -2),
        Point(x: 2, y: 2)])

    // clockwise
    static let testValueHole1 = try! GEOSwift.Polygon.LinearRing(points: [
        Point(x: 1, y: 1),
        Point(x: 1, y: -1),
        Point(x: -1, y: -1),
        Point(x: -1, y: 1),
        Point(x: 1, y: 1)])

    // counterclockwise
    static let testValueExterior7 = try! GEOSwift.Polygon.LinearRing(points: [
        Point(x: 7, y: 2),
        Point(x: 3, y: 2),
        Point(x: 3, y: -2),
        Point(x: 7, y: -2),
        Point(x: 7, y: 2)])
}

extension GEOSwift.Polygon {
    static let testValueWithHole = GEOSwift.Polygon(
        exterior: .testValueExterior2,
        holes: [.testValueHole1])
    static let testJsonWithHole = #"{"coordinates":[[[2,2],[-2,2],[-2,-2],[2,-"#
        + #"2],[2,2]],[[1,1],[1,-1],[-1,-1],[-1,1],[1,1]]],"type":"Polygon"}"#

    static let testValueWithoutHole = GEOSwift.Polygon(
        exterior: .testValueExterior7)
    static let testJsonWithoutHole = #"{"coordinates":[[[7,2],[3,2],[3,-2],[7,"#
        + #"-2],[7,2]]],"type":"Polygon"}"#
}

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
final class Polygon_CodableTests: CodableTestCase {
    func testCodableWithoutHoles() {
        verifyCodable(
            with: Polygon.testValueWithoutHole,
            json: Polygon.testJsonWithoutHole)
    }

    func testCodableWithHole() {
        verifyCodable(
            with: Polygon.testValueWithHole,
            json: Polygon.testJsonWithHole)
    }

    func testDecodingPolygonWithTooFewRings() {
        let json = #"{"type":"Polygon","coordinates":[]}"#

        verifyDecodable(with: Polygon.self, json: json, expectedError: GEOSwiftError.tooFewRings)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: Polygon.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: Polygon.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
