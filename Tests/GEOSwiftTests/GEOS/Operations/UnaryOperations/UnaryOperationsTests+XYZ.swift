import XCTest
import GEOSwift

// MARK: - Test Value Extensions for XYZ

private extension Point where C == XYZ {
    static let testValue1 = Point(XYZ(1, 2, 0))
    static let testValue3 = Point(XYZ(3, 4, 1))
    static let testValue5 = Point(XYZ(5, 6, 2))
    static let testValue7 = Point(XYZ(7, 8, 3))
}

private extension LineString where C == XYZ {
    static let testValue1 = try! LineString(coordinates: [
        Point<XYZ>.testValue1.coordinates,
        Point<XYZ>.testValue3.coordinates
    ])
    static let testValue5 = try! LineString(coordinates: [
        Point<XYZ>.testValue5.coordinates,
        Point<XYZ>.testValue7.coordinates
    ])
}

private extension Polygon.LinearRing where C == XYZ {
    // counterclockwise
    static let testValueExterior2 = try! Polygon.LinearRing(coordinates: [
        XYZ(2, 2, 0),
        XYZ(-2, 2, 1),
        XYZ(-2, -2, 2),
        XYZ(2, -2, 3),
        XYZ(2, 2, 4)])

    // clockwise
    static let testValueHole1 = try! Polygon.LinearRing(coordinates: [
        XYZ(1, 1, 4),
        XYZ(1, -1, 3),
        XYZ(-1, -1, 2),
        XYZ(-1, 1, 1),
        XYZ(1, 1, 0)])

    // counterclockwise
    static let testValueExterior7 = try! Polygon.LinearRing(coordinates: [
        XYZ(7, 2, 5),
        XYZ(3, 2, 6),
        XYZ(3, -2, 7),
        XYZ(7, -2, 8),
        XYZ(7, 2, 9)])
}

private extension Polygon where C == XYZ {
    static let testValueWithHole = Polygon(
        exterior: Polygon<XYZ>.LinearRing.testValueExterior2,
        holes: [Polygon<XYZ>.LinearRing.testValueHole1])

    static let testValueWithoutHole = Polygon(
        exterior: Polygon<XYZ>.LinearRing.testValueExterior7)
}

private extension MultiPoint where C == XYZ {
    static let testValue = MultiPoint(points: [.testValue1, .testValue3])
}

private extension MultiLineString where C == XYZ {
    static let testValue = MultiLineString(
        lineStrings: [.testValue1, .testValue5])
}

private extension MultiPolygon where C == XYZ {
    static let testValue = MultiPolygon(
        polygons: [.testValueWithHole, .testValueWithoutHole])
}

private extension GeometryCollection where C == XYZ {
    static let testValue = GeometryCollection(
        geometries: [
            Point<XYZ>.testValue1,
            MultiPoint<XYZ>.testValue,
            LineString<XYZ>.testValue1,
            MultiLineString<XYZ>.testValue,
            Polygon<XYZ>.testValueWithHole,
            MultiPolygon<XYZ>.testValue])

    static let testValueWithRecursion = GeometryCollection(
        geometries: [GeometryCollection<XYZ>.testValue])
}

// MARK: - Tests

