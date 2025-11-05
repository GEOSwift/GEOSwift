import XCTest
import GEOSwift

final class PreparedTests_XYM: XCTestCase {
    // Geometry convertibles array needs to be converted element-by-element
    lazy var geometryConvertibles: [any GeometryConvertible<XYM>] = [
        Point<XYM>(Fixtures.point1),
        Geometry.point(Point<XYM>(Fixtures.point1)),
        MultiPoint<XYM>(Fixtures.multiPoint),
        Geometry.multiPoint(MultiPoint<XYM>(Fixtures.multiPoint)),
        LineString<XYM>(Fixtures.lineString1),
        Geometry.lineString(LineString<XYM>(Fixtures.lineString1)),
        MultiLineString<XYM>(Fixtures.multiLineString),
        Geometry.multiLineString(MultiLineString<XYM>(Fixtures.multiLineString)),
        Polygon<XYM>.LinearRing(Fixtures.linearRingHole1),
        Polygon<XYM>(Fixtures.polygonWithHole),
        Geometry.polygon(Polygon<XYM>(Fixtures.polygonWithHole)),
        MultiPolygon<XYM>(Fixtures.multiPolygon),
        Geometry.multiPolygon(MultiPolygon<XYM>(Fixtures.multiPolygon)),
        GeometryCollection<XYM>(Fixtures.geometryCollection),
        GeometryCollection<XYM>(Fixtures.recursiveGeometryCollection),
        Geometry.geometryCollection(GeometryCollection<XYM>(Fixtures.geometryCollection))
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
