import XCTest
import GEOSwift

final class ConvexHullTests: XCTestCase {
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

    func testConvexHullPolygon() {
        let polygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 0),
            XY(1, 0),
            XY(0.1, 0.1),
            XY(0, 1),
            XY(0, 0)]))
        // not sure why the result's shell is cw instead of ccw; need to follow up with GEOS team
        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 0),
            XY(0, 1),
            XY(1, 0),
            XY(0, 0)]))
        XCTAssertEqual(try? polygon.convexHull(), .polygon(expectedPolygon))
    }

    func testConvexHullAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.convexHull()
            } catch {
                XCTFail("Unexpected error for \(g) convexHull() \(error)")
            }
        }
    }
}
