import XCTest
import GEOSwift

// MARK: - Tests

final class BinaryOperationsTests_XYZ: XCTestCase {
    // Convert XYZM fixtures to XYZ using copy constructors
    let point1 = Point<XYZ>(Fixtures.point1)
    let point3 = Point<XYZ>(Fixtures.point3)
    let lineString1 = LineString<XYZ>(Fixtures.lineString1)
    let linearRingHole1 = Polygon<XYZ>.LinearRing(Fixtures.linearRingHole1)
    let polygonWithHole = Polygon<XYZ>(Fixtures.polygonWithHole)
    let multiPoint = MultiPoint<XYZ>(Fixtures.multiPoint)
    let multiLineString = MultiLineString<XYZ>(Fixtures.multiLineString)
    let multiPolygon = MultiPolygon<XYZ>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XYZ>(Fixtures.geometryCollection)
    let recursiveGeometryCollection = GeometryCollection<XYZ>(Fixtures.recursiveGeometryCollection)
    let unitPoly = Polygon<XYZ>(Fixtures.unitPolygon)

    // Geometry convertibles array needs to be converted element-by-element
    lazy var geometryConvertibles: [any GeometryConvertible<XYZ>] = [
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
        let point1 = Point(XYZ(0, 0, 0))
        let point2 = Point(XYZ(10, 0, 0))
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
        let point1 = Point(XYZ(0, 0, 0))
        let point2 = Point(XYZ(10, 0, 0))
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
        let point1 = Point(XYZ(0, 0, 0))
        let point2 = Point(XYZ(10, 0, 0))
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
        let line = try! LineString(coordinates: [XYZ(1, 3, 0), XYZ(3, 1, 0)])
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
