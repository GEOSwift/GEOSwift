import XCTest
import GEOSwift

final class DifferenceTests: GEOSTestCase_XY {

    func testDifferencePolygons() {
        let poly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0.5, 0),
            XY(1.5, 0),
            XY(1.5, 1),
            XY(0.5, 1),
            XY(0.5, 0)]))
        let expectedPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(1, 0),
            XY(1.5, 0),
            XY(1.5, 1),
            XY(1, 1),
            XY(1, 0)]))
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
