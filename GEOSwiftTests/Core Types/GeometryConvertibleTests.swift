import XCTest
import GEOSwift

final class GeometryConvertibleTests: XCTestCase {
    func testPointGeometry() {
        XCTAssertEqual(Point.testValue1.geometry, .point(.testValue1))
    }

    func testMultiPointGeometry() {
        XCTAssertEqual(MultiPoint.testValue.geometry, .multiPoint(.testValue))
    }

    func testLineStringGeometry() {
        XCTAssertEqual(LineString.testValue1.geometry, .lineString(.testValue1))
    }

    func testMultiLineStringGeometry() {
        XCTAssertEqual(MultiLineString.testValue.geometry, .multiLineString(.testValue))
    }

    func testPolygon_LinearRingGeometry() {
        XCTAssertEqual(
            Polygon.LinearRing.testValueHole1.geometry,
            .lineString(LineString(Polygon.LinearRing.testValueHole1)))
    }

    func testPolygonGeometry() {
        XCTAssertEqual(Polygon.testValueWithHole.geometry, .polygon(.testValueWithHole))
    }

    func testMultiPolygonGeometry() {
        XCTAssertEqual(MultiPolygon.testValue.geometry, .multiPolygon(.testValue))
    }

    func testGeometryCollectionGeometry() {
        XCTAssertEqual(GeometryCollection.testValue.geometry, .geometryCollection(.testValue))
    }

    func testGeometryGeometry() {
        let geometries: [Geometry] = [
            .point(.testValue1),
            .multiPoint(.testValue),
            .lineString(.testValue1),
            .multiLineString(.testValue),
            .polygon(.testValueWithHole),
            .multiPolygon(.testValue),
            .geometryCollection(.testValue)]
        for geometry in geometries {
            XCTAssertEqual(geometry.geometry, geometry)
        }
    }
}
