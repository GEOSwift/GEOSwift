import XCTest
import GEOSwift

extension MultiPolygon where C == XY {
    static let testValue = MultiPolygon(
        polygons: [.testValueWithHole, .testValueWithoutHole])
    static let testJson = #"{"coordinates":[[[[2,2],[-2,2],[-2,-2],[2,-2],[2,2"#
        + #"]],[[1,1],[1,-1],[-1,-1],[-1,1],[1,1]]],[[[7,2],[3,2],[3,-2],[7,-2"#
        + #"],[7,2]]]],"type":"MultiPolygon"}"#
}

fileprivate extension MultiPolygon where C == XYZ {
    static let testValue = MultiPolygon(
        polygons: [
            Polygon(exterior: try! Polygon.LinearRing(points: [
                Point(x: 0, y: 0, z: 1),
                Point(x: 4, y: 0, z: 2),
                Point(x: 4, y: 4, z: 3),
                Point(x: 0, y: 4, z: 4),
                Point(x: 0, y: 0, z: 1)])),
            Polygon(exterior: try! Polygon.LinearRing(points: [
                Point(x: 5, y: 5, z: 5),
                Point(x: 9, y: 5, z: 6),
                Point(x: 9, y: 9, z: 7),
                Point(x: 5, y: 9, z: 8),
                Point(x: 5, y: 5, z: 5)]))
        ])
    static let testJson = #"{"coordinates":[[[[0,0,1],[4,0,2],[4,4,3],[0,4,4],"#
        + #"[0,0,1]]],[[[5,5,5],[9,5,6],[9,9,7],[5,9,8],[5,5,5]]]],"#
        + #""type":"MultiPolygon"}"#
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
    func testCodable() {
        verifyCodable(with: MultiPolygon<XYZ>.testValue, json: MultiPolygon<XYZ>.testJson)
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
