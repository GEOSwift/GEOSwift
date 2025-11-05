import XCTest
import GEOSwift

final class BinaryPredicatesTests: XCTestCase {
    // Convert XYZM fixtures to XY using copy constructors
    let point1 = Point<XY>(Fixtures.point1)
    let lineString1 = LineString<XY>(Fixtures.lineString1)
    let linearRingHole1 = Polygon<XY>.LinearRing(Fixtures.linearRingHole1)
    let polygonWithHole = Polygon<XY>(Fixtures.polygonWithHole)
    let multiPoint = MultiPoint<XY>(Fixtures.multiPoint)
    let multiLineString = MultiLineString<XY>(Fixtures.multiLineString)
    let multiPolygon = MultiPolygon<XY>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XY>(Fixtures.geometryCollection)
    let recursiveGeometryCollection = GeometryCollection<XY>(Fixtures.recursiveGeometryCollection)
    let unitPoly = Polygon<XY>(Fixtures.unitPolygon)

    // Geometry convertibles array needs to be converted element-by-element
    lazy var geometryConvertibles: [any GeometryConvertible<XY>] = [
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

    // MARK: - isTopologicallyEquivalent

    func testIsTopologicallyEquivalentBetweenPoints() {
        let point1 = Point(x: 1, y: 1)
        let point2 = Point(x: 2, y: 2)
        XCTAssertEqual(try? point1.isTopologicallyEquivalent(to: point1), true)
        XCTAssertEqual(try? point1.isTopologicallyEquivalent(to: point2), false)
    }

    func testIsTopologicallyEquivalentAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.isTopologicallyEquivalent(to: g2)
            } catch {
                XCTFail("Unexpected error for \(g1) isSpatiallyEquivalent(to: \(g2)) \(error)")
            }
        }
    }

    // MARK: - isDisjoint

    func testIsDisjointBetweenPoints() {
        let point1 = Point(x: 1, y: 1)
        let point2 = Point(x: 2, y: 2)
        XCTAssertEqual(try? point1.isDisjoint(with: point1), false)
        XCTAssertEqual(try? point1.isDisjoint(with: point2), true)
    }

    func testIsDisjointAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.isDisjoint(with: g2)
            } catch {
                XCTFail("Unexpected error for \(g1) isDisjoint(with: \(g2)) \(error)")
            }
        }
    }

    // MARK: - touches

    func testTouchesPointsAndPolygon() {
        let point05 = Point(x: 0.5, y: 0.5)
        let point1 = Point(x: 1, y: 1)
        let point2 = Point(x: 2, y: 2)
        XCTAssertEqual(try? point05.touches(unitPoly), false)
        XCTAssertEqual(try? point1.touches(unitPoly), true)
        XCTAssertEqual(try? point2.touches(unitPoly), false)
    }

    func testTouchesAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.touches(g2)
            } catch {
                XCTFail("Unexpected error for \(g1) touches(\(g2)) \(error)")
            }
        }
    }

    // MARK: - intersects

    func testIntersectsBetweenPoints() {
        let point1 = Point(x: 1, y: 1)
        let point2 = Point(x: 2, y: 2)
        XCTAssertEqual(try? point1.intersects(point1), true)
        XCTAssertEqual(try? point1.intersects(point2), false)
    }

    func testIntersectsAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.intersects(g2)
            } catch {
                XCTFail("Unexpected error for \(g1) intersects(\(g2)) \(error)")
            }
        }
    }

    // MARK: - crosses

    func testCrossesBetweenLineStrings() {
        let horizontalLine = try! LineString(coordinates: [XY(-1, 0), XY(1, 0)])
        let verticalLine = try! LineString(coordinates: [XY(0, -1), XY(0, 1)])
        let otherVerticalLine = try! LineString(coordinates: [XY(2, -1), XY(2, 1)])
        XCTAssertEqual(try? horizontalLine.crosses(verticalLine), true)
        XCTAssertEqual(try? horizontalLine.crosses(otherVerticalLine), false)
    }

    func testCrossesAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.crosses(g2)
            } catch {
                XCTFail("Unexpected error for \(g1) crosses(\(g2)) \(error)")
            }
        }
    }

    // MARK: - isWithin

    func testIsWithinPolygonAndPoints() {
        let point05 = Point(x: 0.5, y: 0.5)
        let point1 = Point(x: 1, y: 1)
        let point2 = Point(x: 2, y: 2)
        XCTAssertEqual(try? point05.isWithin(unitPoly), true)
        XCTAssertEqual(try? point1.isWithin(unitPoly), false)
        XCTAssertEqual(try? point2.isWithin(unitPoly), false)
    }

    func testIsWithinAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.isWithin(g2)
            } catch {
                XCTFail("Unexpected error for \(g1) isWithin(\(g2)) \(error)")
            }
        }
    }

    // MARK: - contains

    func testContainsPolygonAndPoints() {
        let point05 = Point(x: 0.5, y: 0.5)
        let point1 = Point(x: 1, y: 1)
        let point2 = Point(x: 2, y: 2)
        XCTAssertEqual(try? unitPoly.contains(point05), true)
        XCTAssertEqual(try? unitPoly.contains(point1), false)
        XCTAssertEqual(try? unitPoly.contains(point2), false)
    }

    func testContainsAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.contains(g2)
            } catch {
                XCTFail("Unexpected error for \(g1) contains(\(g2)) \(error)")
            }
        }
    }

    // MARK: - overlaps

    func testOverlapsLines() {
        let line1 = try! LineString(coordinates: [XY(0, 0), XY(1, 0)])
        let line2 = try! LineString(coordinates: [XY(0.5, 0), XY(1.5, 0)])
        let line3 = try! LineString(coordinates: [XY(0, 0), XY(0.5, 0)])
        XCTAssertEqual(try? line1.overlaps(line2), true)
        XCTAssertEqual(try? line2.overlaps(line1), true)
        XCTAssertEqual(try? line1.overlaps(line3), false)
        XCTAssertEqual(try? line3.overlaps(line1), false)
        XCTAssertEqual(try? line2.overlaps(line3), false)
        XCTAssertEqual(try? line3.overlaps(line2), false)
    }

    func testOverlapsAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.overlaps(g2)
            } catch {
                XCTFail("Unexpected error for \(g1) overlaps(\(g2)) \(error)")
            }
        }
    }

    // MARK: - covers

    func testCoversPointsAndPolygon() {
        let point05 = Point(x: 0.5, y: 0.5)
        let point1 = Point(x: 1, y: 1)
        let point2 = Point(x: 2, y: 2)
        XCTAssertEqual(try? unitPoly.covers(point05), true)
        XCTAssertEqual(try? unitPoly.covers(point1), true)
        XCTAssertEqual(try? unitPoly.covers(point2), false)
    }

    func testCoversAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.covers(g2)
            } catch {
                XCTFail("Unexpected error for \(g1) covers(\(g2)) \(error)")
            }
        }
    }

    // MARK: - isCovered

    func testIsCoveredByPointsAndPolygon() {
        let point05 = Point(x: 0.5, y: 0.5)
        let point1 = Point(x: 1, y: 1)
        let point2 = Point(x: 2, y: 2)
        XCTAssertEqual(try? point05.isCovered(by: unitPoly), true)
        XCTAssertEqual(try? point1.isCovered(by: unitPoly), true)
        XCTAssertEqual(try? point2.isCovered(by: unitPoly), false)
    }

    func testIsCoveredByAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.isCovered(by: g2)
            } catch {
                XCTFail("Unexpected error for \(g1) isCovered(by: \(g2)) \(error)")
            }
        }
    }
}
