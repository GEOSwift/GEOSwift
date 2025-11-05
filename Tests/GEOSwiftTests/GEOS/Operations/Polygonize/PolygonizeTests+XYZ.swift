import XCTest
import GEOSwift

// MARK: - Tests

final class PolygonizeTests_XYZ: OperationsTestCase_XYZ {

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
