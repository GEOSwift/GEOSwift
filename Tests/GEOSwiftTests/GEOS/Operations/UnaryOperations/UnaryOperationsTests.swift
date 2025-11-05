import XCTest
import GEOSwift

final class UnaryOperationsTests: OperationsTestCase_XY {

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
        XCTAssertEqual(try? lineStringLength1.length(), 1)
        XCTAssertEqual(try? lineStringLength2.length(), 2)
        XCTAssertEqual(try? multiLineString0.length(), 0)
        XCTAssertEqual(try? multiLineStringLength1.length(), 1)
        XCTAssertEqual(try? multiLineStringLength3.length(), 3)
        XCTAssertEqual(try? linearRing0.length(), 0)
        XCTAssertEqual(try? linearRingLength4.length(), 4)
        XCTAssertEqual(try? Geometry.lineString(lineString0).length(), 0)
        XCTAssertEqual(try? Geometry.lineString(lineStringLength1).length(), 1)
        XCTAssertEqual(try? Geometry.lineString(lineStringLength2).length(), 2)
        XCTAssertEqual(try? Geometry.multiLineString(multiLineString0).length(), 0)
        XCTAssertEqual(try? Geometry.multiLineString(multiLineStringLength1).length(), 1)
        XCTAssertEqual(try? Geometry.multiLineString(multiLineStringLength3).length(), 3)
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
                        XY(0, 1),
                        XY(2, 3)]),
                LineString(
                    coordinates: [
                        XY(4, 5),
                        XY(6, 7)])]).geometry
        let expected = try! MultiLineString(
            lineStrings: [
                LineString(
                    coordinates: [
                        XY(4, 5),
                        XY(6, 7)]),
                LineString(
                    coordinates: [
                        XY(0, 1),
                        XY(2, 3)])]).geometry

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
            XY(1, 0),
            XY(0, 1),
            XY(-1, 0),
            XY(0, -1),
            XY(1, 0)]))
        let expectedEnvelope = Envelope(minX: -1, maxX: 1, minY: -1, maxY: 1)
        XCTAssertEqual(try? poly.envelope(), expectedEnvelope)
    }

    func testEnvelopeWhenItIsAPoint() {
        let expectedEnvelope = Envelope(minX: 1, maxX: 1, minY: 2, maxY: 2)
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
            XY(0, 1),
            XY(1, 0),
            XY(2, 1)])
        let point = Point(x: 1, y: 2)
        let collection = GeometryCollection(geometries: [line, point])
        let expectedRectangle = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 1),
            XY(1, 0),
            XY(2, 1),
            XY(1, 2),
            XY(0, 1)]))
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
            XY(0, 0),
            XY(1, 1),
            XY(0, 2)])
        let expectedLine = try! LineString(coordinates: [
            XY(0, 1),
            XY(1, 1)])
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

    // MARK: - Centroid

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

    // MARK: - Minimum Bounding Circle

    func testMinimumBoundingCircleLineString() {
        XCTAssertEqual(try lineStringLength1.minimumBoundingCircle(),
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
}
