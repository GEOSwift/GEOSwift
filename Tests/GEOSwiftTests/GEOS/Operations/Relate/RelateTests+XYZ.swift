import XCTest
import GEOSwift

final class RelateTests_XYZ: XCTestCase {
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

    func testRelateMaskBetweenPoints() {
        let point1 = Point(XYZ(1, 1, 1))
        let point2 = Point(XYZ(2, 2, 2))

        // Z coordinates not taken into account in topological tests
        // Test using the mask-version of isTopologicallyEquivalent(to:)
        XCTAssertEqual(try? point1.relate(point1, mask: "T*F**FFF*"), true)
        XCTAssertEqual(try? point1.relate(point2, mask: "T*F**FFF*"), false)
    }

    func testRelateInvalidMask() {
        let point1 = Point(XYZ(1, 1, 1))

        // Z coordinates not taken into account in topological tests
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
        let point1 = Point(XYZ(1, 1, 1))
        let point2 = Point(XYZ(2, 2, 2))

        // Z coordinates not taken into account in topological tests
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
