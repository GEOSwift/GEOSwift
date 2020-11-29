import XCTest
import GEOSwift

final class GeometryConvertible_GEOSTests: XCTestCase {
    let lineString0 = try! LineString(points: Array(repeating: Point(x: 0, y: 0), count: 2))
    let lineString1 = try! LineString(points: [
        Point(x: 0, y: 0),
        Point(x: 1, y: 0)])
    let lineString2 = try! LineString(points: [
        Point(x: 0, y: 0),
        Point(x: 1, y: 0),
        Point(x: 1, y: 1)])
    let multiLineString0 = MultiLineString(lineStrings: [])
    lazy var multiLineString1 = MultiLineString(lineStrings: [lineString1])
    lazy var multiLineString2 = MultiLineString(lineStrings: [lineString1, lineString2])
    let linearRing0 = try! Polygon.LinearRing(points: Array(repeating: Point(x: 0, y: 0), count: 4))
    let linearRing1 = try! Polygon.LinearRing(points: [
        Point(x: 0, y: 0),
        Point(x: 1, y: 0),
        Point(x: 1, y: 1),
        Point(x: 0, y: 1),
        Point(x: 0, y: 0)])
    lazy var collection = GeometryCollection(
        geometries: [
            Point.testValue1,
            MultiPoint.testValue,
            lineString1,
            multiLineString1,
            Polygon.testValueWithoutHole,
            MultiPolygon.testValue])
    lazy var recursiveCollection = GeometryCollection(
        geometries: [collection])
    let geometryConvertibles: [GeometryConvertible] = [
        Point.testValue1,
        Geometry.point(.testValue1),
        MultiPoint.testValue,
        Geometry.multiPoint(.testValue),
        LineString.testValue1,
        Geometry.lineString(.testValue1),
        MultiLineString.testValue,
        Geometry.multiLineString(.testValue),
        Polygon.LinearRing.testValueHole1,
        Polygon.testValueWithHole,
        Geometry.polygon(.testValueWithHole),
        MultiPolygon.testValue,
        Geometry.multiPolygon(.testValue),
        GeometryCollection.testValue,
        GeometryCollection.testValueWithRecursion,
        Geometry.geometryCollection(.testValue)]
    let unitPoly = try! Polygon(exterior: Polygon.LinearRing(points: [
        Point(x: 0, y: 0),
        Point(x: 1, y: 0),
        Point(x: 1, y: 1),
        Point(x: 0, y: 1),
        Point(x: 0, y: 0)]))

    // MARK: - Misc Functions

    // points have length 0
    func testLength_Points() {
        XCTAssertEqual(try? Point.testValue1.length(), 0)
        XCTAssertEqual(try? MultiPoint.testValue.length(), 0)
        XCTAssertEqual(try? Geometry.point(.testValue1).length(), 0)
        XCTAssertEqual(try? Geometry.multiPoint(.testValue).length(), 0)
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
        XCTAssertEqual(try? Polygon.testValueWithoutHole.length(), 16)
        XCTAssertEqual(try? Polygon.testValueWithHole.length(), 24)
        XCTAssertEqual(try? MultiPolygon.testValue.length(), 40)
        XCTAssertEqual(try? Geometry.polygon(.testValueWithoutHole).length(), 16)
        XCTAssertEqual(try? Geometry.polygon(.testValueWithHole).length(), 24)
        XCTAssertEqual(try? Geometry.multiPolygon(.testValue).length(), 40)
    }

    // Geometry Collection length is equal to the sum of the elements' lengths
    func testLength_Collections() {
        XCTAssertEqual(try? collection.length(), 58)
        XCTAssertEqual(try? recursiveCollection.length(), 58)
        XCTAssertEqual(try? Geometry.geometryCollection(collection).length(), 58)
        XCTAssertEqual(try? Geometry.geometryCollection(recursiveCollection).length(), 58)
    }

