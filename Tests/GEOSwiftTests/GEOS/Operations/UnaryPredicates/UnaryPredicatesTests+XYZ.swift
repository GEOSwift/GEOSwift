import XCTest
import GEOSwift

final class UnaryPredicatesTests_XYZ: XCTestCase {
    // Convert XYZM fixtures to XYZ using copy constructors
    let linearRingHole1 = Polygon<XYZ>.LinearRing(Fixtures.linearRingHole1)

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

    // MARK: - Unary Predicates

    func testIsEmpty() {
        var collection = GeometryCollection<XYZ>(geometries: [])

        XCTAssertTrue(try collection.isEmpty())

        collection.geometries += [Geometry.point(Point(XYZ(1, 2, 0)))]

        XCTAssertFalse(try collection.isEmpty())
    }

    func testIsEmptyAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.isEmpty()
            } catch {
                XCTFail("Unexpected error for \(g) isEmpty() \(error)")
            }
        }
    }

    func testIsRing() {
        var lineString = LineString(linearRingHole1)

        XCTAssertTrue(try lineString.isRing())

        lineString = try! LineString(coordinates: lineString.coordinates.dropLast())

        XCTAssertFalse(try lineString.isRing())
    }

    func testIsRingAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.isRing()
            } catch {
                XCTFail("Unexpected error for \(g) isRing() \(error)")
            }
        }
    }
}
