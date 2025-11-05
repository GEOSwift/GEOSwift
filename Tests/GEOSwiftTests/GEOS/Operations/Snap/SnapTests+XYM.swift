import XCTest
import GEOSwift

final class SnapTestsXYM: OperationsTestCase_XYM {
    func testSnapLineStrings() throws {
        let line1 = try! LineString(coordinates: [XYM(0, 0, 1), XYM(10, 0, 2)])
        let line2 = try! LineString(coordinates: [XYM(0, 0.5, 3), XYM(10, 0, 4)])

        let snapped = try line1.snap(to: line2, tolerance: 1.0)

        // Snap drops M coordinates and produces XY geometry
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
            XYM(0, 0, 1), XYM(10, 0, 2), XYM(10, 10, 3), XYM(0, 10, 4), XYM(0, 0, 1)])
        let polygon = Polygon(exterior: ring)
        let point = Point(XYM(0, 0.5, 5))

        let snapped = try polygon.snap(to: point, tolerance: 1.0)

        // Snap drops M coordinates and produces XY geometry
        switch snapped {
        case .polygon:
            // Success
            break
        default:
            XCTFail("Expected Polygon result")
        }
    }
}
