import XCTest
import GEOSwift

final class PolygonizeTests: XCTestCase {
    // Convert XYZM fixtures to XY using copy constructors
    let point1 = Point<XY>(Fixtures.point1)
    let multiPoint = MultiPoint<XY>(Fixtures.multiPoint)
    let lineString1 = LineString<XY>(Fixtures.lineString1)
    let multiLineString = MultiLineString<XY>(Fixtures.multiLineString)
    let linearRingHole1 = Polygon<XY>.LinearRing(Fixtures.linearRingHole1)
    let polygonWithHole = Polygon<XY>(Fixtures.polygonWithHole)
    let multiPolygon = MultiPolygon<XY>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XY>(Fixtures.geometryCollection)
    let recursiveGeometryCollection = GeometryCollection<XY>(Fixtures.recursiveGeometryCollection)

    lazy var geometryConvertibles: [any GeometryConvertible<XY>] = [
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
        recursiveGeometryCollection,
        Geometry.geometryCollection(geometryCollection)]

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
            LineString(coordinates: [XY(0, 0), XY(1, 0)]),
            LineString(coordinates: [XY(1, 0), XY(0, 1)]),
            LineString(coordinates: [XY(0, 1), XY(0, 0)])])

        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 0), XY(1, 0), XY(0, 1), XY(0, 0)]))

        XCTAssertTrue(try multiLineString.polygonize().isTopologicallyEquivalent(to: expectedPolygon))
    }

    func testPolygonizeEmptyArray() {
        XCTAssertEqual(try [Geometry<XY>]().polygonize(), GeometryCollection(geometries: []))
    }

    func testPolygonizeArray() {
        let lineStrings = try! [
            LineString(coordinates: [XY(0, 0), XY(1, 0)]),
            LineString(coordinates: [XY(1, 0), XY(0, 1)]),
            LineString(coordinates: [XY(0, 1), XY(0, 0)])]

        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 0), XY(1, 0), XY(0, 1), XY(0, 0)]))

        XCTAssertTrue(try lineStrings.polygonize().isTopologicallyEquivalent(to: expectedPolygon))
    }
}
