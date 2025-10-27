import XCTest
import GEOSwift

final class GeometryCollectionTestsXY: XCTestCase {
    func testInitWithGeometries() {
        let geometries = makeGeometries(withTypes: [.point, .geometryCollection, .multiLineString])

        let collection = GeometryCollection(geometries: geometries)

        XCTAssertEqual(collection.geometries, geometries)
    }

    func testInitWithXYZ() throws {
        let point = Point(x: 1, y: 2, z: 3)
        let lineString = try LineString(coordinates: [XYZ(4, 5, 6), XYZ(7, 8, 9)])
        let collection1 = GeometryCollection(geometries: [point, lineString])
        let collection2 = GeometryCollection<XY>(collection1)

        XCTAssertEqual(collection2.geometries.count, 2)

        // Verify first geometry (Point)
        guard case .point(let projectedPoint) = collection2.geometries[0] else {
            XCTFail("Expected point geometry")
            return
        }
        XCTAssertEqual(projectedPoint.x, 1)
        XCTAssertEqual(projectedPoint.y, 2)

        // Verify second geometry (LineString)
        guard case .lineString(let projectedLineString) = collection2.geometries[1] else {
            XCTFail("Expected lineString geometry")
            return
        }
        XCTAssertEqual(projectedLineString.coordinates.count, 2)
        XCTAssertEqual(projectedLineString.coordinates[0].x, 4)
        XCTAssertEqual(projectedLineString.coordinates[0].y, 5)
        XCTAssertEqual(projectedLineString.coordinates[1].x, 7)
        XCTAssertEqual(projectedLineString.coordinates[1].y, 8)
    }

    func testInitWithXYM() throws {
        let point = Point(x: 1, y: 2, m: 3)
        let lineString = try LineString(coordinates: [XYM(4, 5, 6), XYM(7, 8, 9)])
        let collection1 = GeometryCollection(geometries: [point, lineString])
        let collection2 = GeometryCollection<XY>(collection1)

        XCTAssertEqual(collection2.geometries.count, 2)

        // Verify first geometry (Point)
        guard case .point(let projectedPoint) = collection2.geometries[0] else {
            XCTFail("Expected point geometry")
            return
        }
        XCTAssertEqual(projectedPoint.x, 1)
        XCTAssertEqual(projectedPoint.y, 2)

        // Verify second geometry (LineString)
        guard case .lineString(let projectedLineString) = collection2.geometries[1] else {
            XCTFail("Expected lineString geometry")
            return
        }
        XCTAssertEqual(projectedLineString.coordinates.count, 2)
        XCTAssertEqual(projectedLineString.coordinates[0].x, 4)
        XCTAssertEqual(projectedLineString.coordinates[0].y, 5)
        XCTAssertEqual(projectedLineString.coordinates[1].x, 7)
        XCTAssertEqual(projectedLineString.coordinates[1].y, 8)
    }

    func testInitWithXYZM() throws {
        let point = Point(x: 1, y: 2, z: 3, m: 4)
        let lineString = try LineString(coordinates: [XYZM(5, 6, 7, 8), XYZM(9, 10, 11, 12)])
        let collection1 = GeometryCollection(geometries: [point, lineString])
        let collection2 = GeometryCollection<XY>(collection1)

        XCTAssertEqual(collection2.geometries.count, 2)

        // Verify first geometry (Point)
        guard case .point(let projectedPoint) = collection2.geometries[0] else {
            XCTFail("Expected point geometry")
            return
        }
        XCTAssertEqual(projectedPoint.x, 1)
        XCTAssertEqual(projectedPoint.y, 2)

        // Verify second geometry (LineString)
        guard case .lineString(let projectedLineString) = collection2.geometries[1] else {
            XCTFail("Expected lineString geometry")
            return
        }
        XCTAssertEqual(projectedLineString.coordinates.count, 2)
        XCTAssertEqual(projectedLineString.coordinates[0].x, 5)
        XCTAssertEqual(projectedLineString.coordinates[0].y, 6)
        XCTAssertEqual(projectedLineString.coordinates[1].x, 9)
        XCTAssertEqual(projectedLineString.coordinates[1].y, 10)
    }
}

