import XCTest
import GEOSwift

final class GeometryConvertibleTests: XCTestCase {
    // Convert XYZM fixtures to XY using copy constructors
    let point1 = Point<XY>(Fixtures.point1)
    let multiPoint = MultiPoint<XY>(Fixtures.multiPoint)
    let lineString1 = LineString<XY>(Fixtures.lineString1)
    let multiLineString = MultiLineString<XY>(Fixtures.multiLineString)
    let linearRingHole1 = Polygon<XY>.LinearRing(Fixtures.linearRingHole1)
    let polygonWithHole = Polygon<XY>(Fixtures.polygonWithHole)
    let multiPolygon = MultiPolygon<XY>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XY>(Fixtures.geometryCollection)

    func testPointGeometry() {
        XCTAssertEqual(point1.geometry, .point(point1))
    }

    func testMultiPointGeometry() {
        XCTAssertEqual(multiPoint.geometry, .multiPoint(multiPoint))
    }

    func testLineStringGeometry() {
        XCTAssertEqual(lineString1.geometry, .lineString(lineString1))
    }

    func testMultiLineStringGeometry() {
        XCTAssertEqual(multiLineString.geometry, .multiLineString(multiLineString))
    }

    func testPolygon_LinearRingGeometry() {
        XCTAssertEqual(
            linearRingHole1.geometry,
            .lineString(LineString(linearRingHole1)))
    }

    func testPolygonGeometry() {
        XCTAssertEqual(polygonWithHole.geometry, .polygon(polygonWithHole))
    }

    func testMultiPolygonGeometry() {
        XCTAssertEqual(multiPolygon.geometry, .multiPolygon(multiPolygon))
    }

    func testGeometryCollectionGeometry() {
        XCTAssertEqual(geometryCollection.geometry, .geometryCollection(geometryCollection))
    }

    func testGeometryGeometry() {
        let geometries: [Geometry<XY>] = [
            .point(point1),
            .multiPoint(multiPoint),
            .lineString(lineString1),
            .multiLineString(multiLineString),
            .polygon(polygonWithHole),
            .multiPolygon(multiPolygon),
            .geometryCollection(geometryCollection)]
        for geometry in geometries {
            XCTAssertEqual(geometry.geometry, geometry)
        }
    }
}
