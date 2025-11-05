import XCTest
import GEOSwift

// MARK: - Tests

final class PolygonizeTests_XYM: OperationsTestCase_XYM {

    func testPolygonizeAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.polygonize()
            } catch {
                XCTFail("Unexpected error for \(g) polygonize() \(error)")
            }
        }
    }

    func testPolygonize() {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XYM(0, 0, 0), XYM(1, 0, 1)]),
            LineString(coordinates: [XYM(1, 0, 2), XYM(0, 1, 3)]),
            LineString(coordinates: [XYM(0, 1, 4), XYM(0, 0, 0)])])

        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0, 0, 0), XYM(1, 0, 1), XYM(0, 1, 2), XYM(0, 0, 0)]))

        // Polygonize returns only XY geometry and topological equivalence only tests XY
        XCTAssertTrue(try multiLineString.polygonize().isTopologicallyEquivalent(to: expectedPolygon))
    }

    func testPolygonizeEmptyArray() {
        XCTAssertEqual(try [Geometry<XYM>]().polygonize(), GeometryCollection(geometries: []))
    }

    func testPolygonizeArray() {
        let lineStrings = try! [
            LineString(coordinates: [XYM(0, 0, 0), XYM(1, 0, 1)]),
            LineString(coordinates: [XYM(1, 0, 2), XYM(0, 1, 3)]),
            LineString(coordinates: [XYM(0, 1, 4), XYM(0, 0, 0)])]

        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0, 0, 0), XYM(1, 0, 1), XYM(0, 1, 2), XYM(0, 0, 0)]))

        // Polygonize returns only XY geometry and topological equivalence only tests XY
        XCTAssertTrue(try lineStrings.polygonize().isTopologicallyEquivalent(to: expectedPolygon))
    }
}
