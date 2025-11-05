import XCTest
import GEOSwift

final class SimplifyTests: GEOSTestCase_XY {
    func testSimplifyLineString() throws {
        let lineString = try! LineString(coordinates: [
            XY(0, 0), XY(1, 0.1), XY(2, -0.1), XY(3, 0)])

        let simplified = try lineString.simplify(withTolerance: 0.5)

        // With high tolerance, should simplify to fewer points
        switch simplified {
        case let .lineString(ls):
            XCTAssertLessThan(ls.coordinates.count, lineString.coordinates.count)
        default:
            XCTFail("Expected LineString result")
        }
    }

    func testSimplifyPolygon() throws {
        let ring = try! Polygon.LinearRing(coordinates: [
            XY(0, 0), XY(1, 0), XY(1, 1), XY(0, 1), XY(0, 0)])
        let polygon = Polygon(exterior: ring)

        let simplified = try polygon.simplify(withTolerance: 0.01)

        // Simple square should remain similar with low tolerance
        switch simplified {
        case .polygon:
            // Success - polygon simplified
            break
        default:
            XCTFail("Expected Polygon result")
        }
    }
}
