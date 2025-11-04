import XCTest
import GEOSwift

final class SimplifyTestsXYZM: XCTestCase {
    func testSimplifyLineString() throws {
        let lineString = try! LineString(coordinates: [
            XYZM(0, 0, 10, 1), XYZM(1, 0.1, 20, 2), XYZM(2, -0.1, 30, 3), XYZM(3, 0, 40, 4)])

        let simplified = try lineString.simplify(withTolerance: 0.5)

        // Simplify preserves Z coordinates but drops M for XYZM geometry
        switch simplified {
        case let .lineString(ls):
            XCTAssertLessThan(ls.coordinates.count, lineString.coordinates.count)
        default:
            XCTFail("Expected LineString result")
        }
    }

    func testSimplifyPolygon() throws {
        let ring = try! Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 10, 1), XYZM(1, 0, 20, 2), XYZM(1, 1, 30, 3), XYZM(0, 1, 40, 4), XYZM(0, 0, 10, 1)])
        let polygon = Polygon(exterior: ring)

        let simplified = try polygon.simplify(withTolerance: 0.01)

        // Simplify preserves Z coordinates but drops M for XYZM geometry
        switch simplified {
        case .polygon:
            // Success - polygon simplified
            break
        default:
            XCTFail("Expected Polygon result")
        }
    }

    func testSimplifyPreservesZ() throws {
        let lineString = try! LineString(coordinates: [
            XYZM(0, 0, 100, 1), XYZM(1, 0, 200, 2), XYZM(2, 0, 300, 3), XYZM(3, 0, 400, 4)])

        let simplified = try lineString.simplify(withTolerance: 0.01)

        switch simplified {
        case let .lineString(ls):
            for coord in ls.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected LineString result")
        }
    }

    func testSimplifyZCoordinateValues() throws {
        let lineString = try! LineString(coordinates: [
            XYZM(0, 0, 100, 1), XYZM(1, 0, 200, 2), XYZM(2, 0, 300, 3)])

        let simplified = try lineString.simplify(withTolerance: 0.01)

        switch simplified {
        case let .lineString(ls):
            // Verify Z coordinates are preserved (M dropped)
            for coord in ls.coordinates {
                XCTAssertGreaterThanOrEqual(coord.z, 100)
                XCTAssertLessThanOrEqual(coord.z, 300)
            }
        default:
            XCTFail("Expected LineString result")
        }
    }

    func testSimplifyPolygonPreservesZ() throws {
        let ring = try! Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 10, 1), XYZM(10, 0, 20, 2), XYZM(10, 10, 30, 3), XYZM(0, 10, 40, 4), XYZM(0, 0, 10, 1)])
        let polygon = Polygon(exterior: ring)

        let simplified = try polygon.simplify(withTolerance: 0.5)

        switch simplified {
        case let .polygon(p):
            for coord in p.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected Polygon result")
        }
    }
}
