import XCTest
import GEOSwift

// MARK: - Tests

final class PolygonizeTests_XYZM: GEOSTestCase_XYZM {

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
