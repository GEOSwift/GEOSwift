import XCTest
import GEOSwift

final class PreparedTests_XYZ: XCTestCase {
    // Geometry convertibles array needs to be converted element-by-element
    lazy var geometryConvertibles: [any GeometryConvertible<XYZ>] = [
        Point<XYZ>(Fixtures.point1),
        Geometry.point(Point<XYZ>(Fixtures.point1)),
        MultiPoint<XYZ>(Fixtures.multiPoint),
        Geometry.multiPoint(MultiPoint<XYZ>(Fixtures.multiPoint)),
        LineString<XYZ>(Fixtures.lineString1),
        Geometry.lineString(LineString<XYZ>(Fixtures.lineString1)),
        MultiLineString<XYZ>(Fixtures.multiLineString),
        Geometry.multiLineString(MultiLineString<XYZ>(Fixtures.multiLineString)),
        Polygon<XYZ>.LinearRing(Fixtures.linearRingHole1),
        Polygon<XYZ>(Fixtures.polygonWithHole),
        Geometry.polygon(Polygon<XYZ>(Fixtures.polygonWithHole)),
        MultiPolygon<XYZ>(Fixtures.multiPolygon),
        Geometry.multiPolygon(MultiPolygon<XYZ>(Fixtures.multiPolygon)),
        GeometryCollection<XYZ>(Fixtures.geometryCollection),
        GeometryCollection<XYZ>(Fixtures.recursiveGeometryCollection),
        Geometry.geometryCollection(GeometryCollection<XYZ>(Fixtures.geometryCollection))
    ]

    func testMakePreparedAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.makePrepared()
            } catch {
                XCTFail("Unexpected error for \(g) makePrepared() \(error)")
            }
        }
    }
}
