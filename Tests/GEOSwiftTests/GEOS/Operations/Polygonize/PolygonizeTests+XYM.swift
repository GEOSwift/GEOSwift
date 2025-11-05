import XCTest
import GEOSwift

// MARK: - Tests

final class PolygonizeTests_XYM: XCTestCase {
    // Convert XYZM fixtures to XYM using copy constructors
    let point1 = Point<XYM>(Fixtures.point1)
    let multiPoint = MultiPoint<XYM>(Fixtures.multiPoint)
    let lineString1 = LineString<XYM>(Fixtures.lineString1)
    let multiLineString = MultiLineString<XYM>(Fixtures.multiLineString)
    let linearRingHole1 = Polygon<XYM>.LinearRing(Fixtures.linearRingHole1)
    let polygonWithHole = Polygon<XYM>(Fixtures.polygonWithHole)
    let multiPolygon = MultiPolygon<XYM>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XYM>(Fixtures.geometryCollection)

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
