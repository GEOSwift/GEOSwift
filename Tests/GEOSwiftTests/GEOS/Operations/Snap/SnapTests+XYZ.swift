import XCTest
import GEOSwift

final class SnapTestsXYZ: OperationsTestCase_XYZ {
    func testSnapLineStrings() throws {
        let line1 = try! LineString(coordinates: [XYZ(0, 0, 10), XYZ(10, 0, 20)])
        let line2 = try! LineString(coordinates: [XYZ(0, 0.5, 15), XYZ(10, 0, 25)])

        let snapped = try line1.snap(to: line2, tolerance: 1.0)

        // Snap preserves Z coordinates for XYZ geometry
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
            XYZ(0, 0, 10), XYZ(10, 0, 20), XYZ(10, 10, 30), XYZ(0, 10, 40), XYZ(0, 0, 10)])
        let polygon = Polygon(exterior: ring)
        let point = Point(XYZ(0, 0.5, 15))

        let snapped = try polygon.snap(to: point, tolerance: 1.0)

        // Snap preserves Z coordinates for XYZ geometry
        switch snapped {
        case .polygon:
            // Success
            break
        default:
            XCTFail("Expected Polygon result")
        }
    }

    func testSnapPreservesZ() throws {
        let line1 = try! LineString(coordinates: [XYZ(0, 0, 100), XYZ(10, 0, 200)])
        let line2 = try! LineString(coordinates: [XYZ(0, 0.5, 150), XYZ(10, 0, 250)])

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
        let line1 = try! LineString(coordinates: [XYZ(0, 0, 100), XYZ(5, 0, 150), XYZ(10, 0, 200)])
        let line2 = try! LineString(coordinates: [XYZ(0, 0.1, 110), XYZ(10, 0.1, 210)])

        let snapped = try line1.snap(to: line2, tolerance: 1.0)

        switch snapped {
        case let .lineString(ls):
            // Verify Z coordinates are preserved
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
            XYZ(0, 0, 100), XYZ(10, 0, 200), XYZ(10, 10, 300), XYZ(0, 10, 400), XYZ(0, 0, 100)])
        let polygon = Polygon(exterior: ring)
        let point = Point(XYZ(0, 0.5, 150))

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
