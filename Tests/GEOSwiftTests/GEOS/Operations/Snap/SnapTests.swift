import XCTest
import GEOSwift

final class SnapTests: XCTestCase {
    func testSnapLineStrings() throws {
        let line1 = try! LineString(coordinates: [XY(0, 0), XY(10, 0)])
        let line2 = try! LineString(coordinates: [XY(0, 0.5), XY(10, 0)])

        let snapped = try line1.snap(to: line2, tolerance: 1.0)

        // Verify result is a LineString
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
            XY(0, 0), XY(10, 0), XY(10, 10), XY(0, 10), XY(0, 0)])
        let polygon = Polygon(exterior: ring)
        let point = Point(XY(0, 0.5))

        let snapped = try polygon.snap(to: point, tolerance: 1.0)

        // Verify result is a Polygon
        switch snapped {
        case .polygon:
            // Success
            break
        default:
            XCTFail("Expected Polygon result")
        }
    }
}
