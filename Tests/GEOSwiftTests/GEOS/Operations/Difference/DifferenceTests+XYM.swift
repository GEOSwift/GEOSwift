import XCTest
import GEOSwift

// MARK: - Tests

final class DifferenceTests_XYM: GEOSTestCase_XYM {

    func testDifferencePolygons() {
        let poly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0.5, 0, 0),
            XYM(1.5, 0, 1),
            XYM(1.5, 1, 2),
            XYM(0.5, 1, 3),
            XYM(0.5, 0, 0)]))
        let expectedPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(1, 0, 0),
            XYM(1.5, 0, 1),
            XYM(1.5, 1, 2),
            XYM(1, 1, 3),
            XYM(1, 0, 0)]))

        // Difference returns only XY geometry and topological tests are XY only
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
