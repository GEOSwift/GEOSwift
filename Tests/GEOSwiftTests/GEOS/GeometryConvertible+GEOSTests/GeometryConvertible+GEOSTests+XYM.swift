import XCTest
import GEOSwift

// MARK: - Test Value Extensions for XYM

private extension Point where C == XYM {
    static let testValue1 = Point(XYM(1, 2, 0))
    static let testValue3 = Point(XYM(3, 4, 1))
    static let testValue5 = Point(XYM(5, 6, 2))
    static let testValue7 = Point(XYM(7, 8, 3))
}

private extension LineString where C == XYM {
    static let testValue1 = try! LineString(coordinates: [
        Point<XYM>.testValue1.coordinates,
        Point<XYM>.testValue3.coordinates
    ])
    static let testValue5 = try! LineString(coordinates: [
        Point<XYM>.testValue5.coordinates,
        Point<XYM>.testValue7.coordinates
    ])
}

private extension Polygon.LinearRing where C == XYM {
    // counterclockwise
    static let testValueExterior2 = try! Polygon.LinearRing(coordinates: [
        XYM(2, 2, 0),
        XYM(-2, 2, 0),
        XYM(-2, -2, 0),
        XYM(2, -2, 0),
        XYM(2, 2, 1)])

    // clockwise
    static let testValueHole1 = try! Polygon.LinearRing(coordinates: [
        XYM(1, 1, 0),
        XYM(1, -1, 0),
        XYM(-1, -1, 0),
        XYM(-1, 1, 0),
        XYM(1, 1, 1)])

    // counterclockwise
    static let testValueExterior7 = try! Polygon.LinearRing(coordinates: [
        XYM(7, 2, 0),
        XYM(3, 2, 0),
        XYM(3, -2, 0),
        XYM(7, -2, 0),
        XYM(7, 2, 1)])
}

private extension Polygon where C == XYM {
    static let testValueWithHole = Polygon(
        exterior: Polygon<XYM>.LinearRing.testValueExterior2,
        holes: [Polygon<XYM>.LinearRing.testValueHole1])

    static let testValueWithoutHole = Polygon(
        exterior: Polygon<XYM>.LinearRing.testValueExterior7)
}

private extension MultiPoint where C == XYM {
    static let testValue = MultiPoint(points: [.testValue1, .testValue3])
}

private extension MultiLineString where C == XYM {
    static let testValue = MultiLineString(
        lineStrings: [.testValue1, .testValue5])
}

private extension MultiPolygon where C == XYM {
    static let testValue = MultiPolygon(
        polygons: [.testValueWithHole, .testValueWithoutHole])
}

private extension GeometryCollection where C == XYM {
    static let testValue = GeometryCollection(
        geometries: [
            Point<XYM>.testValue1,
            MultiPoint<XYM>.testValue,
            LineString<XYM>.testValue1,
            MultiLineString<XYM>.testValue,
            Polygon<XYM>.testValueWithHole,
            MultiPolygon<XYM>.testValue])

    static let testValueWithRecursion = GeometryCollection(
        geometries: [GeometryCollection<XYM>.testValue])
}

// MARK: - Tests