final class GeometryCollectionTestsXYZ: XCTestCase {
    func testInitWithXYZM() throws {
        let point = Point(x: 1, y: 2, z: 3, m: 4)
        let lineString = try LineString(coordinates: [XYZM(5, 6, 7, 8), XYZM(9, 10, 11, 12)])
        let collection1 = GeometryCollection(geometries: [point, lineString])
        let collection2 = GeometryCollection<XYZ>(collection1)

        XCTAssertEqual(collection2.geometries.count, 2)

        // Verify first geometry (Point)
        guard case .point(let projectedPoint) = collection2.geometries[0] else {
            XCTFail("Expected point geometry")
            return
        }
        XCTAssertEqual(projectedPoint.x, 1)
        XCTAssertEqual(projectedPoint.y, 2)
        XCTAssertEqual(projectedPoint.z, 3)

        // Verify second geometry (LineString)
        guard case .lineString(let projectedLineString) = collection2.geometries[1] else {
            XCTFail("Expected lineString geometry")
            return
        }
        XCTAssertEqual(projectedLineString.coordinates.count, 2)
        XCTAssertEqual(projectedLineString.coordinates[0].x, 5)
        XCTAssertEqual(projectedLineString.coordinates[0].y, 6)
        XCTAssertEqual(projectedLineString.coordinates[0].z, 7)
        XCTAssertEqual(projectedLineString.coordinates[1].x, 9)
        XCTAssertEqual(projectedLineString.coordinates[1].y, 10)
        XCTAssertEqual(projectedLineString.coordinates[1].z, 11)
    }
}

final class GeometryCollectionTestsXYM: XCTestCase {
    func testInitWithXYZM() throws {
        let point = Point(x: 1, y: 2, z: 3, m: 4)
        let lineString = try LineString(coordinates: [XYZM(5, 6, 7, 8), XYZM(9, 10, 11, 12)])
        let collection1 = GeometryCollection(geometries: [point, lineString])
        let collection2 = GeometryCollection<XYM>(collection1)

        XCTAssertEqual(collection2.geometries.count, 2)

        // Verify first geometry (Point)
        guard case .point(let projectedPoint) = collection2.geometries[0] else {
            XCTFail("Expected point geometry")
            return
        }
        XCTAssertEqual(projectedPoint.x, 1)
        XCTAssertEqual(projectedPoint.y, 2)
        XCTAssertEqual(projectedPoint.m, 4)

        // Verify second geometry (LineString)
        guard case .lineString(let projectedLineString) = collection2.geometries[1] else {
            XCTFail("Expected lineString geometry")
            return
        }
        XCTAssertEqual(projectedLineString.coordinates.count, 2)
        XCTAssertEqual(projectedLineString.coordinates[0].x, 5)
        XCTAssertEqual(projectedLineString.coordinates[0].y, 6)
        XCTAssertEqual(projectedLineString.coordinates[0].m, 8)
        XCTAssertEqual(projectedLineString.coordinates[1].x, 9)
        XCTAssertEqual(projectedLineString.coordinates[1].y, 10)
        XCTAssertEqual(projectedLineString.coordinates[1].m, 12)
    }
}

final class GeometryCollectionTestsXYZM: XCTestCase {
    func testInitWithXYZM() throws {
        let point = Point(x: 1, y: 2, z: 3, m: 4)
        let lineString = try LineString(coordinates: [XYZM(5, 6, 7, 8), XYZM(9, 10, 11, 12)])
        let collection1 = GeometryCollection(geometries: [point, lineString])
        let collection2 = GeometryCollection<XYZM>(collection1)

        XCTAssertEqual(collection2.geometries.count, 2)

        // Verify first geometry (Point)
        guard case .point(let projectedPoint) = collection2.geometries[0] else {
            XCTFail("Expected point geometry")
            return
        }
        XCTAssertEqual(projectedPoint.x, 1)
        XCTAssertEqual(projectedPoint.y, 2)
        XCTAssertEqual(projectedPoint.z, 3)
        XCTAssertEqual(projectedPoint.m, 4)

        // Verify second geometry (LineString)
        guard case .lineString(let projectedLineString) = collection2.geometries[1] else {
            XCTFail("Expected lineString geometry")
            return
        }
        XCTAssertEqual(projectedLineString.coordinates.count, 2)
        XCTAssertEqual(projectedLineString.coordinates[0].x, 5)
        XCTAssertEqual(projectedLineString.coordinates[0].y, 6)
        XCTAssertEqual(projectedLineString.coordinates[0].z, 7)
        XCTAssertEqual(projectedLineString.coordinates[0].m, 8)
        XCTAssertEqual(projectedLineString.coordinates[1].x, 9)
        XCTAssertEqual(projectedLineString.coordinates[1].y, 10)
        XCTAssertEqual(projectedLineString.coordinates[1].z, 11)
        XCTAssertEqual(projectedLineString.coordinates[1].m, 12)
    }
}
