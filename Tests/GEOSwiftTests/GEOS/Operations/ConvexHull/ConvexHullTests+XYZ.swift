import XCTest
import GEOSwift

// MARK: - Tests

final class ConvexHullTests_XYZ: GEOSTestCase_XYZ {

    func testConvexHullPolygon() {
        let polygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 0),
            XYZ(1, 0, 0),
            XYZ(0.1, 0.1, 0),
            XYZ(0, 1, 0),
            XYZ(0, 0, 0)]))
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
        let polygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 10),
            XYZ(1, 0, 20),
            XYZ(0.1, 0.1, 15),
            XYZ(0, 1, 30),
            XYZ(0, 0, 10)]))

        let result: Geometry<XYZ> = try polygon.convexHull()

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

    func testConvexHullPreservesZForPoint() throws {
        // Test that convexHull() preserves Z for points
        let pointWithZ = Point(XYZ(1, 2, 42))

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
            XYZ(0, 0, 5),
            XYZ(1, 1, 10)])

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
            Point(XYZ(0, 0, 100)),
            Point(XYZ(1, 0, 200)),
            Point(XYZ(1, 1, 300)),
            Point(XYZ(0, 1, 400))])

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
            Geometry.point(Point(XYZ(0, 0, 50))),
            Geometry.point(Point(XYZ(1, 0, 60))),
            Geometry.point(Point(XYZ(1, 1, 70))),
            Geometry.point(Point(XYZ(0, 1, 80)))
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
                XYZ(0, 0, 1),
                XYZ(4, 0, 2),
                XYZ(4, 4, 3),
                XYZ(0, 4, 4),
                XYZ(0, 0, 1)]),
            holes: [
                Polygon.LinearRing(coordinates: [
                    XYZ(1, 1, 5),
                    XYZ(3, 1, 6),
                    XYZ(3, 3, 7),
                    XYZ(1, 3, 8),
                    XYZ(1, 1, 5)])
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
