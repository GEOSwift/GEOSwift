import XCTest
import GEOSwift

// MARK: - Tests

final class UnaryOperationsTests_XYZM: XCTestCase {
    // Convert XYZM fixtures to XYZM using copy constructors
    let lineString0 = LineString<XYZM>(Fixtures.lineString0)
    let lineString1 = LineString<XYZM>(Fixtures.lineStringLength1)
    let lineString2 = LineString<XYZM>(Fixtures.lineStringLength2)
    let multiLineString0 = MultiLineString<XYZM>(Fixtures.multiLineString0)
    let multiLineString1 = MultiLineString<XYZM>(Fixtures.multiLineStringLength1)
    let multiLineString2 = MultiLineString<XYZM>(Fixtures.multiLineStringLength3)
    let linearRing0 = Polygon<XYZM>.LinearRing(Fixtures.linearRing0)
    let linearRing1 = Polygon<XYZM>.LinearRing(Fixtures.linearRingLength4)
    let collection = GeometryCollection<XYZM>(Fixtures.collection)
    let recursiveCollection = GeometryCollection<XYZM>(Fixtures.recursiveCollection)
    let unitPoly = Polygon<XYZM>(Fixtures.unitPolygon)

    // Additional fixtures for convenience
    let point1 = Point<XYZM>(Fixtures.point1)
    let multiPoint = MultiPoint<XYZM>(Fixtures.multiPoint)
    let polygonWithHole = Polygon<XYZM>(Fixtures.polygonWithHole)
    let polygonWithoutHole = Polygon<XYZM>(Fixtures.polygonWithoutHole)
    let multiPolygon = MultiPolygon<XYZM>(Fixtures.multiPolygon)

    // Geometry convertibles array needs to be converted element-by-element
    lazy var geometryConvertibles: [any GeometryConvertible<XYZM>] = [
        point1,
        Geometry.point(point1),
        multiPoint,
        Geometry.multiPoint(multiPoint),
        LineString<XYZM>(Fixtures.lineString1),
        Geometry.lineString(LineString<XYZM>(Fixtures.lineString1)),
        MultiLineString<XYZM>(Fixtures.multiLineString),
        Geometry.multiLineString(MultiLineString<XYZM>(Fixtures.multiLineString)),
        Polygon<XYZM>.LinearRing(Fixtures.linearRingHole1),
        polygonWithHole,
        Geometry.polygon(polygonWithHole),
        multiPolygon,
        Geometry.multiPolygon(multiPolygon),
        GeometryCollection<XYZM>(Fixtures.geometryCollection),
        GeometryCollection<XYZM>(Fixtures.recursiveGeometryCollection),
        Geometry.geometryCollection(GeometryCollection<XYZM>(Fixtures.geometryCollection))
    ]

    // MARK: - Length

    // points have length 0
    func testLength_Points() {
        XCTAssertEqual(try? point1.length(), 0)
        XCTAssertEqual(try? multiPoint.length(), 0)
        XCTAssertEqual(try? Geometry.point(point1).length(), 0)
        XCTAssertEqual(try? Geometry.multiPoint(multiPoint).length(), 0)
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
        XCTAssertEqual(try? polygonWithoutHole.length(), 16)
        XCTAssertEqual(try? polygonWithHole.length(), 24)
        XCTAssertEqual(try? multiPolygon.length(), 40)
        XCTAssertEqual(try? Geometry.polygon(polygonWithoutHole).length(), 16)
        XCTAssertEqual(try? Geometry.polygon(polygonWithHole).length(), 24)
        XCTAssertEqual(try? Geometry.multiPolygon(multiPolygon).length(), 40)
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
                        XYZM(0, 1, 0, 0),
                        XYZM(2, 3, 1, 1)]),
                LineString(
                    coordinates: [
                        XYZM(4, 5, 2, 2),
                        XYZM(6, 7, 3, 3)])]).geometry
        let expected = try! MultiLineString(
            lineStrings: [
                LineString(
                    coordinates: [
                        XYZM(4, 5, 2, 2),
                        XYZM(6, 7, 3, 3)]),
                LineString(
                    coordinates: [
                        XYZM(0, 1, 0, 0),
                        XYZM(2, 3, 1, 1)])]).geometry

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
            XYZM(1, 0, 0, 0),
            XYZM(0, 1, 1, 1),
            XYZM(-1, 0, 2, 2),
            XYZM(0, -1, 3, 3),
            XYZM(1, 0, 0, 0)]))
        let expectedEnvelope = Envelope(minX: -1, maxX: 1, minY: -1, maxY: 1)

        // Envelope operations don't take into account Z or M
        XCTAssertEqual(try? poly.envelope(), expectedEnvelope)
    }

    func testEnvelopeWhenItIsAPoint() {
        let expectedEnvelope = Envelope(minX: 1, maxX: 1, minY: 2, maxY: 2)

        // Envelope operations don't take into account Z or M
        XCTAssertEqual(try? point1.envelope(), expectedEnvelope)
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
            XYZM(0, 1, 0, 0),
            XYZM(1, 0, 0, 1),
            XYZM(2, 1, 0, 2)])
        let point = Point(XYZM(1, 2, 0, 3))
        let collection = GeometryCollection(geometries: [line, point])
        let expectedRectangle = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 1, 0, 0),
            XYZM(1, 0, 1, 1),
            XYZM(2, 1, 2, 2),
            XYZM(1, 2, 3, 3),
            XYZM(0, 1, 0, 0)]))

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
            XYZM(0, 0, 0, 0),
            XYZM(1, 1, 1, 1),
            XYZM(0, 2, 2, 2)])
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
