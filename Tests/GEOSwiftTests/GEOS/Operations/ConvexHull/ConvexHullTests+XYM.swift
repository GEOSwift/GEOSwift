import XCTest
import GEOSwift

// MARK: - Tests

final class ConvexHullTests_XYM: GEOSTestCase_XYM {

    func testConvexHullPolygon() {
        let polygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0, 0, 0),
            XYM(1, 0, 1),
            XYM(0.1, 0.1, 2),
            XYM(0, 1, 3),
            XYM(0, 0, 0)]))
        // not sure why the result's shell is cw instead of ccw; need to follow up with GEOS team
        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 0),
            XY(0, 1),
            XY(1, 0),
            XY(0, 0)]))

        // Convex Hull returns XY geometry
        XCTAssertEqual(try? polygon.convexHull(), expectedPolygon.geometry)
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