    func testDistanceBetweenPoints() {
        let point1 = Point(x: 0, y: 0)
        let point2 = Point(x: 10, y: 0)
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
        let line = try! LineString(points: [Point(x: 1, y: 3), Point(x: 3, y: 1)])
        XCTAssertEqual(try? unitPoly.nearestPoints(with: line), [Point(x: 1, y: 1), Point(x: 2, y: 2)])
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
        var collection = GeometryCollection(geometries: [])

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

        lineString = try! LineString(points: lineString.points.dropLast())

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

    func testIsValid() {
        let validPoint = Point(x: 0, y: 0)

        XCTAssertTrue(try validPoint.isValid())

        let invalidPoint = Point(x: .nan, y: 0)

        XCTAssertFalse(try invalidPoint.isValid())
    }

    func testIsValidAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.isValid()
            } catch {
                XCTFail("Unexpected error for \(g) isValid() \(error)")
            }
        }
    }

    func testIsValidReason() throws {
        let validPoint = Point(x: 0, y: 0)

        XCTAssertEqual(try validPoint.isValidReason(), "Valid Geometry")

        let invalidPoint = Point(x: .nan, y: 0)

        XCTAssertEqual(try invalidPoint.isValidReason(), "Invalid Coordinate[nan 0]")
    }

    func testIsValidReasonAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.isValidReason()
            } catch {
                XCTFail("Unexpected error for \(g) isValidReason() \(error)")
            }
        }
    }

    func testIsValidDetail() throws {
        let validPoint = Point(x: 0, y: 0)

        XCTAssertEqual(try validPoint.isValidDetail(), .valid)

        let invalidPoint = Point(x: .nan, y: 0)

        let result = try invalidPoint.isValidDetail()
        guard case let .invalid(.some(reason), .some(.point(location))) = result else {
            XCTFail("Received unexpected isValidDetail result: \(result)")
            return
        }
        XCTAssertEqual(reason, "Invalid Coordinate")
        XCTAssertTrue(location.x.isNaN) // A naïve comparison of location and result fails because NaN != NaN
        XCTAssertEqual(location.y, invalidPoint.y)
    }

    func testIsValidDetail_AllowSelfTouchingRingFormingHole() {
        let polyWithSelfTouchingRingFormingHole = try! Polygon(exterior: Polygon.LinearRing(points: [
            Point(x: 0, y: 0),
            Point(x: 0, y: 4),
            Point(x: 4, y: 0),
            Point(x: 0, y: 0),
            Point(x: 2, y: 1),
            Point(x: 1, y: 2),
            Point(x: 0, y: 0)]))
        XCTAssertEqual(
            try polyWithSelfTouchingRingFormingHole.isValidDetail(allowSelfTouchingRingFormingHole: true),
            .valid)
        XCTAssertEqual(
            try polyWithSelfTouchingRingFormingHole.isValidDetail(allowSelfTouchingRingFormingHole: false),
            .invalid(reason: "Ring Self-intersection", location: .point(Point(x: 0, y: 0))))
    }

    func testIsValidDetailAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.isValidDetail()
            } catch {
                XCTFail("Unexpected error for \(g) isValidDetail() \(error)")
            }
        }
    }

    // MARK: - Binary Predicates

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

    func testCrossesBetweenLineStrings() {
        let horizontalLine = try! LineString(points: [Point(x: -1, y: 0), Point(x: 1, y: 0)])
        let verticalLine = try! LineString(points: [Point(x: 0, y: -1), Point(x: 0, y: 1)])
        let otherVerticalLine = try! LineString(points: [Point(x: 2, y: -1), Point(x: 2, y: 1)])
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

    func testOverlapsLines() {
        let line1 = try! LineString(points: [Point(x: 0, y: 0), Point(x: 1, y: 0)])
        let line2 = try! LineString(points: [Point(x: 0.5, y: 0), Point(x: 1.5, y: 0)])
        let line3 = try! LineString(points: [Point(x: 0, y: 0), Point(x: 0.5, y: 0)])
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

    // MARK: - Dimensionally Extended 9 Intersection Model Functions

    func testRelateMaskBetweenPoints() {
        let point1 = Point(x: 1, y: 1)
        let point2 = Point(x: 2, y: 2)
        // Test using the mask-version of isTopologicallyEquivalent(to:)
        XCTAssertEqual(try? point1.relate(point1, mask: "T*F**FFF*"), true)
        XCTAssertEqual(try? point1.relate(point2, mask: "T*F**FFF*"), false)
    }

    func testRelateInvalidMask() {
        let point1 = Point(x: 1, y: 1)
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
        let point1 = Point(x: 1, y: 1)
        let point2 = Point(x: 2, y: 2)
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

    func testMakeValidWhenItIsAPolygon() {
        let poly = try! Polygon(exterior: Polygon.LinearRing(points: [
            Point(x: 0, y: 0),
            Point(x: 2, y: 0),
            Point(x: 1, y: 1),
            Point(x: 0, y: 2),
            Point(x: 2, y: 2),
            Point(x: 1, y: 1),
            Point(x: 0, y: 0)]))

        let expectedPoly1 = try! Polygon(exterior: Polygon.LinearRing(points: [
            Point(x: 1, y: 1),
            Point(x: 2, y: 0),
            Point(x: 0, y: 0),
            Point(x: 1, y: 1)]))

        let expectedPoly2 = try! Polygon(exterior: Polygon.LinearRing(points: [
            Point(x: 1, y: 1),
            Point(x: 0, y: 2),
            Point(x: 2, y: 2),
            Point(x: 1, y: 1)]))

        do {
            switch try poly.makeValid() {
            case let .multiPolygon(multiPolygon):
                XCTAssertTrue(try multiPolygon.polygons.contains(where: expectedPoly1.isTopologicallyEquivalent))
                XCTAssertTrue(try multiPolygon.polygons.contains(where: expectedPoly2.isTopologicallyEquivalent))
            default:
                XCTFail("Unexpected geometry for \(poly) makeValid()")
            }
        } catch {
            XCTFail("Unexpected error for \(poly) makeValid() \(error)")
        }
    }

    func testMakeValidAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.makeValid()
            } catch {
                XCTFail("Unexpected error for \(g) makeValid() \(error)")
            }
        }
    }

    func testEnvelopeWhenItIsAPolygon() {
        let poly = try! Polygon(exterior: Polygon.LinearRing(points: [
            Point(x: 1, y: 0),
            Point(x: 0, y: 1),
            Point(x: -1, y: 0),
            Point(x: 0, y: -1),
            Point(x: 1, y: 0)]))
        let expectedEnvelope = Envelope(minX: -1, maxX: 1, minY: -1, maxY: 1)
        XCTAssertEqual(try? poly.envelope(), expectedEnvelope)
    }

    func testEnvelopeWhenItIsAPoint() {
        let expectedEnvelope = Envelope(minX: 1, maxX: 1, minY: 2, maxY: 2)
        XCTAssertEqual(try? Point.testValue1.envelope(), expectedEnvelope)
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
        let line = try! LineString(points: [
            Point(x: -1, y: 2),
            Point(x: 2, y: -1)])
        let expectedLine = try! LineString(points: [
            Point(x: 0, y: 1),
            Point(x: 1, y: 0)])
        XCTAssertEqual(try? unitPoly.intersection(with: line), .lineString(expectedLine))
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
        let polygon = try! Polygon(exterior: Polygon.LinearRing(points: [
            Point(x: 0, y: 0),
            Point(x: 1, y: 0),
            Point(x: 0.1, y: 0.1),
            Point(x: 0, y: 1),
            Point(x: 0, y: 0)]))
        // not sure why the result's shell is cw instead of ccw; need to follow up with GEOS team
        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(points: [
            Point(x: 0, y: 0),
            Point(x: 0, y: 1),
            Point(x: 1, y: 0),
            Point(x: 0, y: 0)]))
        XCTAssertEqual(try? polygon.convexHull(), .polygon(expectedPolygon))
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

    func testMinimumRotatedRectangleLineAndPoint() {
        let line = try! LineString(points: [
            Point(x: 0, y: 1),
            Point(x: 1, y: 0),
            Point(x: 2, y: 1)])
        let point = Point(x: 1, y: 2)
        let collection = GeometryCollection(geometries: [line, point])
        let expectedRectangle = try! Polygon(exterior: Polygon.LinearRing(points: [
            Point(x: 0, y: 1),
            Point(x: 1, y: 0),
            Point(x: 2, y: 1),
            Point(x: 1, y: 2),
            Point(x: 0, y: 1)]))
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
        let line = try! LineString(points: [
            Point(x: 0, y: 0),
            Point(x: 1, y: 1),
            Point(x: 0, y: 2)])
        let expectedLine = try! LineString(points: [
            Point(x: 0, y: 1),
            Point(x: 1, y: 1)])
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
        let poly = try! Polygon(exterior: Polygon.LinearRing(points: [
            Point(x: 0.5, y: 0),
            Point(x: 1.5, y: 0),
            Point(x: 1.5, y: 1),
            Point(x: 0.5, y: 1),
            Point(x: 0.5, y: 0)]))
        let expectedPoly = try! Polygon(exterior: Polygon.LinearRing(points: [
            Point(x: 1, y: 0),
            Point(x: 1.5, y: 0),
            Point(x: 1.5, y: 1),
            Point(x: 1, y: 1),
            Point(x: 1, y: 0)]))
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

    func testUnionPointAndLine() {
        let point = Point(x: 2, y: 0)
        XCTAssertEqual(try? lineString1.union(with: point),
                       .geometryCollection(GeometryCollection(geometries: [lineString1, point])))
    }

    func testUnionTwoPolygons() {
        let unitPoly2 = try! Polygon(exterior: Polygon.LinearRing(points: [
            Point(x: 1, y: 0),
            Point(x: 2, y: 0),
            Point(x: 2, y: 1),
            Point(x: 1, y: 1),
            Point(x: 1, y: 0)]))
        let expected = try! Polygon(exterior: Polygon.LinearRing(points: [
            Point(x: 0, y: 0),
            Point(x: 2, y: 0),
            Point(x: 2, y: 1),
            Point(x: 0, y: 1),
            Point(x: 0, y: 0)]))
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
        let unitPoly2 = try! Polygon(exterior: Polygon.LinearRing(points: [
            Point(x: 1, y: 0),
            Point(x: 2, y: 0),
            Point(x: 2, y: 1),
            Point(x: 1, y: 1),
            Point(x: 1, y: 0)]))
        let collection = GeometryCollection(geometries: [unitPoly, unitPoly2])
        let expected = try! Polygon(exterior: Polygon.LinearRing(points: [
            Point(x: 0, y: 0),
            Point(x: 2, y: 0),
            Point(x: 2, y: 1),
            Point(x: 0, y: 1),
            Point(x: 0, y: 0)]))
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

        XCTAssertEqual(point, Point(x: 0.5, y: 0.5))
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

        XCTAssertEqual(point, Point(x: 0.5, y: 0.5))
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
        XCTAssertEqual(try lineString1.minimumBoundingCircle(),
                       Circle(center: Point(x: 0.5, y: 0), radius: 0.5))
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
            LineString(points: [Point(x: 0, y: 0), Point(x: 1, y: 0)]),
            LineString(points: [Point(x: 1, y: 0), Point(x: 0, y: 1)]),
            LineString(points: [Point(x: 0, y: 1), Point(x: 0, y: 0)])])

        let expectedPolygon = try! GEOSwift.Polygon(exterior: GEOSwift.Polygon.LinearRing(points: [
            Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 0, y: 1), Point(x: 0, y: 0)]))

        XCTAssertTrue(try multiLineString.polygonize().isTopologicallyEquivalent(to: expectedPolygon))
    }

    func testPolygonizeEmptyArray() {
        XCTAssertEqual(try [Geometry]().polygonize(), GeometryCollection(geometries: []))
    }

    func testPolygonizeArray() {
        let lineStrings = try! [
            LineString(points: [Point(x: 0, y: 0), Point(x: 1, y: 0)]),
            LineString(points: [Point(x: 1, y: 0), Point(x: 0, y: 1)]),
            LineString(points: [Point(x: 0, y: 1), Point(x: 0, y: 0)])]

        let expectedPolygon = try! GEOSwift.Polygon(exterior: GEOSwift.Polygon.LinearRing(points: [
            Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 0, y: 1), Point(x: 0, y: 0)]))

        XCTAssertTrue(try lineStrings.polygonize().isTopologicallyEquivalent(to: expectedPolygon))
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

    func testNegativeBufferWidthThrows() {
        XCTAssertThrowsError(try Point(x: 0, y: 0).buffer(by: -1)) { (error) in
            if case GEOSwiftError.negativeBufferWidth = error {
                // pass
            } else {
                XCTFail("Threw unexpected error: \(error)")
            }
        }
    }
}
