import XCTest
import GEOSwift

// MARK: - Test Value Extensions for XYZM

private extension Point where C == XYZM {
    static let testValue1 = Point(XYZM(1, 2, 100, 1000))
    static let testValue3 = Point(XYZM(3, 4, 150, 1500))
    static let testValue5 = Point(XYZM(5, 6, 200, 2000))
    static let testValue7 = Point(XYZM(7, 8, 250, 2500))
}

private extension LineString where C == XYZM {
    static let testValue1 = try! LineString(coordinates: [
        Point<XYZM>.testValue1.coordinates,
        Point<XYZM>.testValue3.coordinates
    ])
    static let testValue5 = try! LineString(coordinates: [
        Point<XYZM>.testValue5.coordinates,
        Point<XYZM>.testValue7.coordinates
    ])
}

private extension Polygon.LinearRing where C == XYZM {
    // counterclockwise
    static let testValueExterior2 = try! Polygon.LinearRing(coordinates: [
        XYZM(2, 2, 100, 1000),
        XYZM(-2, 2, 150, 1500),
        XYZM(-2, -2, 200, 2000),
        XYZM(2, -2, 250, 2500),
        XYZM(2, 2, 100, 1000)])

    // clockwise
    static let testValueHole1 = try! Polygon.LinearRing(coordinates: [
        XYZM(1, 1, 125, 1250),
        XYZM(1, -1, 175, 1750),
        XYZM(-1, -1, 225, 2250),
        XYZM(-1, 1, 275, 2750),
        XYZM(1, 1, 125, 1250)])

    // counterclockwise
    static let testValueExterior7 = try! Polygon.LinearRing(coordinates: [
        XYZM(7, 2, 300, 3000),
        XYZM(3, 2, 350, 3500),
        XYZM(3, -2, 400, 4000),
        XYZM(7, -2, 450, 4500),
        XYZM(7, 2, 300, 3000)])
}

private extension Polygon where C == XYZM {
    static let testValueWithHole = Polygon(
        exterior: Polygon<XYZM>.LinearRing.testValueExterior2,
        holes: [Polygon<XYZM>.LinearRing.testValueHole1])

    static let testValueWithoutHole = Polygon(
        exterior: Polygon<XYZM>.LinearRing.testValueExterior7)
}

private extension MultiPoint where C == XYZM {
    static let testValue = MultiPoint(points: [.testValue1, .testValue3])
}

private extension MultiLineString where C == XYZM {
    static let testValue = MultiLineString(
        lineStrings: [.testValue1, .testValue5])
}

private extension MultiPolygon where C == XYZM {
    static let testValue = MultiPolygon(
        polygons: [.testValueWithHole, .testValueWithoutHole])
}

private extension GeometryCollection where C == XYZM {
    static let testValue = GeometryCollection(
        geometries: [
            Point<XYZM>.testValue1,
            MultiPoint<XYZM>.testValue,
            LineString<XYZM>.testValue1,
            MultiLineString<XYZM>.testValue,
            Polygon<XYZM>.testValueWithHole,
            MultiPolygon<XYZM>.testValue])

    static let testValueWithRecursion = GeometryCollection(
        geometries: [GeometryCollection<XYZM>.testValue])
}

// MARK: - Tests

