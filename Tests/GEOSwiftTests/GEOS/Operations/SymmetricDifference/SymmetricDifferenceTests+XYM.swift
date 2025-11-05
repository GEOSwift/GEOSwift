import XCTest
import GEOSwift

// MARK: - Tests

final class SymmetricDifferenceTests_XYM: OperationsTestCase_XYM {

    func testSymmetricDifferencePolygons() throws {
        let poly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0.5, 0, 0),
            XYM(1.5, 0, 1),
            XYM(1.5, 1, 2),
            XYM(0.5, 1, 3),
            XYM(0.5, 0, 0)]))
        let expected = try! MultiPolygon(polygons: [
            Polygon(exterior: Polygon.LinearRing(coordinates: [
                XYM(1, 0, 0),
                XYM(1.5, 0, 1),
                XYM(1.5, 1, 2),
                XYM(1, 1, 3),
                XYM(1, 0, 0)])),
            Polygon(exterior: Polygon.LinearRing(coordinates: [
                XYM(0, 0, 0),
                XYM(0.5, 0, 1),
                XYM(0.5, 1, 2),
                XYM(0, 1, 3),
                XYM(0, 0, 0)]))])

        // Symmetric difference returns only XY geometry and topological tests are XY only
        XCTAssertEqual(try? poly.symmetricDifference(with: unitPoly)?.isTopologicallyEquivalent(to: expected),
                       true)
    }

    func testSymmetricDifferenceAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.symmetricDifference(with: g2)
            } catch {
                XCTFail("Unexpected error for \(g1) symmetricDifference(with: \(g2)) \(error)")
            }
        }
    }
}
