import XCTest
import GEOSwift

fileprivate extension MultiPolygon where C == XY {
    static let testValue = MultiPolygon(
        polygons: [
            Polygon(
                exterior: try! Polygon.LinearRing(coordinates: [
                    XY(2, 2), XY(-2, 2), XY(-2, -2), XY(2, -2), XY(2, 2)]),
                holes: [try! Polygon.LinearRing(coordinates: [
                    XY(1, 1), XY(1, -1), XY(-1, -1), XY(-1, 1), XY(1, 1)])]),
            Polygon(
                exterior: try! Polygon.LinearRing(coordinates: [
                    XY(7, 2), XY(3, 2), XY(3, -2), XY(7, -2), XY(7, 2)]))])
    static let testJson = #"{"coordinates":[[[[2,2],[-2,2],[-2,-2],[2,-2],[2,2"#
        + #"]],[[1,1],[1,-1],[-1,-1],[-1,1],[1,1]]],[[[7,2],[3,2],[3,-2],[7,-2"#
        + #"],[7,2]]]],"type":"MultiPolygon"}"#
}


final class MultiPolygon_CodableTestsXY: CodableTestCase {
    func testCodable() {
        verifyCodable(with: MultiPolygon<XY>.testValue, json: MultiPolygon<XY>.testJson)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: MultiPolygon<XY>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: MultiPolygon<XY>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}

final class MultiPolygon_CodableTestsXYZ: CodableTestCase {
    // JSON string matching Fixtures.multiPolygon
    // Contains polygonWithHole and polygonWithoutHole
    static let testJson = #"{"coordinates":[[[[2,2,0],[-2,2,0],[-2,-2,0],[2,-2,0],"#
        + #"[2,2,1]],[[1,1,0],[1,-1,0],[-1,-1,0],[-1,1,0],[1,1,1]]],[[[7,2,0],[3,2,0"#
        + #"],[3,-2,0],[7,-2,0],[7,2,1]]]],"type":"MultiPolygon"}"#

    func testCodable() {
        verifyCodable(with: MultiPolygon<XYZ>(Fixtures.multiPolygon), json: Self.testJson)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: MultiPolygon<XYZ>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: MultiPolygon<XYZ>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
