import XCTest
import GEOSwift

final class DifferenceTests: XCTestCase {
    let unitPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
        XY(0, 0),
        XY(1, 0),
        XY(1, 1),
        XY(0, 1),
        XY(0, 0)]))

    let geometryConvertibles: [any GeometryConvertible<XY>] = [
        Point.testValue1,
        Geometry.point(.testValue1),
        MultiPoint.testValue,
        Geometry.multiPoint(.testValue),
        LineString.testValue1,
        Geometry.lineString(.testValue1),
        MultiLineString.testValue,
        Geometry.multiLineString(.testValue),
        Polygon.LinearRing.testValueHole1,
        Polygon.testValueWithHole,
        Geometry.polygon(.testValueWithHole),
        MultiPolygon.testValue,
        Geometry.multiPolygon(.testValue),
        GeometryCollection.testValue,
        GeometryCollection.testValueWithRecursion,
        Geometry.geometryCollection(.testValue)]

    func testDifferencePolygons() {
        let poly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0.5, 0),
            XY(1.5, 0),
            XY(1.5, 1),
            XY(0.5, 1),
            XY(0.5, 0)]))
        let expectedPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(1, 0),
            XY(1.5, 0),
            XY(1.5, 1),
            XY(1, 1),
            XY(1, 0)]))
        XCTAssertEqual(try? poly.difference(with: unitPoly)?.isTopologicallyEquivalent(to: expectedPoly),
                       true)
    }

    func testDifferenceAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.difference(with: g2)
            } catch {
                XCTFail("Unexpected error for \(g1) difference(with: \(g2)) \(error)")
            }
        }
    }
}