final class PolygonizeTests_XYZM: XCTestCase {
    let geometryConvertibles: [any GeometryConvertible<XYZM>] = [
        Point<XYZM>.testValue1,
        Geometry.point(Point<XYZM>.testValue1),
        MultiPoint<XYZM>.testValue,
        Geometry.multiPoint(MultiPoint<XYZM>.testValue),
        LineString<XYZM>.testValue1,
        Geometry.lineString(LineString<XYZM>.testValue1),
        MultiLineString<XYZM>.testValue,
        Geometry.multiLineString(MultiLineString<XYZM>.testValue),
        Polygon<XYZM>.LinearRing.testValueHole1,
        Polygon<XYZM>.testValueWithHole,
        Geometry.polygon(Polygon<XYZM>.testValueWithHole),
        MultiPolygon<XYZM>.testValue,
        Geometry.multiPolygon(MultiPolygon<XYZM>.testValue),
        GeometryCollection<XYZM>.testValue,
        GeometryCollection<XYZM>.testValueWithRecursion,
        Geometry.geometryCollection(GeometryCollection<XYZM>.testValue)]

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
            LineString(coordinates: [XYZM(0, 0, 0, 0), XYZM(1, 0, 1, 1)]),
            LineString(coordinates: [XYZM(1, 0, 2, 2), XYZM(0, 1, 3, 3)]),
            LineString(coordinates: [XYZM(0, 1, 4, 4), XYZM(0, 0, 0, 0)])])

        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 0, 0), XYZM(1, 0, 1, 1), XYZM(0, 1, 2, 2), XYZM(0, 0, 0, 0)]))

        // Polygonize preserves Z (drops M) and topological equivalence only tests XY
        XCTAssertTrue(try multiLineString.polygonize().isTopologicallyEquivalent(to: expectedPolygon))
    }

    func testPolygonizeEmptyArray() {
        XCTAssertEqual(try [Geometry<XYZM>]().polygonize(), GeometryCollection(geometries: []))
    }

    func testPolygonizeArray() {
        let lineStrings = try! [
            LineString(coordinates: [XYZM(0, 0, 0, 0), XYZM(1, 0, 1, 1)]),
            LineString(coordinates: [XYZM(1, 0, 2, 2), XYZM(0, 1, 3, 3)]),
            LineString(coordinates: [XYZM(0, 1, 4, 4), XYZM(0, 0, 0, 0)])]

        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 0, 0), XYZM(1, 0, 1, 1), XYZM(0, 1, 2, 2), XYZM(0, 0, 0, 0)]))

        // Polygonize preserves Z (drops M) and topological equivalence only tests XY
        XCTAssertTrue(try lineStrings.polygonize().isTopologicallyEquivalent(to: expectedPolygon))
    }

    // MARK: - Z Preservation Tests

    func testPolygonizePreservesZ() throws {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XYZM(0, 0, 10, 100), XYZM(4, 0, 20, 200)]),
            LineString(coordinates: [XYZM(4, 0, 20, 200), XYZM(4, 4, 30, 300)]),
            LineString(coordinates: [XYZM(4, 4, 30, 300), XYZM(0, 4, 40, 400)]),
            LineString(coordinates: [XYZM(0, 4, 40, 400), XYZM(0, 0, 10, 100)])])

        let result = try multiLineString.polygonize()
        XCTAssertFalse(result.geometries.isEmpty)

        for geometry in result.geometries {
            switch geometry {
            case let .polygon(polygon):
                for coord in polygon.exterior.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            default:
                break
            }
        }
    }

    func testPolygonizeArrayPreservesZ() throws {
        let lineStrings = try! [
            LineString(coordinates: [XYZM(0, 0, 10, 100), XYZM(4, 0, 20, 200)]),
            LineString(coordinates: [XYZM(4, 0, 20, 200), XYZM(4, 4, 30, 300)]),
            LineString(coordinates: [XYZM(4, 4, 30, 300), XYZM(0, 4, 40, 400)]),
            LineString(coordinates: [XYZM(0, 4, 40, 400), XYZM(0, 0, 10, 100)])]

        let result = try lineStrings.polygonize()
        XCTAssertFalse(result.geometries.isEmpty)

        for geometry in result.geometries {
            switch geometry {
            case let .polygon(polygon):
                for coord in polygon.exterior.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            default:
                break
            }
        }
    }

    func testPolygonizeComplexShapePreservesZ() throws {
        // Create a more complex shape with multiple polygons
        let lineStrings = try! [
            // First triangle
            LineString(coordinates: [XYZM(0, 0, 10, 100), XYZM(2, 0, 20, 200)]),
            LineString(coordinates: [XYZM(2, 0, 20, 200), XYZM(1, 2, 30, 300)]),
            LineString(coordinates: [XYZM(1, 2, 30, 300), XYZM(0, 0, 10, 100)]),
            // Second triangle
            LineString(coordinates: [XYZM(3, 0, 40, 400), XYZM(5, 0, 50, 500)]),
            LineString(coordinates: [XYZM(5, 0, 50, 500), XYZM(4, 2, 60, 600)]),
            LineString(coordinates: [XYZM(4, 2, 60, 600), XYZM(3, 0, 40, 400)])]

        let result = try lineStrings.polygonize()

        for geometry in result.geometries {
            switch geometry {
            case let .polygon(polygon):
                for coord in polygon.exterior.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN in polygon")
                }
            default:
                break
            }
        }
    }
}
