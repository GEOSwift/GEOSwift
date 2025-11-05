import XCTest
import GEOSwift

// MARK: - Tests

final class DifferenceTests_XYZ: OperationsTestCase_XYZ {

    func testDifferencePolygons() {
        let poly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0.5, 0, 0),
            XYZ(1.5, 0, 1),
            XYZ(1.5, 1, 2),
            XYZ(0.5, 1, 3),
            XYZ(0.5, 0, 0)]))
        let expectedPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(1, 0, 0),
            XYZ(1.5, 0, 3),
            XYZ(1.5, 1, 2),
            XYZ(1, 1, 1),
            XYZ(1, 0, 0)]))

        // Difference returns only XY geometry and topological tests are XY only
        XCTAssertEqual(try? poly.difference(with: unitPoly)?.isTopologicallyEquivalent(to: expectedPoly),
                       true)
    }

    func testDifferenceAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.difference(with: g2)
            } catch {
                XCTFail("Unexpected error for \(g1) difference(with: \(g2)) \(error)")
            }
        }
    }

    // MARK: - Z Preservation Tests

    func testDifferencePreservesZ() throws {
        // Test that difference() preserves Z coordinates when input has Z
        let poly1 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 10),
            XYZ(4, 0, 20),
            XYZ(4, 4, 30),
            XYZ(0, 4, 40),
            XYZ(0, 0, 10)]))
        let poly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(2, 2, 15),
            XYZ(6, 2, 25),
            XYZ(6, 6, 35),
            XYZ(2, 6, 45),
            XYZ(2, 2, 15)]))

        let result: Geometry<XYZ>? = try poly1.difference(with: poly2)

        // Verify the result is XYZ type
        guard let result = result else {
            XCTFail("Expected result, got nil")
            return
        }

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

    func testDifferencePreservesZForLineStrings() throws {
        // Test that difference() preserves Z for line strings
        let line1 = try! LineString(coordinates: [
            XYZ(0, 0, 5),
            XYZ(4, 0, 10)])
        let line2 = try! LineString(coordinates: [
            XYZ(2, 0, 7),
            XYZ(6, 0, 12)])

        let result: Geometry<XYZ>? = try line1.difference(with: line2)

        guard let result = result else {
            XCTFail("Expected result, got nil")
            return
        }

        // The result should preserve Z coordinates
        switch result {
        case let .lineString(line):
            for coord in line.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        case let .multiLineString(multiLine):
            for line in multiLine.lineStrings {
                for coord in line.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            }
        default:
            // Other geometry types are also acceptable
            break
        }
    }

    func testDifferencePreservesZForPolygonWithHole() throws {
        // Test that difference() preserves Z for complex polygons
        let outerPoly = try! Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYZ(0, 0, 1),
                XYZ(10, 0, 2),
                XYZ(10, 10, 3),
                XYZ(0, 10, 4),
                XYZ(0, 0, 1)]))
        let innerPoly = try! Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYZ(2, 2, 5),
                XYZ(8, 2, 6),
                XYZ(8, 8, 7),
                XYZ(2, 8, 8),
                XYZ(2, 2, 5)]))

        let result: Geometry<XYZ>? = try outerPoly.difference(with: innerPoly)

        guard let result = result else {
            XCTFail("Expected result, got nil")
            return
        }

        switch result {
        case let .polygon(polygon):
            // Check exterior ring Z coordinates
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Exterior Z coordinate should not be NaN")
            }
            // Check hole Z coordinates
            for hole in polygon.holes {
                for coord in hole.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Hole Z coordinate should not be NaN")
                }
            }
        default:
            XCTFail("Expected polygon result, got \(result)")
        }
    }

    func testDifferencePreservesZForMultiPolygon() throws {
        // Test that difference() preserves Z when result is a multipolygon
        let largePoly = try! Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYZ(0, 0, 10),
                XYZ(20, 0, 20),
                XYZ(20, 10, 30),
                XYZ(0, 10, 40),
                XYZ(0, 0, 10)]))
        let middlePoly = try! Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYZ(8, 2, 15),
                XYZ(12, 2, 25),
                XYZ(12, 8, 35),
                XYZ(8, 8, 45),
                XYZ(8, 2, 15)]))

        let result: Geometry<XYZ>? = try largePoly.difference(with: middlePoly)

        guard let result = result else {
            XCTFail("Expected result, got nil")
            return
        }

        // Result could be a polygon or multipolygon
        switch result {
        case let .polygon(polygon):
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        case let .multiPolygon(multiPoly):
            for polygon in multiPoly.polygons {
                for coord in polygon.exterior.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            }
        default:
            // Other types are also acceptable
            break
        }
    }

    func testDifferencePreservesZForNonOverlappingGeometries() throws {
        // Test that difference() preserves Z when geometries don't overlap
        let poly1 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 100),
            XYZ(2, 0, 200),
            XYZ(2, 2, 300),
            XYZ(0, 2, 400),
            XYZ(0, 0, 100)]))
        let poly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(5, 5, 150),
            XYZ(7, 5, 250),
            XYZ(7, 7, 350),
            XYZ(5, 7, 450),
            XYZ(5, 5, 150)]))

        let result: Geometry<XYZ>? = try poly1.difference(with: poly2)

        guard let result = result else {
            XCTFail("Expected result, got nil")
            return
        }

        // Result should be equal to poly1 with Z preserved
        switch result {
        case let .polygon(polygon):
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon result, got \(result)")
        }
    }

    func testDifferencePreservesZWhenResultIsEmpty() throws {
        // Test behavior when first geometry is completely contained in second
        let smallPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(2, 2, 10),
            XYZ(3, 2, 20),
            XYZ(3, 3, 30),
            XYZ(2, 3, 40),
            XYZ(2, 2, 10)]))
        let largePoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 5),
            XYZ(10, 0, 15),
            XYZ(10, 10, 25),
            XYZ(0, 10, 35),
            XYZ(0, 0, 5)]))

        let result: Geometry<XYZ>? = try smallPoly.difference(with: largePoly)

        // Result should be nil (empty) when first geometry is completely inside second
        XCTAssertNil(result, "Expected nil result when geometry is completely contained")
    }

    // MARK: - Mixed Dimension Tests

    func testDifferenceMixedDimensionsXYZWithXY() throws {
        // Test XYZ.difference(XY) returns XYZ
        let terrainPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 10),
            XYZ(4, 0, 20),
            XYZ(4, 4, 30),
            XYZ(0, 4, 40),
            XYZ(0, 0, 10)]))
        let flatPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(2, 2),
            XY(6, 2),
            XY(6, 6),
            XY(2, 6),
            XY(2, 2)]))

        let result: Geometry<XYZ>? = try terrainPoly.difference(with: flatPoly)

        guard let result = result else {
            XCTFail("Expected result, got nil")
            return
        }

        // Result should have Z coordinates from the first (terrain) geometry
        switch result {
        case let .polygon(polygon):
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon result, got \(result)")
        }
    }

    func testDifferenceMixedDimensionsXYWithXYZ() throws {
        // Test XY.difference(XYZ) returns XYZ
        let flatPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 0),
            XY(4, 0),
            XY(4, 4),
            XY(0, 4),
            XY(0, 0)]))
        let terrainPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(2, 2, 10),
            XYZ(6, 2, 20),
            XYZ(6, 6, 30),
            XYZ(2, 6, 40),
            XYZ(2, 2, 10)]))

        let result: Geometry<XYZ>? = try flatPoly.difference(with: terrainPoly)

        guard let result = result else {
            XCTFail("Expected result, got nil")
            return
        }

        // Result should have Z coordinates (from the second geometry where applicable)
        switch result {
        case let .polygon(polygon):
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon result, got \(result)")
        }
    }

    func testDifferenceMixedDimensionsXYZMWithXY() throws {
        // Test XYZM.difference(XY) returns XYZ (M is dropped)
        let xyzm = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 10, 100),
            XYZM(4, 0, 20, 200),
            XYZM(4, 4, 30, 300),
            XYZM(0, 4, 40, 400),
            XYZM(0, 0, 10, 100)]))
        let xy = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(2, 2),
            XY(6, 2),
            XY(6, 6),
            XY(2, 6),
            XY(2, 2)]))

        let result: Geometry<XYZ>? = try xyzm.difference(with: xy)

        guard let result = result else {
            XCTFail("Expected result, got nil")
            return
        }

        // Result should have Z coordinates (M is dropped)
        switch result {
        case let .polygon(polygon):
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon result, got \(result)")
        }
    }

    func testDifferenceMixedDimensionsXYMWithXYZ() throws {
        // Test XYM.difference(XYZ) returns XYZ
        let xym = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0, 0, 100),
            XYM(4, 0, 200),
            XYM(4, 4, 300),
            XYM(0, 4, 400),
            XYM(0, 0, 100)]))
        let xyz = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(2, 2, 10),
            XYZ(6, 2, 20),
            XYZ(6, 6, 30),
            XYZ(2, 6, 40),
            XYZ(2, 2, 10)]))

        let result: Geometry<XYZ>? = try xym.difference(with: xyz)

        guard let result = result else {
            XCTFail("Expected result, got nil")
            return
        }

        // Result should have Z coordinates from the second geometry
        switch result {
        case let .polygon(polygon):
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon result, got \(result)")
        }
    }
}
