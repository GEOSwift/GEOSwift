import XCTest
import GEOSwift

final class UnaryPredicatesTests_XYM: XCTestCase {
    // Convert XYZM fixtures to XYM using copy constructors
    let linearRingHole1 = Polygon<XYM>.LinearRing(Fixtures.linearRingHole1)

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

    // MARK: - Unary Predicates

    func testIsEmpty() {
        var collection = GeometryCollection<XYM>(geometries: [])

        XCTAssertTrue(try collection.isEmpty())

        collection.geometries += [Geometry.point(Point(XYM(1, 2, 0)))]

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