final class GeometryConvertible_GEOSTests_XYM: XCTestCase {
    let lineString0 = try! LineString(coordinates: Array(repeating: XYM(0, 0, 0), count: 2))
    let lineString1 = try! LineString(coordinates: [
        XYM(0, 0, 0),
        XYM(1, 0, 1)])
    let lineString2 = try! LineString(coordinates: [
        XYM(0, 0, 0),
        XYM(1, 0, 1),
        XYM(1, 1, 2)])
    let multiLineString0 = MultiLineString<XYM>(lineStrings: [])
    lazy var multiLineString1 = MultiLineString(lineStrings: [lineString1])
    lazy var multiLineString2 = MultiLineString(lineStrings: [lineString1, lineString2])
    let linearRing0 = try! Polygon.LinearRing(coordinates: Array(repeating: XYM(0, 0, 0), count: 4))
    let linearRing1 = try! Polygon.LinearRing(coordinates: [
        XYM(0, 0, 0),
        XYM(1, 0, 1),
        XYM(1, 1, 2),
        XYM(0, 1, 3),
        XYM(0, 0, 4)])
    lazy var collection = GeometryCollection(
        geometries: [
            Point<XYM>.testValue1,
            MultiPoint<XYM>.testValue,
            lineString1,
            multiLineString1,
            Polygon<XYM>.testValueWithoutHole,
            MultiPolygon<XYM>.testValue])
    lazy var recursiveCollection = GeometryCollection(
        geometries: [collection])
    let geometryConvertibles: [any GeometryConvertible<XYM>] = [
        Point<XYM>.testValue1,
        Geometry.point(Point<XYM>.testValue1),
        MultiPoint<XYM>.testValue,
        Geometry.multiPoint(MultiPoint<XYM>.testValue),
        LineString<XYM>.testValue1,
        Geometry.lineString(LineString<XYM>.testValue1),
        MultiLineString<XYM>.testValue,
        Geometry.multiLineString(MultiLineString<XYM>.testValue),
        Polygon<XYM>.LinearRing.testValueHole1,
        Polygon<XYM>.testValueWithHole,
        Geometry.polygon(Polygon<XYM>.testValueWithHole),
        MultiPolygon<XYM>.testValue,
        Geometry.multiPolygon(MultiPolygon<XYM>.testValue),
        GeometryCollection<XYM>.testValue,
        GeometryCollection<XYM>.testValueWithRecursion,
        Geometry.geometryCollection(GeometryCollection<XYM>.testValue)]
    let unitPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
        XYM(0, 0, 0),
        XYM(1, 0, 1),
        XYM(1, 1, 2),
        XYM(0, 1, 3),
        XYM(0, 0, 4)]))

    // MARK: - Misc Functions

    // points have length 0
    func testLength_Points() {
        XCTAssertEqual(try? Point<XYM>.testValue1.length(), 0)
        XCTAssertEqual(try? MultiPoint<XYM>.testValue.length(), 0)
        XCTAssertEqual(try? Geometry.point(Point<XYM>.testValue1).length(), 0)
        XCTAssertEqual(try? Geometry.multiPoint(MultiPoint<XYM>.testValue).length(), 0)
    }

    // lines have lengths
    func testLength_Lines() {
        XCTAssertEqual(try? lineString0.length(), 0)
        XCTAssertEqual(try? lineString1.length(), 1)
        XCTAssertEqual(try? lineString2.length(), 2)
        XCTAssertEqual(try? multiLineString0.length(), 0)
        XCTAssertEqual(try? multiLineString1.length(), 1)
        XCTAssertEqual(try? multiLineString2.length(), 3)
        XCTAssertEqual(try? linearRing0.length(), 0)
        XCTAssertEqual(try? linearRing1.length(), 4)
        XCTAssertEqual(try? Geometry.lineString(lineString0).length(), 0)
        XCTAssertEqual(try? Geometry.lineString(lineString1).length(), 1)
        XCTAssertEqual(try? Geometry.lineString(lineString2).length(), 2)
        XCTAssertEqual(try? Geometry.multiLineString(multiLineString0).length(), 0)
        XCTAssertEqual(try? Geometry.multiLineString(multiLineString1).length(), 1)
        XCTAssertEqual(try? Geometry.multiLineString(multiLineString2).length(), 3)
    }

    // Polygon lengths equal the sum of their exterior & interior ring lengths
    func testLength_Polygons() {
        XCTAssertEqual(try? Polygon<XYM>.testValueWithoutHole.length(), 16)
        XCTAssertEqual(try? Polygon<XYM>.testValueWithHole.length(), 24)
        XCTAssertEqual(try? MultiPolygon<XYM>.testValue.length(), 40)
        XCTAssertEqual(try? Geometry.polygon(Polygon<XYM>.testValueWithoutHole).length(), 16)
        XCTAssertEqual(try? Geometry.polygon(Polygon<XYM>.testValueWithHole).length(), 24)
        XCTAssertEqual(try? Geometry.multiPolygon(MultiPolygon<XYM>.testValue).length(), 40)
    }

    // Geometry Collection length is equal to the sum of the elements' lengths
    func testLength_Collections() {
        XCTAssertEqual(try? collection.length(), 58)
        XCTAssertEqual(try? recursiveCollection.length(), 58)
        XCTAssertEqual(try? Geometry.geometryCollection(collection).length(), 58)
        XCTAssertEqual(try? Geometry.geometryCollection(recursiveCollection).length(), 58)
    }

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

    func testAreaOfPolygon() {
        XCTAssertEqual(try? unitPoly.area(), 1)
    }

    func testAreaAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.area()
            } catch {
                XCTFail("Unexpected error for \(g) area() \(error)")
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

    // MARK: - Unary Predicates

    func testIsEmpty() {
        var collection = GeometryCollection<XYM>(geometries: [])

        XCTAssertTrue(try collection.isEmpty())

        collection.geometries += [.point(.testValue1)]

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
        var lineString = LineString(linearRing1)

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

    // MARK: - Binary Predicates

    func testIsTopologicallyEquivalentBetweenPoints() {
        let point1 = Point(XYM(1, 1, 1))
        let point2 = Point(XYM(2, 2, 2))
        let point3 = Point(XYM(2, 2, 1))
        XCTAssertEqual(try? point1.isTopologicallyEquivalent(to: point1), true)
        XCTAssertEqual(try? point1.isTopologicallyEquivalent(to: point2), false)

        // M coordinates not taken into account in topographical equivalence
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

    func testIsDisjointBetweenPoints() {
        let point1 = Point(XYM(1, 1, 1))
        let point2 = Point(XYM(2, 2, 2))
        let point3 = Point(XYM(2, 2, 1))
        XCTAssertEqual(try? point1.isDisjoint(with: point1), false)
        XCTAssertEqual(try? point1.isDisjoint(with: point2), true)

        // M coordinates not taken into account in topological tests
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

    func testTouchesPointsAndPolygon() {
        let point05 = Point(XYM(0.5, 0.5, 0))
        let point1 = Point(XYM(1, 1, 0))
        let point2 = Point(XYM(2, 2, 2))
        XCTAssertEqual(try? point05.touches(unitPoly), false)
        XCTAssertEqual(try? point1.touches(unitPoly), true)

        // M coordinates not taken into account in topological tests
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

    func testIntersectsBetweenPoints() {
        let point1 = Point(XYM(1, 1, 1))
        let point2 = Point(XYM(2, 2, 2))
        let point3 = Point(XYM(2, 2, 1))
        XCTAssertEqual(try? point1.intersects(point1), true)
        XCTAssertEqual(try? point1.intersects(point2), false)

        // M coordinates not taken into account in topological tests
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

    func testCrossesBetweenLineStrings() {
        let horizontalLine = try! LineString(coordinates: [XYM(-1, 0, 1), XYM(1, 0, 2)])
        let verticalLine = try! LineString(coordinates: [XYM(0, -1, 0), XYM(0, 1, 1)])
        let otherVerticalLine = try! LineString(coordinates: [XYM(2, -1, 0), XYM(2, 1, 1)])
        XCTAssertEqual(try? horizontalLine.crosses(verticalLine), true)

        // M coordinates not taken into account in topological tests
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

    func testIsWithinPolygonAndPoints() {
        let point05 = Point(XYM(0.5, 0.5, 0))
        let point1 = Point(XYM(1, 1, 0))
        let point2 = Point(XYM(2, 2, 2))

        // M coordinates not taken into account in topological tests
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

    func testContainsPolygonAndPoints() {
        let point05 = Point(XYM(0.5, 0.5, 0))
        let point1 = Point(XYM(1, 1, 0))
        let point2 = Point(XYM(2, 2, 2))

        // M coordinates not taken into account in topological tests
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

    func testOverlapsLines() {
        let line1 = try! LineString(coordinates: [XYM(0, 0, 0), XYM(1, 0, 1)])
        let line2 = try! LineString(coordinates: [XYM(0.5, 0, 2), XYM(1.5, 0, 3)])
        let line3 = try! LineString(coordinates: [XYM(0, 0, 4), XYM(0.5, 0, 5)])

        // M coordinates not taken into account in topological tests
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

    func testCoversPointsAndPolygon() {
        let point05 = Point(XYM(0.5, 0.5, 0.5))
        let point1 = Point(XYM(1, 1, 1))
        let point2 = Point(XYM(2, 2, 2))

        // M coordinates not taken into account in topological tests
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

    func testIsCoveredByPointsAndPolygon() {
        let point05 = Point(XYM(0.5, 0.5, 0.5))
        let point1 = Point(XYM(1, 1, 1))
        let point2 = Point(XYM(2, 2, 2))

        // M coordinates not taken into account in topological tests
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

    // MARK: - Prepared Geometry

    func testMakePreparedAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.makePrepared()
            } catch {
                XCTFail("Unexpected error for \(g) makePrepared() \(error)")
            }
        }
    }

    // MARK: - Dimensionally Extended 9 Intersection Model Functions

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

    // MARK: - Topology Operations

    func testNormalizedMultiLineString() {
        let multiLineString = try! MultiLineString(
            lineStrings: [
                LineString(
                    coordinates: [
                        XYM(0, 1, 0),
                        XYM(2, 3, 1)]),
                LineString(
                    coordinates: [
                        XYM(4, 5, 2),
                        XYM(6, 7, 3)])]).geometry
        let expected = try! MultiLineString(
            lineStrings: [
                LineString(
                    coordinates: [
                        XYM(4, 5, 2),
                        XYM(6, 7, 3)]),
                LineString(
                    coordinates: [
                        XYM(0, 1, 0),
                        XYM(2, 3, 1)])]).geometry

        XCTAssertEqual(try multiLineString.normalized(), expected)
    }

    func testNormalizedAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.normalized()
            } catch {
                XCTFail("Unexpected error for \(g) normalized() \(error)")
            }
        }
    }

    func testEnvelopeWhenItIsAPolygon() {
        let poly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(1, 0, 0),
            XYM(0, 1, 1),
            XYM(-1, 0, 2),
            XYM(0, -1, 3),
            XYM(1, 0, 0)]))
        let expectedEnvelope = Envelope(minX: -1, maxX: 1, minY: -1, maxY: 1)

        // Envelope operations don't take into account M
        XCTAssertEqual(try? poly.envelope(), expectedEnvelope)
    }

    func testEnvelopeWhenItIsAPoint() {
        let expectedEnvelope = Envelope(minX: 1, maxX: 1, minY: 2, maxY: 2)

        // Envelope operations don't take into account M
        XCTAssertEqual(try? Point<XYM>.testValue1.envelope(), expectedEnvelope)
    }

    func testEnvelopeAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.envelope()
            } catch {
                XCTFail("Unexpected error for \(g) envelope() \(error)")
            }
        }
    }

    func testIntersectionBetweenLineAndPoly() {
        let line = try! LineString(coordinates: [
            XYM(-1, 2, 0),
            XYM(2, -1, 1)])
        let expectedLine = try! LineString(coordinates: [
            XY(0, 1),
            XY(1, 0)])

        // Topological operations currently only return XY geometry
        XCTAssertEqual(try? unitPoly.intersection(with: line), expectedLine.geometry)
    }

    func testIntersectionAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.intersection(with: g2)
            } catch {
                XCTFail("Unexpected error for \(g1) intersection(with: \(g2)) \(error)")
            }
        }
    }

    func testConvexHullPolygon() {
        let polygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0, 0, 0),
            XYM(1, 0, 1),
            XYM(0.1, 0.1, 2),
            XYM(0, 1, 3),
            XYM(0, 0, 0)]))
        // not sure why the result's shell is cw instead of ccw; need to follow up with GEOS team
        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 0),
            XY(0, 1),
            XY(1, 0),
            XY(0, 0)]))

        // Convex Hull returns XY geometry
        XCTAssertEqual(try? polygon.convexHull(), expectedPolygon.geometry)
    }

    func testConvexHullAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.convexHull()
            } catch {
                XCTFail("Unexpected error for \(g) convexHull() \(error)")
            }
        }
    }

    func testConcaveHullAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.concaveHull(withRatio: .random(in: 0...1), allowHoles: .random())
            } catch {
                XCTFail("Unexpected error for \(g) convexHull() \(error)")
            }
        }
    }

    func testMinimumRotatedRectangleLineAndPoint() {
        let line = try! LineString(coordinates: [
            XYM(0, 1, 0),
            XYM(1, 0, 1),
            XYM(2, 1, 2)])
        let point = Point(XYM(1, 2, 3))
        let collection = GeometryCollection(geometries: [line, point])
        let expectedRectangle = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0, 1, 0),
            XYM(1, 0, 1),
            XYM(2, 1, 2),
            XYM(1, 2, 3),
            XYM(0, 1, 0)]))

        // Minimum rotated rectangle returns XY, topological test is XY only
        XCTAssertEqual(try? collection.minimumRotatedRectangle()
            .isTopologicallyEquivalent(to: expectedRectangle), true)
    }

    func testMinimumRotatedRectangleAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.minimumRotatedRectangle()
            } catch {
                XCTFail("Unexpected error for \(g) minimumRotatedRectangle() \(error)")
            }
        }
    }

    func testMinimumWidthLine() {
        let line = try! LineString(coordinates: [
            XYM(0, 0, 0),
            XYM(1, 1, 1),
            XYM(0, 2, 2)])
        let expectedLine = try! LineString(coordinates: [
            XY(0, 1),
            XY(1, 1)])

        // Minimum width line is XY only
        XCTAssertEqual(try? line.minimumWidth(), expectedLine)
    }

    func testMinimumWidthAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.minimumWidth()
            } catch {
                XCTFail("Unexpected error for \(g) minimumWidth() \(error)")
            }
        }
    }

    func testDifferencePolygons() {
        let poly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0.5, 0, 0),
            XYM(1.5, 0, 1),
            XYM(1.5, 1, 2),
            XYM(0.5, 1, 3),
            XYM(0.5, 0, 0)]))
        let expectedPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(1, 0, 0),
            XYM(1.5, 0, 1),
            XYM(1.5, 1, 2),
            XYM(1, 1, 3),
            XYM(1, 0, 0)]))

        // Difference returns only XY geometry and topological tests are XY only
        XCTAssertEqual(try? poly.difference(with: unitPoly)?.isTopologicallyEquivalent(to: expectedPoly),
                       true)
    }

    func testDifferenceAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.difference(with: g2)
            } catch {
                XCTFail("Unexpected error for \(g1) difference(with: \(g2)) \(error)")
            }
        }
    }

    func testSymmetricDifferencePolygons() throws {
        let poly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0.5, 0, 0),
            XYM(1.5, 0, 1),
            XYM(1.5, 1, 2),
            XYM(0.5, 1, 3),
            XYM(0.5, 0, 0)]))
        let expected = try! MultiPolygon(polygons: [
            Polygon(exterior: Polygon.LinearRing(coordinates: [
                XYM(1, 0, 0),
                XYM(1.5, 0, 1),
                XYM(1.5, 1, 2),
                XYM(1, 1, 3),
                XYM(1, 0, 0)])),
            Polygon(exterior: Polygon.LinearRing(coordinates: [
                XYM(0, 0, 0),
                XYM(0.5, 0, 1),
                XYM(0.5, 1, 2),
                XYM(0, 1, 3),
                XYM(0, 0, 0)]))])

        let result = try XCTUnwrap(poly.symmetricDifference(with: unitPoly))

        // Symmetric difference returns XY geometry and topological equivalence only tests XY
        XCTAssertTrue(try result.isTopologicallyEquivalent(to: expected))
    }

    func testSymmetricDifferenceAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            XCTAssertNoThrow(try g1.symmetricDifference(with: g2))
        }
    }

    func testUnionPointAndLine() {
        let point = Point(x: 2, y: 0)
        let pointWithM = Point(XYM(2, 0, 7))

        // Topological operations only return XY geometries.
        let expected = Geometry.geometryCollection(GeometryCollection(geometries: [LineString<XY>(lineString1), point]))

        XCTAssertEqual(try? lineString1.union(with: pointWithM), expected)
    }

    func testUnionTwoPolygons() {
        let unitPoly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(1, 0, 0),
            XYM(2, 0, 1),
            XYM(2, 1, 2),
            XYM(1, 1, 3),
            XYM(1, 0, 0)]))
        let expected = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0, 0, 0),
            XYM(2, 0, 1),
            XYM(2, 1, 2),
            XYM(0, 1, 3),
            XYM(0, 0, 0)]))

        // Union produces XY geometry and topological equivalence only tests XY geometry
        XCTAssertEqual(try? unitPoly.union(with: unitPoly2).isTopologicallyEquivalent(to: expected), true)
    }

    func testUnionAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.union(with: g2)
            } catch {
                XCTFail("Unexpected error for \(g1) union(with: \(g2)) \(error)")
            }
        }
    }

    func testUnaryUnionCollectionOfTwoPolygons() {
        let unitPoly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(1, 0, 0),
            XYM(2, 0, 1),
            XYM(2, 1, 2),
            XYM(1, 1, 3),
            XYM(1, 0, 0)]))
        let collection = GeometryCollection(geometries: [unitPoly, unitPoly2])
        let expected = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0, 0, 0),
            XYM(2, 0, 1),
            XYM(2, 1, 2),
            XYM(0, 1, 3),
            XYM(0, 0, 0)]))

        // Topological equivalence only tests XY
        XCTAssertEqual(try? collection.unaryUnion().isTopologicallyEquivalent(to: expected), true)
    }

    func testUnaryUnionAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.unaryUnion()
            } catch {
                XCTFail("Unexpected error for \(g) unaryUnion() \(error)")
            }
        }
    }

    func testPointOnSurfacePolygon() {
        let point = try? unitPoly.pointOnSurface()
        let expected = Point(x: 0.5, y: 0.5)

        // Point on surface gives XY points
        XCTAssertEqual(point, expected)
    }

    func testPointOnSurfaceAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.pointOnSurface()
            } catch {
                XCTFail("Unexpected error for \(g) pointOnSurface() \(error)")
            }
        }
    }

    func testCentroidPolygon() {
        let point = try? unitPoly.centroid()
        let expected = Point(x: 0.5, y: 0.5)

        // Centroid gives XY points
        XCTAssertEqual(point, expected)
    }

    func testCentroidAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.centroid()
            } catch {
                XCTFail("Unexpected error for \(g) centroid() \(error)")
            }
        }
    }

    func testMinimumBoundingCircleLineString() {
        let expected = Circle(center: Point(x: 0.5, y: 0), radius: 0.5)

        // Minimum bounding circle is XY geometry
        XCTAssertEqual(try lineString1.minimumBoundingCircle(), expected)
    }

    func testMinimumBoundingCircleAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.minimumBoundingCircle()
            } catch {
                XCTFail("Unexpected error for \(g) minimumBoundingCircle() \(error)")
            }
        }
    }

    func testPolygonizeAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.polygonize()
            } catch {
                XCTFail("Unexpected error for \(g) polygonize() \(error)")
            }
        }
    }

    func testPolygonize() {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XYM(0, 0, 0), XYM(1, 0, 1)]),
            LineString(coordinates: [XYM(1, 0, 2), XYM(0, 1, 3)]),
            LineString(coordinates: [XYM(0, 1, 4), XYM(0, 0, 0)])])

        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0, 0, 0), XYM(1, 0, 1), XYM(0, 1, 2), XYM(0, 0, 0)]))

        // Topological equivalence only checks XY geometry
        XCTAssertTrue(try multiLineString.polygonize().isTopologicallyEquivalent(to: expectedPolygon))
    }

    func testPolygonizeEmptyArray() {
        XCTAssertEqual(try [Geometry<XYM>]().polygonize(), GeometryCollection(geometries: []))
    }

    func testPolygonizeArray() {
        let lineStrings = try! [
            LineString(coordinates: [XYM(0, 0, 0), XYM(1, 0, 1)]),
            LineString(coordinates: [XYM(1, 0, 2), XYM(0, 1, 3)]),
            LineString(coordinates: [XYM(0, 1, 4), XYM(0, 0, 0)])]

        // Topological equivalence only checks XY geometry
        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0, 0, 0), XYM(1, 0, 1), XYM(0, 1, 2), XYM(0, 0, 0)]))

        XCTAssertTrue(try lineStrings.polygonize().isTopologicallyEquivalent(to: expectedPolygon))
    }

    func testLineMerge() {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XYM(0, 0, 1), XYM(1, 0, 4)]),
            LineString(coordinates: [XYM(1, 0, 2), XYM(0, 1, 5)]),
            LineString(coordinates: [XYM(0, 0, 3), XYM(2, 1, 6)])])

        let expectedLineString = try! LineString(coordinates: [
            XY(2, 1),
            XY(0, 0),
            XY(1, 0),
            XY(0, 1)])

        let expected = Geometry.lineString(expectedLineString)

        // Line merge produces only XY geometry
        XCTAssertEqual(try multiLineString.lineMerge(), expected)
    }

    func testLineMergeDirected() {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XYM(0, 0, 1), XYM(1, 0, 4)]),
            LineString(coordinates: [XYM(1, 0, 2), XYM(0, 1, 5)]),
            LineString(coordinates: [XYM(0, 0, 3), XYM(2, 1, 6)])])

        let expectedMultiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XY(0, 0), XY(1, 0), XY(0, 1)]),
            LineString(coordinates: [XY(0, 0), XY(2, 1)])])

        let expected = Geometry.multiLineString(expectedMultiLineString)

        // Line merge produces only XY geometry
        XCTAssertEqual(try multiLineString.lineMergeDirected(), expected)
    }

    // MARK: - Buffer Functions

    func testBufferAllTypes() {
        for geometry in geometryConvertibles {
            do {
                _ = try geometry.buffer(by: 0.5)
            } catch {
                XCTFail("Unexpected error for \(geometry) buffer(by: 0.5) \(error)")
            }
        }
    }

    func testNegativeBufferWidthWithNonNilResult() throws {
        let expectedGeometry = try Geometry.polygon(Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYM(6, 1, 0),
                XYM(4, 1, 1),
                XYM(4, -1, 2),
                XYM(6, -1, 3),
                XYM(6, 1, 0)])))

        let actualGeometry = try Polygon<XYM>.testValueWithoutHole.buffer(by: -1)

        // Polygonize produces XY geometry and topological equivalence just checks XY geometry
        try XCTAssertTrue(actualGeometry?.isTopologicallyEquivalent(to: expectedGeometry) ?? false)
    }

    func testNegativeBufferWidthWithNilResult() throws {
        try XCTAssertNil(Point<XYM>.testValue1.buffer(by: -1))
    }

    func testBufferWithStyleAllTypes() {
        for geometry in geometryConvertibles {
            do {
                _ = try geometry.bufferWithStyle(width: 0.5)
            } catch {
                XCTFail("Unexpected error for \(geometry) bufferWithStyle(width: 0.5) \(error)")
            }
        }
    }

    func testNegativeBufferWithStyleWidthWithNonNilResult() throws {
        let expectedGeometry = try Geometry.polygon(Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYM(6, 1, 0),
                XYM(4, 1, 1),
                XYM(4, -1, 2),
                XYM(6, -1, 3),
                XYM(6, 1, 0)])))

        let actualGeometry = try Polygon<XY>.testValueWithoutHole.bufferWithStyle(width: -1)

        // Topological equivalence only checks XY
        try XCTAssertTrue(actualGeometry?.isTopologicallyEquivalent(to: expectedGeometry) ?? false)
    }

    func testBufferWithStyleWithFlatEndCap() throws {
        let expectedGeometry = try Geometry.polygon(Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYM(1, 1, 0),
                XYM(1, -1, 1),
                XYM(0, -1, 2),
                XYM(0, 1, 3),
                XYM(1, 1, 0)])))

        let actualGeometry = try lineString1.bufferWithStyle(width: 1, endCapStyle: .flat)

        try XCTAssertTrue(actualGeometry?.isTopologicallyEquivalent(to: expectedGeometry) ?? false)
    }

    func testBufferWithStyleNegativeBufferWidthWithNilResult() throws {
        try XCTAssertNil(Point<XYM>.testValue1.bufferWithStyle(width: -1))
    }

    func testOffsetCurve() throws {
        let lineString = try LineString(coordinates: [
            XYM(0, 0, 0),
            XYM(10, 0, 1),
            XYM(10, 10, 2)])

        let expextedLineString = try LineString(coordinates: [
            XY(0, 5),
            XY(5, 5),
            XY(5, 10)])

        let actualGeometry = try lineString.offsetCurve(width: 5, joinStyle: .bevel)

        let expected = Geometry.lineString(expextedLineString)

        // Offset curve produces XY geometry
        XCTAssertEqual(actualGeometry, expected)
    }

    func testOffsetCurveWithNegativeWidth() throws {
        let lineString = try LineString(coordinates: [
            XYM(0, 0, 0),
            XYM(10, 0, 1),
            XYM(10, 10, 2)])

        let expextedLineString = try LineString(coordinates: [
            XY(0, -5),
            XY(10, -5),
            XY(15, 0),
            XY(15, 10)])

        let actualGeometry = try lineString.offsetCurve(width: -5, joinStyle: .bevel)

        // Offset curve produces XY geometry
        XCTAssertTrue(try actualGeometry?.isTopologicallyEquivalent(to: expextedLineString) == true)
    }

    // MARK: - Simplify Functions

    func testSimplifyAllTypes() {
        for geometry in geometryConvertibles {
            do {
                _ = try geometry.simplify(withTolerance: 0.01)
            } catch {
                XCTFail("Unexpected error for \(geometry) simplify(withTolerance: 0.01) \(error)")
            }
        }
    }

    // MARK: - Snapping

    func testSnapAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.snap(to: g2, tolerance: 1)
            } catch {
                XCTFail("Unexpected error for \(g1) snap(to: \(g2), tolerance: 1) \(error)")
            }
        }
    }
}
