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

final class SymmetricDifferenceTests_XYZM: XCTestCase {
    let unitPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
        XYZM(0, 0, 1, 10),
        XYZM(1, 0, 2, 20),
        XYZM(1, 1, 3, 30),
        XYZM(0, 1, 4, 40),
        XYZM(0, 0, 1, 10)]))

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

    func testSymmetricDifferencePolygons() throws {
        let poly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0.5, 0, 0, 0),
            XYZM(1.5, 0, 1, 1),
            XYZM(1.5, 1, 2, 2),
            XYZM(0.5, 1, 3, 3),
            XYZM(0.5, 0, 0, 0)]))
        let expected = try! MultiPolygon(polygons: [
            Polygon(exterior: Polygon.LinearRing(coordinates: [
                XYZM(1, 0, 0, 0),
                XYZM(1.5, 0, 3, 1),
                XYZM(1.5, 1, 5, 2),
                XYZM(1, 1, 7, 3),
                XYZM(1, 0, 0, 0)])),
            Polygon(exterior: Polygon.LinearRing(coordinates: [
                XYZM(0, 0, 1, 10),
                XYZM(0.5, 0, 3, 5),
                XYZM(0.5, 1, 5, 6),
                XYZM(0, 1, 7, 7),
                XYZM(0, 0, 1, 10)]))])

        // Symmetric difference preserves Z (drops M) and topological tests are XY only
        XCTAssertEqual(try? poly.symmetricDifference(with: unitPoly)?.isTopologicallyEquivalent(to: expected),
                       true)
    }

    func testSymmetricDifferenceAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.symmetricDifference(with: g2)
            } catch {
                XCTFail("Unexpected error for \(g1) symmetricDifference(with: \(g2)) \(error)")
            }
        }
    }

    // MARK: - Z Preservation Tests

    func testSymmetricDifferencePolygonsPreservesZ() throws {
        let polygon1 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 10, 100),
            XYZM(4, 0, 20, 200),
            XYZM(4, 4, 30, 300),
            XYZM(0, 4, 40, 400),
            XYZM(0, 0, 10, 100)]))
        let polygon2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(2, 2, 15, 150),
            XYZM(6, 2, 25, 250),
            XYZM(6, 6, 35, 350),
            XYZM(2, 6, 45, 450),
            XYZM(2, 2, 15, 150)]))
        let result: Geometry<XYZ>? = try polygon1.symmetricDifference(with: polygon2)
        XCTAssertNotNil(result)
        switch result {
        case let .multiPolygon(multiPolygon):
            for polygon in multiPolygon.polygons {
                for coord in polygon.exterior.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            }
        case let .polygon(polygon):
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon or multiPolygon result, got \(String(describing: result))")
        }
    }

    func testSymmetricDifferenceLineStringsPreservesZ() throws {
        let line1 = try! LineString(coordinates: [XYZM(0, 0, 10, 100), XYZM(4, 0, 20, 200)])
        let line2 = try! LineString(coordinates: [XYZM(2, 0, 15, 150), XYZM(6, 0, 25, 250)])
        let result: Geometry<XYZ>? = try line1.symmetricDifference(with: line2)
        XCTAssertNotNil(result)
        switch result {
        case let .multiLineString(multiLineString):
            for lineString in multiLineString.lineStrings {
                for coord in lineString.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            }
        case let .lineString(lineString):
            for coord in lineString.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected lineString or multiLineString result, got \(String(describing: result))")
        }
    }

    func testSymmetricDifferencePointsPreservesZ() throws {
        let point1 = Point(XYZM(1, 2, 100, 1000))
        let point2 = Point(XYZM(3, 4, 150, 1500))
        let result: Geometry<XYZ>? = try point1.symmetricDifference(with: point2)
        XCTAssertNotNil(result)
        switch result {
        case let .multiPoint(multiPoint):
            for point in multiPoint.points {
                XCTAssertFalse(point.coordinates.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected multiPoint result, got \(String(describing: result))")
        }
    }

    func testSymmetricDifferenceMultiPolygonsPreservesZ() throws {
        let polygon1 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 10, 100),
            XYZM(2, 0, 20, 200),
            XYZM(2, 2, 30, 300),
            XYZM(0, 2, 40, 400),
            XYZM(0, 0, 10, 100)]))
        let polygon2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(1, 1, 15, 150),
            XYZM(3, 1, 25, 250),
            XYZM(3, 3, 35, 350),
            XYZM(1, 3, 45, 450),
            XYZM(1, 1, 15, 150)]))
        let multiPolygon1 = MultiPolygon(polygons: [polygon1])
        let multiPolygon2 = MultiPolygon(polygons: [polygon2])
        let result: Geometry<XYZ>? = try multiPolygon1.symmetricDifference(with: multiPolygon2)
        XCTAssertNotNil(result)
        switch result {
        case let .multiPolygon(multiPolygon):
            for polygon in multiPolygon.polygons {
                for coord in polygon.exterior.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            }
        case let .polygon(polygon):
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon or multiPolygon result, got \(String(describing: result))")
        }
    }

    func testSymmetricDifferencePolygonWithHolePreservesZ() throws {
        let polygon = try! Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYZM(0, 0, 10, 100),
                XYZM(4, 0, 20, 200),
                XYZM(4, 4, 30, 300),
                XYZM(0, 4, 40, 400),
                XYZM(0, 0, 10, 100)]),
            holes: [Polygon.LinearRing(coordinates: [
                XYZM(1, 1, 15, 150),
                XYZM(1, 3, 25, 250),
                XYZM(3, 3, 35, 350),
                XYZM(3, 1, 45, 450),
                XYZM(1, 1, 15, 150)])])
        let otherPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(2, 2, 12, 120),
            XYZM(6, 2, 22, 220),
            XYZM(6, 6, 32, 320),
            XYZM(2, 6, 42, 420),
            XYZM(2, 2, 12, 120)]))
        let result: Geometry<XYZ>? = try polygon.symmetricDifference(with: otherPolygon)
        XCTAssertNotNil(result)
        switch result {
        case let .multiPolygon(multiPolygon):
            for polygon in multiPolygon.polygons {
                for coord in polygon.exterior.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN in exterior")
                }
                for hole in polygon.holes {
                    for coord in hole.coordinates {
                        XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN in hole")
                    }
                }
            }
        case let .polygon(polygon):
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN in exterior")
            }
            for hole in polygon.holes {
                for coord in hole.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN in hole")
                }
            }
        default:
            XCTFail("Expected polygon or multiPolygon result, got \(String(describing: result))")
        }
    }

    func testSymmetricDifferenceGeometryCollectionPreservesZ() throws {
        let point = Point(XYZM(5, 5, 100, 1000))
        let line = try! LineString(coordinates: [XYZM(0, 0, 10, 100), XYZM(4, 0, 20, 200)])
        let geometryCollection = GeometryCollection(geometries: [point, line])
        let polygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(1, -1, 15, 150),
            XYZM(3, -1, 25, 250),
            XYZM(3, 1, 35, 350),
            XYZM(1, 1, 45, 450),
            XYZM(1, -1, 15, 150)]))
        let result: Geometry<XYZ>? = try geometryCollection.symmetricDifference(with: polygon)
        XCTAssertNotNil(result)
    }

    // MARK: - Mixed Dimension Tests

    func testSymmetricDifferenceMixedDimensionsXYZMWithXY() throws {
        // Test XYZM.symmetricDifference(XY) returns XYZ
        let terrainPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 10, 100),
            XYZM(4, 0, 20, 200),
            XYZM(4, 4, 30, 300),
            XYZM(0, 4, 40, 400),
            XYZM(0, 0, 10, 100)]))
        let flatPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(2, 2),
            XY(6, 2),
            XY(6, 6),
            XY(2, 6),
            XY(2, 2)]))
        let result: Geometry<XYZ>? = try terrainPoly.symmetricDifference(with: flatPoly)
        XCTAssertNotNil(result)
        switch result {
        case let .multiPolygon(multiPolygon):
            for polygon in multiPolygon.polygons {
                for coord in polygon.exterior.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            }
        case let .polygon(polygon):
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon or multiPolygon result, got \(String(describing: result))")
        }
    }

    func testSymmetricDifferenceMixedDimensionsXYWithXYZM() throws {
        // Test XY.symmetricDifference(XYZM) returns XYZ
        let flatPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 0),
            XY(4, 0),
            XY(4, 4),
            XY(0, 4),
            XY(0, 0)]))
        let terrainPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(2, 2, 10, 100),
            XYZM(6, 2, 20, 200),
            XYZM(6, 6, 30, 300),
            XYZM(2, 6, 40, 400),
            XYZM(2, 2, 10, 100)]))
        let result: Geometry<XYZ>? = try flatPoly.symmetricDifference(with: terrainPoly)
        XCTAssertNotNil(result)
        switch result {
        case let .multiPolygon(multiPolygon):
            for polygon in multiPolygon.polygons {
                for coord in polygon.exterior.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            }
        case let .polygon(polygon):
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon or multiPolygon result, got \(String(describing: result))")
        }
    }

    func testSymmetricDifferenceMixedDimensionsXYZMWithXYZ() throws {
        // Test XYZM.symmetricDifference(XYZ) returns XYZ
        let terrainPoly1 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 10, 100),
            XYZM(4, 0, 20, 200),
            XYZM(4, 4, 30, 300),
            XYZM(0, 4, 40, 400),
            XYZM(0, 0, 10, 100)]))
        let terrainPoly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(2, 2, 15),
            XYZ(6, 2, 25),
            XYZ(6, 6, 35),
            XYZ(2, 6, 45),
            XYZ(2, 2, 15)]))
        let result: Geometry<XYZ>? = try terrainPoly1.symmetricDifference(with: terrainPoly2)
        XCTAssertNotNil(result)
        switch result {
        case let .multiPolygon(multiPolygon):
            for polygon in multiPolygon.polygons {
                for coord in polygon.exterior.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            }
        case let .polygon(polygon):
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon or multiPolygon result, got \(String(describing: result))")
        }
    }

    func testSymmetricDifferenceMixedDimensionsXYMWithXYZM() throws {
        // Test XYM.symmetricDifference(XYZM) returns XYZ
        let flatPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0, 0, 100),
            XYM(4, 0, 200),
            XYM(4, 4, 300),
            XYM(0, 4, 400),
            XYM(0, 0, 100)]))
        let terrainPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(2, 2, 10, 100),
            XYZM(6, 2, 20, 200),
            XYZM(6, 6, 30, 300),
            XYZM(2, 6, 40, 400),
            XYZM(2, 2, 10, 100)]))
        let result: Geometry<XYZ>? = try flatPoly.symmetricDifference(with: terrainPoly)
        XCTAssertNotNil(result)
        switch result {
        case let .multiPolygon(multiPolygon):
            for polygon in multiPolygon.polygons {
                for coord in polygon.exterior.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            }
        case let .polygon(polygon):
            for coord in polygon.exterior.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon or multiPolygon result, got \(String(describing: result))")
        }
    }
}
