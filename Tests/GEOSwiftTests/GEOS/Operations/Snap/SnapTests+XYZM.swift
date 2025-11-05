import XCTest
import GEOSwift

final class SnapTestsXYZM: GEOSTestCase_XYZM {
    func testSnapLineStrings() throws {
        let line1 = try! LineString(coordinates: [XYZM(0, 0, 10, 1), XYZM(10, 0, 20, 2)])
        let line2 = try! LineString(coordinates: [XYZM(0, 0.5, 15, 3), XYZM(10, 0, 25, 4)])

        let snapped = try line1.snap(to: line2, tolerance: 1.0)

        // Snap preserves Z coordinates but drops M for XYZM geometry
        switch snapped {
        case .lineString:
            // Success
            break
        default:
            XCTFail("Expected LineString result")
        }
    }

    func testSnapPolygonToPoint() throws {
        let ring = try! Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 10, 1), XYZM(10, 0, 20, 2), XYZM(10, 10, 30, 3),
            XYZM(0, 10, 40, 4), XYZM(0, 0, 10, 1)])
        let polygon = Polygon(exterior: ring)
        let point = Point(XYZM(0, 0.5, 15, 5))

        let snapped = try polygon.snap(to: point, tolerance: 1.0)

        // Snap preserves Z coordinates but drops M for XYZM geometry
        switch snapped {
        case .polygon:
            // Success
            break
        default:
            XCTFail("Expected Polygon result")
        }
    }

    func testSnapPreservesZ() throws {
        let line1 = try! LineString(coordinates: [XYZM(0, 0, 100, 1), XYZM(10, 0, 200, 2)])
        let line2 = try! LineString(coordinates: [XYZM(0, 0.5, 150, 3), XYZM(10, 0, 250, 4)])

        let snapped = try line1.snap(to: line2, tolerance: 1.0)

        switch snapped {
        case let .lineString(ls):
            for coord in ls.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected LineString result")
        }
    }

    func testSnapZCoordinateValues() throws {
        let line1 = try! LineString(coordinates: [
            XYZM(0, 0, 100, 1), XYZM(5, 0, 150, 2), XYZM(10, 0, 200, 3)])
        let line2 = try! LineString(coordinates: [XYZM(0, 0.1, 110, 4), XYZM(10, 0.1, 210, 5)])

        let snapped = try line1.snap(to: line2, tolerance: 1.0)

        switch snapped {
        case let .lineString(ls):
            // Verify Z coordinates are preserved (M dropped)
            for coord in ls.coordinates {
                XCTAssertGreaterThanOrEqual(coord.z, 100)
                XCTAssertLessThanOrEqual(coord.z, 210)
            }
        default:
            XCTFail("Expected LineString result")
        }
    }

    func testSnapPolygonPreservesZ() throws {
        let ring = try! Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 100, 1), XYZM(10, 0, 200, 2), XYZM(10, 10, 300, 3),
            XYZM(0, 10, 400, 4), XYZM(0, 0, 100, 1)])
        let polygon = Polygon(exterior: ring)
        let point = Point(XYZM(0, 0.5, 150, 5))

        let snapped = try polygon.snap(to: point, tolerance: 1.0)

        switch snapped {
        case let .polygon(p):
            for coord in p.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected Polygon result")
        }
    }
}
