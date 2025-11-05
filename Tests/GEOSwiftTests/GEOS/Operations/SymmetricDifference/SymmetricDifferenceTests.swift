import XCTest
import GEOSwift

final class SymmetricDifferenceTests: OperationsTestCase_XY {

    func testSymmetricDifferencePolygons() throws {
        let poly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0.5, 0),
            XY(1.5, 0),
            XY(1.5, 1),
            XY(0.5, 1),
            XY(0.5, 0)]))
        let expected = try! MultiPolygon(polygons: [
            Polygon(exterior: Polygon.LinearRing(coordinates: [
                XY(1, 0),
                XY(1.5, 0),
                XY(1.5, 1),
                XY(1, 1),
                XY(1, 0)])),
            Polygon(exterior: Polygon.LinearRing(coordinates: [
                XY(0, 0),
                XY(0.5, 0),
                XY(0.5, 1),
                XY(0, 1),
                XY(0, 0)]))])
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
