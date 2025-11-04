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

final class SymmetricDifferenceTests_XYZ: XCTestCase {
    let unitPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
        XYZ(0, 0, 1),
        XYZ(1, 0, 2),
        XYZ(1, 1, 3),
        XYZ(0, 1, 4),
        XYZ(0, 0, 1)]))

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

    func testSymmetricDifferencePolygons() throws {
        let poly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0.5, 0, 0),
            XYZ(1.5, 0, 1),
            XYZ(1.5, 1, 2),
            XYZ(0.5, 1, 3),
            XYZ(0.5, 0, 0)]))
        let expected = try! MultiPolygon(polygons: [
            Polygon(exterior: Polygon.LinearRing(coordinates: [
                XYZ(1, 0, 0),
                XYZ(1.5, 0, 3),
                XYZ(1.5, 1, 5),
                XYZ(1, 1, 7),
                XYZ(1, 0, 0)])),
            Polygon(exterior: Polygon.LinearRing(coordinates: [
                XYZ(0, 0, 1),
                XYZ(0.5, 0, 3),
                XYZ(0.5, 1, 5),
                XYZ(0, 1, 7),
                XYZ(0, 0, 1)]))])

        // Symmetric difference preserves Z and topological tests are XY only
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
            XYZ(0, 0, 10),
            XYZ(4, 0, 20),
            XYZ(4, 4, 30),
            XYZ(0, 4, 40),
            XYZ(0, 0, 10)]))
        let polygon2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(2, 2, 15),
            XYZ(6, 2, 25),
            XYZ(6, 6, 35),
            XYZ(2, 6, 45),
            XYZ(2, 2, 15)]))
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
            XCTFail("Expected polygon or multipolygon result, got \(String(describing: result))")
        }
    }

    func testSymmetricDifferenceLineStringsPreservesZ() throws {
        let line1 = try! LineString(coordinates: [XYZ(0, 0, 10), XYZ(4, 0, 20)])
        let line2 = try! LineString(coordinates: [XYZ(2, 0, 15), XYZ(6, 0, 25)])
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
        let point1 = Point(XYZ(1, 2, 100))
        let point2 = Point(XYZ(3, 4, 150))
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
            XYZ(0, 0, 10),
            XYZ(2, 0, 20),
            XYZ(2, 2, 30),
            XYZ(0, 2, 40),
            XYZ(0, 0, 10)]))
        let polygon2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(1, 1, 15),
            XYZ(3, 1, 25),
            XYZ(3, 3, 35),
            XYZ(1, 3, 45),
            XYZ(1, 1, 15)]))
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
                XYZ(0, 0, 10),
                XYZ(4, 0, 20),
                XYZ(4, 4, 30),
                XYZ(0, 4, 40),
                XYZ(0, 0, 10)]),
            holes: [Polygon.LinearRing(coordinates: [
                XYZ(1, 1, 15),
                XYZ(1, 3, 25),
                XYZ(3, 3, 35),
                XYZ(3, 1, 45),
                XYZ(1, 1, 15)])])
        let otherPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(2, 2, 12),
            XYZ(6, 2, 22),
            XYZ(6, 6, 32),
            XYZ(2, 6, 42),
            XYZ(2, 2, 12)]))
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
        let point = Point(XYZ(5, 5, 100))
        let line = try! LineString(coordinates: [XYZ(0, 0, 10), XYZ(4, 0, 20)])
        let geometryCollection = GeometryCollection(geometries: [point, line])
        let polygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(1, -1, 15),
            XYZ(3, -1, 25),
            XYZ(3, 1, 35),
            XYZ(1, 1, 45),
            XYZ(1, -1, 15)]))
        let result: Geometry<XYZ>? = try geometryCollection.symmetricDifference(with: polygon)
        XCTAssertNotNil(result)
    }

    // MARK: - Mixed Dimension Tests

    func testSymmetricDifferenceMixedDimensionsXYZWithXY() throws {
        // Test XYZ.symmetricDifference(XY) returns XYZ
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

    func testSymmetricDifferenceMixedDimensionsXYWithXYZ() throws {
        // Test XY.symmetricDifference(XYZ) returns XYZ
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

    func testSymmetricDifferenceMixedDimensionsXYMWithXYZ() throws {
        // Test XYM.symmetricDifference(XYZ) returns XYZ
        let flatPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0, 0, 100),
            XYM(4, 0, 200),
            XYM(4, 4, 300),
            XYM(0, 4, 400),
            XYM(0, 0, 100)]))
        let terrainPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(2, 2, 10),
            XYZ(6, 2, 20),
            XYZ(6, 6, 30),
            XYZ(2, 6, 40),
            XYZ(2, 2, 10)]))
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
