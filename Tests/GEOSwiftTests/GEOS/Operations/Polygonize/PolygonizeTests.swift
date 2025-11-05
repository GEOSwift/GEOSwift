import XCTest
import GEOSwift

final class PolygonizeTests: GEOSTestCase_XY {

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
