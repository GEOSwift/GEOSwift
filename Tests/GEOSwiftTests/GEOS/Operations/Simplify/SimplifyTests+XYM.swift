import XCTest
import GEOSwift

final class SimplifyTestsXYM: OperationsTestCase_XYM {
    func testSimplifyLineString() throws {
        let lineString = try! LineString(coordinates: [
            XYM(0, 0, 1), XYM(1, 0.1, 2), XYM(2, -0.1, 3), XYM(3, 0, 4)])

        let simplified = try lineString.simplify(withTolerance: 0.5)

        // Simplify drops M coordinates and produces XY geometry
        switch simplified {
        case let .lineString(ls):
            XCTAssertLessThan(ls.coordinates.count, lineString.coordinates.count)
        default:
            XCTFail("Expected LineString result")
        }
    }

    func testSimplifyPolygon() throws {
        let ring = try! Polygon.LinearRing(coordinates: [
            XYM(0, 0, 1), XYM(1, 0, 2), XYM(1, 1, 3), XYM(0, 1, 4), XYM(0, 0, 1)])
        let polygon = Polygon(exterior: ring)

        let simplified = try polygon.simplify(withTolerance: 0.01)

        // Simplify drops M coordinates and produces XY geometry
        switch simplified {
        case .polygon:
            // Success - polygon simplified
            break
        default:
            XCTFail("Expected Polygon result")
        }
    }
}
