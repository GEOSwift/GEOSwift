import XCTest
import GEOSwift

// MARK: - Tests

final class BinaryPredicatesTests_XYZM: GEOSTestCase_XYZM {

    // MARK: - isTopologicallyEquivalent

    func testIsTopologicallyEquivalentBetweenPoints() {
        let point1 = Point(XYZM(1, 1, 1, 1))
        let point2 = Point(XYZM(2, 2, 2, 2))
        let point3 = Point(XYZM(2, 2, 1, 1))
        XCTAssertEqual(try? point1.isTopologicallyEquivalent(to: point1), true)
        XCTAssertEqual(try? point1.isTopologicallyEquivalent(to: point2), false)

        // Z and M coordinates not taken into account in topographical equivalence
        XCTAssertEqual(try? point2.isTopologicallyEquivalent(to: point3), true)
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
        let point1 = Point(XYZM(1, 1, 1, 1))
        let point2 = Point(XYZM(2, 2, 2, 2))
        let point3 = Point(XYZM(2, 2, 1, 1))
        XCTAssertEqual(try? point1.isDisjoint(with: point1), false)
        XCTAssertEqual(try? point1.isDisjoint(with: point2), true)

        // Z and M coordinates not taken into account in topographical equivalence
        XCTAssertEqual(try? point2.isDisjoint(with: point3), false)
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
        let point05 = Point(XYZM(0.5, 0.5, 0, 0))
        let point1 = Point(XYZM(1, 1, 0, 0))
        let point2 = Point(XYZM(2, 2, 2, 2))
        XCTAssertEqual(try? point05.touches(unitPoly), false)
        XCTAssertEqual(try? point1.touches(unitPoly), true)

        // Z and M coordinates not taken into account in topographical equivalence
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
        let point1 = Point(XYZM(1, 1, 1, 1))
        let point2 = Point(XYZM(2, 2, 2, 2))
        let point3 = Point(XYZM(2, 2, 1, 1))
        XCTAssertEqual(try? point1.intersects(point1), true)
        XCTAssertEqual(try? point1.intersects(point2), false)

        // Z and M coordinates not taken into account in topographical equivalence
        XCTAssertEqual(try? point2.intersects(point3), true)
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
        let horizontalLine = try! LineString(coordinates: [XYZM(-1, 0, 1, 1), XYZM(1, 0, 2, 2)])
        let verticalLine = try! LineString(coordinates: [XYZM(0, -1, 0, 0), XYZM(0, 1, 0, 1)])
        let otherVerticalLine = try! LineString(coordinates: [XYZM(2, -1, 0, 0), XYZM(2, 1, 0, 1)])
        XCTAssertEqual(try? horizontalLine.crosses(verticalLine), true)

        // Z and M coordinates not taken into account in topographical equivalence
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
        let point05 = Point(XYZM(0.5, 0.5, 0, 0))
        let point1 = Point(XYZM(1, 1, 0, 0))
        let point2 = Point(XYZM(2, 2, 2, 2))

        // Z and M coordinates not taken into account in topological tests
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
        let point05 = Point(XYZM(0.5, 0.5, 0, 0))
        let point1 = Point(XYZM(1, 1, 0, 0))
        let point2 = Point(XYZM(2, 2, 2, 2))

        // Z and M coordinates not taken into account in topological tests
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
        let line1 = try! LineString(coordinates: [XYZM(0, 0, 1, 0), XYZM(1, 0, 2, 1)])
        let line2 = try! LineString(coordinates: [XYZM(0.5, 0, 3, 2), XYZM(1.5, 0, 4, 3)])
        let line3 = try! LineString(coordinates: [XYZM(0, 0, 5, 4), XYZM(0.5, 0, 6, 5)])

        // Z and M coordinates not taken into account in topological tests
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
        let point05 = Point(XYZM(0.5, 0.5, 0.5, 0.5))
        let point1 = Point(XYZM(1, 1, 1, 1))
        let point2 = Point(XYZM(2, 2, 2, 2))

        // Z and M coordinates not taken into account in topological tests
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
        let point05 = Point(XYZM(0.5, 0.5, 0.5, 0.5))
        let point1 = Point(XYZM(1, 1, 1, 1))
        let point2 = Point(XYZM(2, 2, 2, 2))

        // Z and M coordinates not taken into account in topological tests
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
