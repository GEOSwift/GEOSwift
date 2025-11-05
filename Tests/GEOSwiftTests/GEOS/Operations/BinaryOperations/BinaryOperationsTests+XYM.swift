import XCTest
import GEOSwift

// MARK: - Tests

final class BinaryOperationsTests_XYM: XCTestCase {
    // Convert XYZM fixtures to XYM using copy constructors
    let point1 = Point<XYM>(Fixtures.point1)
    let point3 = Point<XYM>(Fixtures.point3)
    let lineString1 = LineString<XYM>(Fixtures.lineString1)
    let linearRingHole1 = Polygon<XYM>.LinearRing(Fixtures.linearRingHole1)
    let polygonWithHole = Polygon<XYM>(Fixtures.polygonWithHole)
    let multiPoint = MultiPoint<XYM>(Fixtures.multiPoint)
    let multiLineString = MultiLineString<XYM>(Fixtures.multiLineString)
    let multiPolygon = MultiPolygon<XYM>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XYM>(Fixtures.geometryCollection)
    let recursiveGeometryCollection = GeometryCollection<XYM>(Fixtures.recursiveGeometryCollection)
    let unitPoly = Polygon<XYM>(Fixtures.unitPolygon)

    // Geometry convertibles array needs to be converted element-by-element
    lazy var geometryConvertibles: [any GeometryConvertible<XYM>] = [
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
        Geometry.geometryCollection(geometryCollection)
    ]

    func testDistanceBetweenPoints() {
        let point1 = Point(XYM(0, 0, 0))
        let point2 = Point(XYM(10, 0, 10))
        XCTAssertEqual(try? point1.distance(to: point2), 10)
        XCTAssertEqual(try? point2.distance(to: point1), 10)
    }

    func testDistanceAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.distance(to: g2)
            } catch {
                XCTFail("Unexpected error for \(g1) distance(to: \(g2)) \(error)")
            }
        }
    }

    func testHausdorffDistance() {
        let point1 = Point(XYM(0, 0, 0))
        let point2 = Point(XYM(10, 0, 10))
        XCTAssertEqual(try? point1.hausdorffDistance(to: point2), 10)
        XCTAssertEqual(try? point2.hausdorffDistance(to: point1), 10)
    }

    func testHausdorffDistanceAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.hausdorffDistance(to: g2)
            } catch {
                XCTFail("Unexpected error for \(g1) hausdorffDistance(to: \(g2)) \(error)")
            }
        }
    }

    func testHausdorffDistanceDensify() {
        let point1 = Point(XYM(0, 0, 0))
        let point2 = Point(XYM(10, 0, 10))
        let densifyFraction = Double(0.5)
        XCTAssertEqual(try? point1.hausdorffDistanceDensify(to: point2, densifyFraction: densifyFraction), 10)
        XCTAssertEqual(try? point2.hausdorffDistanceDensify(to: point1, densifyFraction: densifyFraction), 10)
    }

    func testHausdorffDistanceDensifyAllPairs() {
        let densifyFraction = Double(0.1)
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.hausdorffDistanceDensify(to: g2, densifyFraction: densifyFraction)
            } catch {
                XCTFail("Unexpected error for \(g1) hausdorffDensifyDistance(to: \(g2)) \(error)")
            }
        }
    }

    func testNearestPointsBetweenPolygonAndLine() {
        let line = try! LineString(coordinates: [XYM(1, 3, 0), XYM(3, 1, 1)])
        let expected = [Point(x: 1, y: 1), Point(x: 2, y: 2)]
        XCTAssertEqual(try? unitPoly.nearestPoints(with: line), expected)
    }

    func testNearestPointsAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.nearestPoints(with: g2)
            } catch {
                XCTFail("Unexpected error for \(g1) distance(to: \(g2)) \(error)")
            }
        }
    }
}
