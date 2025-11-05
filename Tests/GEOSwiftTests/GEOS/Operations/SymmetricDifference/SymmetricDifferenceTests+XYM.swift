import XCTest
import GEOSwift

// MARK: - Tests

final class SymmetricDifferenceTests_XYM: XCTestCase {
    // Convert XYZM fixtures to XYM using copy constructors
    let point1 = Point<XYM>(Fixtures.point1)
    let multiPoint = MultiPoint<XYM>(Fixtures.multiPoint)
    let lineString1 = LineString<XYM>(Fixtures.lineString1)
    let multiLineString = MultiLineString<XYM>(Fixtures.multiLineString)
    let linearRingHole1 = Polygon<XYM>.LinearRing(Fixtures.linearRingHole1)
    let polygonWithHole = Polygon<XYM>(Fixtures.polygonWithHole)
    let multiPolygon = MultiPolygon<XYM>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XYM>(Fixtures.geometryCollection)
    let unitPoly = Polygon<XYM>(Fixtures.unitPolygon)

    lazy var geometryConvertibles: [any GeometryConvertible<XYM>] = [
        point1,
        Geometry.point(point1),
        multiPoint,
        Geometry.multiPoint(multiPoint),
        lineString1,
        Geometry.lineString(lineString1),
        multiLineString,
        Geometry.multiLineString(multiLineString),
        linearRingHole1,
        polygonWithHole,
        Geometry.polygon(polygonWithHole),
        multiPolygon,
        Geometry.multiPolygon(multiPolygon),
        geometryCollection,
        GeometryCollection<XYM>(Fixtures.recursiveGeometryCollection),
        Geometry.geometryCollection(geometryCollection)
    ]

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
