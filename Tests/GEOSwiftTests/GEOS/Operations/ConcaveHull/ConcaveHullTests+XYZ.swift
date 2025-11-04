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

final class ConcaveHullTests_XYZ: XCTestCase {
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

    func testConcaveHullAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.concaveHull(withRatio: .random(in: 0...1), allowHoles: .random())
            } catch {
                XCTFail("Unexpected error for \(g) concaveHull() \(error)")
            }
        }
    }

    // MARK: - Z Preservation Tests

    func testConcaveHullPreservesZ() throws {
        // Test that concaveHull() preserves Z coordinates when input has Z
        let polygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 10),
            XYZ(4, 0, 20),
            XYZ(4, 4, 30),
            XYZ(0, 4, 40),
            XYZ(0, 0, 10)]))

        let result: Geometry<XYZ> = try polygon.concaveHull(withRatio: 0.5, allowHoles: false)

        // Verify the result is XYZ type
        switch result {
        case let .polygon(resultPolygon):
            // Check that we have Z coordinates in the output
            for coord in resultPolygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon result, got \(result)")
        }
    }

    func testConcaveHullPreservesZForPoint() throws {
        // Test that concaveHull() preserves Z for points
        let pointWithZ = Point(XYZ(1, 2, 42))

        let result: Geometry<XYZ> = try pointWithZ.concaveHull(withRatio: 0.5, allowHoles: false)

        switch result {
        case let .point(point):
            XCTAssertEqual(point.coordinates.z, 42, accuracy: 0.001)
        default:
            XCTFail("Expected point result, got \(result)")
        }
    }

    func testConcaveHullPreservesZForLineString() throws {
        // Test that concaveHull() preserves Z for line strings
        let lineWithZ = try! LineString(coordinates: [
            XYZ(0, 0, 5),
            XYZ(1, 1, 10)])

        let result: Geometry<XYZ> = try lineWithZ.concaveHull(withRatio: 0.5, allowHoles: false)

        // LineString hull becomes a LineString
        switch result {
        case let .lineString(line):
            // Check that all Z coordinates are preserved (not NaN)
            for coord in line.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected lineString result, got \(result)")
        }
    }

    func testConcaveHullPreservesZForMultiPoint() throws {
        // Test that concaveHull() preserves Z for multi points forming a polygon
        let multiPointWithZ = MultiPoint(points: [
            Point(XYZ(0, 0, 100)),
            Point(XYZ(4, 0, 200)),
            Point(XYZ(4, 4, 300)),
            Point(XYZ(0, 4, 400))])

        let result: Geometry<XYZ> = try multiPointWithZ.concaveHull(withRatio: 0.5, allowHoles: false)

        switch result {
        case let .polygon(polygon):
            // Check that all Z coordinates are preserved (not NaN)
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon result, got \(result)")
        }
    }

    func testConcaveHullPreservesZForGeometryCollection() throws {
        // Test that concaveHull() preserves Z for geometry collections
        let collectionWithZ = GeometryCollection(geometries: [
            Geometry.point(Point(XYZ(0, 0, 50))),
            Geometry.point(Point(XYZ(4, 0, 60))),
            Geometry.point(Point(XYZ(4, 4, 70))),
            Geometry.point(Point(XYZ(0, 4, 80)))
        ])

        let result: Geometry<XYZ> = try collectionWithZ.concaveHull(withRatio: 0.5, allowHoles: false)

        switch result {
        case let .polygon(polygon):
            // Check that all Z coordinates are preserved (not NaN)
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon result, got \(result)")
        }
    }

    func testConcaveHullPreservesZForPolygonWithHole() throws {
        // Test that concaveHull() preserves Z for polygons with holes
        let polyWithZ = try! Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYZ(0, 0, 1),
                XYZ(8, 0, 2),
                XYZ(8, 8, 3),
                XYZ(0, 8, 4),
                XYZ(0, 0, 1)]),
            holes: [
                Polygon.LinearRing(coordinates: [
                    XYZ(2, 2, 5),
                    XYZ(6, 2, 6),
                    XYZ(6, 6, 7),
                    XYZ(2, 6, 8),
                    XYZ(2, 2, 5)])
            ])

        let result: Geometry<XYZ> = try polyWithZ.concaveHull(withRatio: 0.5, allowHoles: true)

        switch result {
        case let .polygon(polygon):
            // Check that all Z coordinates are preserved (not NaN)
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon result, got \(result)")
        }
    }
}
