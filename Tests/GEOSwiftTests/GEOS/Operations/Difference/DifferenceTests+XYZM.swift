import XCTest
import GEOSwift

// MARK: - Tests

final class DifferenceTests_XYZM: GEOSTestCase_XYZM {

    func testDifferencePolygons() {
        let poly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0.5, 0, 0, 0),
            XYZM(1.5, 0, 1, 1),
            XYZM(1.5, 1, 2, 2),
            XYZM(0.5, 1, 3, 3),
            XYZM(0.5, 0, 0, 0)]))
        let expectedPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(1, 0, 0, 0),
            XYZM(1.5, 0, 3, 1),
            XYZM(1.5, 1, 2, 2),
            XYZM(1, 1, 1, 3),
            XYZM(1, 0, 0, 0)]))

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
        // Note: M coordinates are not preserved (XYZ is returned, not XYZM)
        let poly1 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 10, 100),
            XYZM(4, 0, 20, 200),
            XYZM(4, 4, 30, 300),
            XYZM(0, 4, 40, 400),
            XYZM(0, 0, 10, 100)]))
        let poly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(2, 2, 15, 150),
            XYZM(6, 2, 25, 250),
            XYZM(6, 6, 35, 350),
            XYZM(2, 6, 45, 450),
            XYZM(2, 2, 15, 150)]))

        let result: Geometry<XYZ>? = try poly1.difference(with: poly2)

        // Verify the result is XYZ type (M is lost)
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
            XYZM(0, 0, 5, 50),
            XYZM(4, 0, 10, 100)])
        let line2 = try! LineString(coordinates: [
            XYZM(2, 0, 7, 70),
            XYZM(6, 0, 12, 120)])

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
                XYZM(0, 0, 1, 10),
                XYZM(10, 0, 2, 20),
                XYZM(10, 10, 3, 30),
                XYZM(0, 10, 4, 40),
                XYZM(0, 0, 1, 10)]))
        let innerPoly = try! Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYZM(2, 2, 5, 50),
                XYZM(8, 2, 6, 60),
                XYZM(8, 8, 7, 70),
                XYZM(2, 8, 8, 80),
                XYZM(2, 2, 5, 50)]))

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
                XYZM(0, 0, 10, 100),
                XYZM(20, 0, 20, 200),
                XYZM(20, 10, 30, 300),
                XYZM(0, 10, 40, 400),
                XYZM(0, 0, 10, 100)]))
        let middlePoly = try! Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYZM(8, 2, 15, 150),
                XYZM(12, 2, 25, 250),
                XYZM(12, 8, 35, 350),
                XYZM(8, 8, 45, 450),
                XYZM(8, 2, 15, 150)]))

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
            XYZM(0, 0, 100, 1000),
            XYZM(2, 0, 200, 2000),
            XYZM(2, 2, 300, 3000),
            XYZM(0, 2, 400, 4000),
            XYZM(0, 0, 100, 1000)]))
        let poly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(5, 5, 150, 1500),
            XYZM(7, 5, 250, 2500),
            XYZM(7, 7, 350, 3500),
            XYZM(5, 7, 450, 4500),
            XYZM(5, 5, 150, 1500)]))

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
            XYZM(2, 2, 10, 100),
            XYZM(3, 2, 20, 200),
            XYZM(3, 3, 30, 300),
            XYZM(2, 3, 40, 400),
            XYZM(2, 2, 10, 100)]))
        let largePoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 5, 50),
            XYZM(10, 0, 15, 150),
            XYZM(10, 10, 25, 250),
            XYZM(0, 10, 35, 350),
            XYZM(0, 0, 5, 50)]))

        let result: Geometry<XYZ>? = try smallPoly.difference(with: largePoly)

        // Result should be nil (empty) when first geometry is completely inside second
        XCTAssertNil(result, "Expected nil result when geometry is completely contained")
    }

    // MARK: - Mixed Dimension Tests

    func testDifferenceMixedDimensionsXYZMWithXY() throws {
        // Test XYZM.difference(XY) returns XYZ (M is dropped)
        let xyzmPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 10, 100),
            XYZM(4, 0, 20, 200),
            XYZM(4, 4, 30, 300),
            XYZM(0, 4, 40, 400),
            XYZM(0, 0, 10, 100)]))
        let xyPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(2, 2),
            XY(6, 2),
            XY(6, 6),
            XY(2, 6),
            XY(2, 2)]))

        let result: Geometry<XYZ>? = try xyzmPoly.difference(with: xyPoly)

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

    func testDifferenceMixedDimensionsXYWithXYZM() throws {
        // Test XY.difference(XYZM) returns XYZ (second has Z, M is dropped)
        let xyPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 0),
            XY(4, 0),
            XY(4, 4),
            XY(0, 4),
            XY(0, 0)]))
        let xyzmPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(2, 2, 10, 100),
            XYZM(6, 2, 20, 200),
            XYZM(6, 6, 30, 300),
            XYZM(2, 6, 40, 400),
            XYZM(2, 2, 10, 100)]))

        let result: Geometry<XYZ>? = try xyPoly.difference(with: xyzmPoly)

        guard let result = result else {
            XCTFail("Expected result, got nil")
            return
        }

        // Result should have Z coordinates (from second geometry, M is dropped)
        switch result {
        case let .polygon(polygon):
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon result, got \(result)")
        }
    }

    func testDifferenceMixedDimensionsXYZMWithXYZ() throws {
        // Test XYZM.difference(XYZ) returns XYZ (both have Z, M is dropped)
        let xyzmPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 10, 100),
            XYZM(4, 0, 20, 200),
            XYZM(4, 4, 30, 300),
            XYZM(0, 4, 40, 400),
            XYZM(0, 0, 10, 100)]))
        let xyzPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(2, 2, 15),
            XYZ(6, 2, 25),
            XYZ(6, 6, 35),
            XYZ(2, 6, 45),
            XYZ(2, 2, 15)]))

        let result: Geometry<XYZ>? = try xyzmPoly.difference(with: xyzPoly)

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

    func testDifferenceMixedDimensionsXYMWithXYZM() throws {
        // Test XYM.difference(XYZM) returns XYZ (second has Z)
        let xymPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0, 0, 100),
            XYM(4, 0, 200),
            XYM(4, 4, 300),
            XYM(0, 4, 400),
            XYM(0, 0, 100)]))
        let xyzmPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(2, 2, 10, 1000),
            XYZM(6, 2, 20, 2000),
            XYZM(6, 6, 30, 3000),
            XYZM(2, 6, 40, 4000),
            XYZM(2, 2, 10, 1000)]))

        let result: Geometry<XYZ>? = try xymPoly.difference(with: xyzmPoly)

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