final class UnaryOperationsTests_XYZ: XCTestCase {
    let lineString0 = try! LineString(coordinates: Array(repeating: XYZ(0, 0, 0), count: 2))
    let lineString1 = try! LineString(coordinates: [
        XYZ(0, 0, 0),
        XYZ(1, 0, 0)])
    let lineString2 = try! LineString(coordinates: [
        XYZ(0, 0, 0),
        XYZ(1, 0, 1),
        XYZ(1, 1, 1)])
    let multiLineString0 = MultiLineString<XYZ>(lineStrings: [])
    lazy var multiLineString1 = MultiLineString(lineStrings: [lineString1])
    lazy var multiLineString2 = MultiLineString(lineStrings: [lineString1, lineString2])
    let linearRing0 = try! Polygon.LinearRing(coordinates: Array(repeating: XYZ(0, 0, 0), count: 4))
    let linearRing1 = try! Polygon.LinearRing(coordinates: [
        XYZ(0, 0, 0),
        XYZ(1, 0, 0),
        XYZ(1, 1, 0),
        XYZ(0, 1, 0),
        XYZ(0, 0, 0)])
    lazy var collection = GeometryCollection(
        geometries: [
            Point<XYZ>.testValue1,
            MultiPoint<XYZ>.testValue,
            lineString1,
            multiLineString1,
            Polygon<XYZ>.testValueWithoutHole,
            MultiPolygon<XYZ>.testValue])
    lazy var recursiveCollection = GeometryCollection(
        geometries: [collection])
    let geometryConvertibles: [any GeometryConvertible<XYZ>] = [
        Point<XYZ>.testValue1,
        Geometry.point(Point<XYZ>.testValue1),
        MultiPoint<XYZ>.testValue,
        Geometry.multiPoint(MultiPoint<XYZ>.testValue),
        LineString<XYZ>.testValue1,
        Geometry.lineString(LineString<XYZ>.testValue1),
        MultiLineString<XYZ>.testValue,
        Geometry.multiLineString(MultiLineString<XYZ>.testValue),
        Polygon<XYZ>.LinearRing.testValueHole1,
        Polygon<XYZ>.testValueWithHole,
        Geometry.polygon(Polygon<XYZ>.testValueWithHole),
        MultiPolygon<XYZ>.testValue,
        Geometry.multiPolygon(MultiPolygon<XYZ>.testValue),
        GeometryCollection<XYZ>.testValue,
        GeometryCollection<XYZ>.testValueWithRecursion,
        Geometry.geometryCollection(GeometryCollection<XYZ>.testValue)]
    let unitPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
        XYZ(0, 0, 1),
        XYZ(1, 0, 2),
        XYZ(1, 1, 3),
        XYZ(0, 1, 4),
        XYZ(0, 0, 1)]))

    // MARK: - Length

    // points have length 0
    func testLength_Points() {
        XCTAssertEqual(try? Point<XYZ>.testValue1.length(), 0)
        XCTAssertEqual(try? MultiPoint<XYZ>.testValue.length(), 0)
        XCTAssertEqual(try? Geometry.point(Point<XYZ>.testValue1).length(), 0)
        XCTAssertEqual(try? Geometry.multiPoint(MultiPoint<XYZ>.testValue).length(), 0)
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
        XCTAssertEqual(try? Polygon<XYZ>.testValueWithoutHole.length(), 16)
        XCTAssertEqual(try? Polygon<XYZ>.testValueWithHole.length(), 24)
        XCTAssertEqual(try? MultiPolygon<XYZ>.testValue.length(), 40)
        XCTAssertEqual(try? Geometry.polygon(Polygon<XYZ>.testValueWithoutHole).length(), 16)
        XCTAssertEqual(try? Geometry.polygon(Polygon<XYZ>.testValueWithHole).length(), 24)
        XCTAssertEqual(try? Geometry.multiPolygon(MultiPolygon<XYZ>.testValue).length(), 40)
    }

    // Geometry Collection length is equal to the sum of the elements' lengths
    func testLength_Collections() {
        XCTAssertEqual(try? collection.length(), 58)
        XCTAssertEqual(try? recursiveCollection.length(), 58)
        XCTAssertEqual(try? Geometry.geometryCollection(collection).length(), 58)
        XCTAssertEqual(try? Geometry.geometryCollection(recursiveCollection).length(), 58)
    }

    // MARK: - Area

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

    // MARK: - Normalized

    func testNormalizedMultiLineString() {
        let multiLineString = try! MultiLineString(
            lineStrings: [
                LineString(
                    coordinates: [
                        XYZ(0, 1, 0),
                        XYZ(2, 3, 1)]),
                LineString(
                    coordinates: [
                        XYZ(4, 5, 2),
                        XYZ(6, 7, 3)])]).geometry
        let expected = try! MultiLineString(
            lineStrings: [
                LineString(
                    coordinates: [
                        XYZ(4, 5, 2),
                        XYZ(6, 7, 3)]),
                LineString(
                    coordinates: [
                        XYZ(0, 1, 0),
                        XYZ(2, 3, 1)])]).geometry

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

    // MARK: - Envelope

    func testEnvelopeWhenItIsAPolygon() {
        let poly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(1, 0, 0),
            XYZ(0, 1, 1),
            XYZ(-1, 0, 2),
            XYZ(0, -1, 3),
            XYZ(1, 0, 0)]))
        let expectedEnvelope = Envelope(minX: -1, maxX: 1, minY: -1, maxY: 1)

        // Envelope operations don't take into account Z
        XCTAssertEqual(try? poly.envelope(), expectedEnvelope)
    }

    func testEnvelopeWhenItIsAPoint() {
        let expectedEnvelope = Envelope(minX: 1, maxX: 1, minY: 2, maxY: 2)

        // Envelope operations don't take into account Z
        XCTAssertEqual(try? Point<XYZ>.testValue1.envelope(), expectedEnvelope)
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

    // MARK: - Minimum Rotated Rectangle

    func testMinimumRotatedRectangleLineAndPoint() {
        let line = try! LineString(coordinates: [
            XYZ(0, 1, 0),
            XYZ(1, 0, 0),
            XYZ(2, 1, 0)])
        let point = Point(XYZ(1, 2, 0))
        let collection = GeometryCollection(geometries: [line, point])
        let expectedRectangle = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 1, 0),
            XYZ(1, 0, 1),
            XYZ(2, 1, 2),
            XYZ(1, 2, 3),
            XYZ(0, 1, 0)]))

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

    // MARK: - Minimum Width

    func testMinimumWidthLine() {
        let line = try! LineString(coordinates: [
            XYZ(0, 0, 0),
            XYZ(1, 1, 1),
            XYZ(0, 2, 2)])
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

    // MARK: - Point On Surface

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

    // MARK: - Centroid

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

    // MARK: - Minimum Bounding Circle

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
}
