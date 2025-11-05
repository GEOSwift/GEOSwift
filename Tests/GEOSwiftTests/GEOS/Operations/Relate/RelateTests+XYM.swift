import XCTest
import GEOSwift

final class RelateTests_XYM: XCTestCase {
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

    func testRelateMaskBetweenPoints() {
        let point1 = Point(XYM(1, 1, 1))
        let point2 = Point(XYM(2, 2, 2))

        // M coordinates not taken into account in topological tests
        // Test using the mask-version of isTopologicallyEquivalent(to:)
        XCTAssertEqual(try? point1.relate(point1, mask: "T*F**FFF*"), true)
        XCTAssertEqual(try? point1.relate(point2, mask: "T*F**FFF*"), false)
    }

    func testRelateInvalidMask() {
        let point1 = Point(XYM(1, 1, 1))

        // M coordinates not taken into account in topological tests
        // Test using the mask-version of isTopologicallyEquivalent(to:)
        do {
            _ = try point1.relate(point1, mask: "abcd")
            XCTFail("Expected relate to throw due to invalid query")
        } catch GEOSError.libraryError {
            // PASS
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testRelateMaskAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.relate(g2, mask: "T*F**FFF*")
            } catch {
                XCTFail("Unexpected error for \(g1) relate(\(g2), mask:) \(error)")
            }
        }
    }

    func testRelateBetweenPoints() {
        let point1 = Point(XYM(1, 1, 1))
        let point2 = Point(XYM(2, 2, 2))

        // M coordinates not taken into account in topological tests
        XCTAssertEqual(try? point1.relate(point1), "0FFFFFFF2")
        XCTAssertEqual(try? point1.relate(point2), "FF0FFF0F2")
    }

    func testRelateAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.relate(g2)
            } catch {
                XCTFail("Unexpected error for \(g1) relate(\(g2)) \(error)")
            }
        }
    }
}
