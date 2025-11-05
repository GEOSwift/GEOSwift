import XCTest
import GEOSwift

// MARK: - Tests

final class ConvexHullTests_XYZM: XCTestCase {
    // Use XYZM fixtures directly
    let point1 = Fixtures.point1
    let lineString1 = Fixtures.lineString1
    let linearRingHole1 = Fixtures.linearRingHole1
    let polygonWithHole = Fixtures.polygonWithHole
    let multiPoint = Fixtures.multiPoint
    let multiLineString = Fixtures.multiLineString
    let multiPolygon = Fixtures.multiPolygon
    let geometryCollection = Fixtures.geometryCollection
    let recursiveGeometryCollection = Fixtures.recursiveGeometryCollection

    // Geometry convertibles array
    lazy var geometryConvertibles: [any GeometryConvertible<XYZM>] = [
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

    func testConvexHullPolygon() {
        let polygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 0, 0),
            XYZM(1, 0, 0, 1),
            XYZM(0.1, 0.1, 0, 2),
            XYZM(0, 1, 0, 3),
            XYZM(0, 0, 0, 0)]))
        // not sure why the result's shell is cw instead of ccw; need to follow up with GEOS team
        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 0),
            XY(0, 1),
            XY(1, 0),
            XY(0, 0)]))

        // Convex Hull can return XY geometry
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

    // MARK: - Z Preservation Tests

    func testConvexHullPreservesZ() throws {
        // Test that convexHull() preserves Z coordinates when input has Z
        // Note: M coordinates are not preserved (XYZ is returned, not XYZM)
        let polygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 10, 100),
            XYZM(1, 0, 20, 200),
            XYZM(0.1, 0.1, 15, 150),
            XYZM(0, 1, 30, 300),
            XYZM(0, 0, 10, 100)]))

        let result: Geometry<XYZ> = try polygon.convexHull()

        // Verify the result is XYZ type (M is lost)
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

    func testConvexHullPreservesZForPoint() throws {
        // Test that convexHull() preserves Z for points
        let pointWithZ = Point(XYZM(1, 2, 42, 100))

        let result: Geometry<XYZ> = try pointWithZ.convexHull()

        switch result {
        case let .point(point):
            XCTAssertEqual(point.coordinates.z, 42, accuracy: 0.001)
        default:
            XCTFail("Expected point result, got \(result)")
        }
    }

    func testConvexHullPreservesZForLineString() throws {
        // Test that convexHull() preserves Z for line strings
        let lineWithZ = try! LineString(coordinates: [
            XYZM(0, 0, 5, 50),
            XYZM(1, 1, 10, 100)])

        let result: Geometry<XYZ> = try lineWithZ.convexHull()

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

    func testConvexHullPreservesZForMultiPoint() throws {
        // Test that convexHull() preserves Z for multi points forming a polygon
        let multiPointWithZ = MultiPoint(points: [
            Point(XYZM(0, 0, 100, 1000)),
            Point(XYZM(1, 0, 200, 2000)),
            Point(XYZM(1, 1, 300, 3000)),
            Point(XYZM(0, 1, 400, 4000))])

        let result: Geometry<XYZ> = try multiPointWithZ.convexHull()

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

    func testConvexHullPreservesZForGeometryCollection() throws {
        // Test that convexHull() preserves Z for geometry collections
        let collectionWithZ = GeometryCollection(geometries: [
            Geometry.point(Point(XYZM(0, 0, 50, 500))),
            Geometry.point(Point(XYZM(1, 0, 60, 600))),
            Geometry.point(Point(XYZM(1, 1, 70, 700))),
            Geometry.point(Point(XYZM(0, 1, 80, 800)))
        ])

        let result: Geometry<XYZ> = try collectionWithZ.convexHull()

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

    func testConvexHullPreservesZForPolygonWithHole() throws {
        // Test that convexHull() preserves Z for polygons with holes
        let polyWithZ = try! Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYZM(0, 0, 1, 10),
                XYZM(4, 0, 2, 20),
                XYZM(4, 4, 3, 30),
                XYZM(0, 4, 4, 40),
                XYZM(0, 0, 1, 10)]),
            holes: [
                Polygon.LinearRing(coordinates: [
                    XYZM(1, 1, 5, 50),
                    XYZM(3, 1, 6, 60),
                    XYZM(3, 3, 7, 70),
                    XYZM(1, 3, 8, 80),
                    XYZM(1, 1, 5, 50)])
            ])

        let result: Geometry<XYZ> = try polyWithZ.convexHull()

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
