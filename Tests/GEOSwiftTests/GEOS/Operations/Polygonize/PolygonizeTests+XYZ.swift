import XCTest
import GEOSwift

// MARK: - Test Value Extensions for XYZ

private extension Point where C == XYZ {
    static let testValue1 = Point(XYZ(1, 2, 100))
    static let testValue3 = Point(XYZ(3, 4, 150))
    static let testValue5 = Point(XYZ(5, 6, 200))
    static let testValue7 = Point(XYZ(7, 8, 250))
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
        XYZ(2, 2, 100),
        XYZ(-2, 2, 150),
        XYZ(-2, -2, 200),
        XYZ(2, -2, 250),
        XYZ(2, 2, 100)])

    // clockwise
    static let testValueHole1 = try! Polygon.LinearRing(coordinates: [
        XYZ(1, 1, 125),
        XYZ(1, -1, 175),
        XYZ(-1, -1, 225),
        XYZ(-1, 1, 275),
        XYZ(1, 1, 125)])

    // counterclockwise
    static let testValueExterior7 = try! Polygon.LinearRing(coordinates: [
        XYZ(7, 2, 300),
        XYZ(3, 2, 350),
        XYZ(3, -2, 400),
        XYZ(7, -2, 450),
        XYZ(7, 2, 300)])
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

final class PolygonizeTests_XYZ: XCTestCase {
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
            LineString(coordinates: [XYZ(0, 0, 0), XYZ(1, 0, 1)]),
            LineString(coordinates: [XYZ(1, 0, 2), XYZ(0, 1, 3)]),
            LineString(coordinates: [XYZ(0, 1, 4), XYZ(0, 0, 0)])])

        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 0), XYZ(1, 0, 0), XYZ(0, 1, 0), XYZ(0, 0, 0)]))

        // Topological equivalence only checks XY geometry
        XCTAssertTrue(try multiLineString.polygonize().isTopologicallyEquivalent(to: expectedPolygon))
    }

    func testPolygonizeEmptyArray() {
        XCTAssertEqual(try [Geometry<XYZ>]().polygonize(), GeometryCollection(geometries: []))
    }

    func testPolygonizeArray() {
        let lineStrings = try! [
            LineString(coordinates: [XYZ(0, 0, 0), XYZ(1, 0, 1)]),
            LineString(coordinates: [XYZ(1, 0, 2), XYZ(0, 1, 3)]),
            LineString(coordinates: [XYZ(0, 1, 4), XYZ(0, 0, 0)])]

        // Topological equivalence only checks XY geometry
        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 0), XYZ(1, 0, 0), XYZ(0, 1, 0), XYZ(0, 0, 0)]))

        XCTAssertTrue(try lineStrings.polygonize().isTopologicallyEquivalent(to: expectedPolygon))
    }

    // MARK: - Z Preservation Tests

    func testPolygonizePreservesZ() throws {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XYZ(0, 0, 10), XYZ(4, 0, 20)]),
            LineString(coordinates: [XYZ(4, 0, 20), XYZ(4, 4, 30)]),
            LineString(coordinates: [XYZ(4, 4, 30), XYZ(0, 4, 40)]),
            LineString(coordinates: [XYZ(0, 4, 40), XYZ(0, 0, 10)])])

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
            LineString(coordinates: [XYZ(0, 0, 10), XYZ(4, 0, 20)]),
            LineString(coordinates: [XYZ(4, 0, 20), XYZ(4, 4, 30)]),
            LineString(coordinates: [XYZ(4, 4, 30), XYZ(0, 4, 40)]),
            LineString(coordinates: [XYZ(0, 4, 40), XYZ(0, 0, 10)])]

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
            LineString(coordinates: [XYZ(0, 0, 10), XYZ(2, 0, 20)]),
            LineString(coordinates: [XYZ(2, 0, 20), XYZ(1, 2, 30)]),
            LineString(coordinates: [XYZ(1, 2, 30), XYZ(0, 0, 10)]),
            // Second triangle
            LineString(coordinates: [XYZ(3, 0, 40), XYZ(5, 0, 50)]),
            LineString(coordinates: [XYZ(5, 0, 50), XYZ(4, 2, 60)]),
            LineString(coordinates: [XYZ(4, 2, 60), XYZ(3, 0, 40)])]

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
