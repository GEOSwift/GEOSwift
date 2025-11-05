import XCTest
import GEOSwift

// MARK: - Tests

final class ConcaveHullTests_XYZM: OperationsTestCase_XYZM {

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
        // Note: M coordinates are not preserved (XYZ is returned, not XYZM)
        let polygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 10, 100),
            XYZM(4, 0, 20, 200),
            XYZM(4, 4, 30, 300),
            XYZM(0, 4, 40, 400),
            XYZM(0, 0, 10, 100)]))

        let result: Geometry<XYZ> = try polygon.concaveHull(withRatio: 0.5, allowHoles: false)

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

    func testConcaveHullPreservesZForPoint() throws {
        // Test that concaveHull() preserves Z for points
        let pointWithZ = Point(XYZM(1, 2, 42, 100))

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
            XYZM(0, 0, 5, 50),
            XYZM(1, 1, 10, 100)])

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
            Point(XYZM(0, 0, 100, 1000)),
            Point(XYZM(4, 0, 200, 2000)),
            Point(XYZM(4, 4, 300, 3000)),
            Point(XYZM(0, 4, 400, 4000))])

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
            Geometry.point(Point(XYZM(0, 0, 50, 500))),
            Geometry.point(Point(XYZM(4, 0, 60, 600))),
            Geometry.point(Point(XYZM(4, 4, 70, 700))),
            Geometry.point(Point(XYZM(0, 4, 80, 800)))
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
                XYZM(0, 0, 1, 10),
                XYZM(8, 0, 2, 20),
                XYZM(8, 8, 3, 30),
                XYZM(0, 8, 4, 40),
                XYZM(0, 0, 1, 10)]),
            holes: [
                Polygon.LinearRing(coordinates: [
                    XYZM(2, 2, 5, 50),
                    XYZM(6, 2, 6, 60),
                    XYZM(6, 6, 7, 70),
                    XYZM(2, 6, 8, 80),
                    XYZM(2, 2, 5, 50)])
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
