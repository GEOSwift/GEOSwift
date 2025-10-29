import XCTest
import GEOSwift

final class WKBReaderTests: XCTestCase {

    // MARK: - Initialization Tests

    func testInitWithDefaultContext() throws {
        let reader = try WKBReader()
        XCTAssertNotNil(reader)
    }

    // MARK: - Read Tests - XY Coordinate Type

    func testReadAnyXYPoint() throws {
        let point = Point(x: 1, y: 2)
        let wkb = try point.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 2)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = anyGeometry.asGeometryXY()
        XCTAssertEqual(recovered, point.geometry)
    }

    func testReadAnyXYLineString() throws {
        let lineString = try LineString(coordinates: [XY(0, 0), XY(1, 1)])
        let wkb = try lineString.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 2)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = anyGeometry.asGeometryXY()
        XCTAssertEqual(recovered, lineString.geometry)
    }

    func testReadAnyXYPolygon() throws {
        let ring = try Polygon<XY>.LinearRing(coordinates: [XY(0, 0), XY(1, 0), XY(1, 1), XY(0, 0)])
        let polygon = Polygon(exterior: ring)
        let wkb = try polygon.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 2)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = anyGeometry.asGeometryXY()
        XCTAssertEqual(recovered, polygon.geometry)
    }

    func testReadAnyXYMultiPoint() throws {
        let multiPoint = MultiPoint(points: [Point(x: 1, y: 2), Point(x: 3, y: 4)])
        let wkb = try multiPoint.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 2)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = anyGeometry.asGeometryXY()
        XCTAssertEqual(recovered, multiPoint.geometry)
    }

    func testReadAnyXYMultiLineString() throws {
        let multiLineString = MultiLineString(
            lineStrings: [
                try LineString(coordinates: [XY(0, 0), XY(1, 1)]),
                try LineString(coordinates: [XY(2, 2), XY(3, 3)])
            ]
        )
        let wkb = try multiLineString.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 2)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = anyGeometry.asGeometryXY()
        XCTAssertEqual(recovered, multiLineString.geometry)
    }

    func testReadAnyXYMultiPolygon() throws {
        let ring1 = try Polygon<XY>.LinearRing(coordinates: [XY(0, 0), XY(1, 0), XY(1, 1), XY(0, 0)])
        let polygon1 = Polygon(exterior: ring1)
        let ring2 = try Polygon<XY>.LinearRing(coordinates: [XY(2, 2), XY(3, 2), XY(3, 3), XY(2, 2)])
        let polygon2 = Polygon(exterior: ring2)
        let multiPolygon = MultiPolygon(polygons: [polygon1, polygon2])
        let wkb = try multiPolygon.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 2)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = anyGeometry.asGeometryXY()
        XCTAssertEqual(recovered, multiPolygon.geometry)
    }

    func testReadAnyXYGeometryCollection() throws {
        let point = Point(x: 1, y: 2)
        let lineString = try LineString(coordinates: [XY(0, 0), XY(1, 1)])
        let collection = GeometryCollection(geometries: [point, lineString])
        let wkb = try collection.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 2)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = anyGeometry.asGeometryXY()
        XCTAssertEqual(recovered, collection.geometry)
    }

    // MARK: - Read Tests - XYZ Coordinate Type

    func testReadAnyXYZPoint() throws {
        let point = Point(x: 1, y: 2, z: 3)
        let wkb = try point.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 3)
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = try anyGeometry.asGeometryXYZ()
        XCTAssertEqual(recovered, point.geometry)
    }

    func testReadAnyXYZLineString() throws {
        let lineString = try LineString(coordinates: [XYZ(0, 0, 0), XYZ(1, 1, 1)])
        let wkb = try lineString.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 3)
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = try anyGeometry.asGeometryXYZ()
        XCTAssertEqual(recovered, lineString.geometry)
    }

    func testReadAnyXYZPolygon() throws {
        let ring = try Polygon<XYZ>.LinearRing(coordinates: [XYZ(0, 0, 0), XYZ(1, 0, 0), XYZ(1, 1, 1), XYZ(0, 0, 0)])
        let polygon = Polygon(exterior: ring)
        let wkb = try polygon.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 3)
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = try anyGeometry.asGeometryXYZ()
        XCTAssertEqual(recovered, polygon.geometry)
    }

    // MARK: - Read Tests - XYM Coordinate Type

    func testReadAnyXYMPoint() throws {
        let point = Point(x: 1, y: 2, m: 3)
        let wkb = try point.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 3)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, true)

        let recovered = try anyGeometry.asGeometryXYM()
        XCTAssertEqual(recovered, point.geometry)
    }

    func testReadAnyXYMLineString() throws {
        let lineString = try LineString(coordinates: [XYM(0, 0, 0), XYM(1, 1, 1)])
        let wkb = try lineString.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 3)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, true)

        let recovered = try anyGeometry.asGeometryXYM()
        XCTAssertEqual(recovered, lineString.geometry)
    }

    func testReadAnyXYMPolygon() throws {
        let ring = try Polygon<XYM>.LinearRing(coordinates: [XYM(0, 0, 0), XYM(1, 0, 0), XYM(1, 1, 1), XYM(0, 0, 0)])
        let polygon = Polygon(exterior: ring)
        let wkb = try polygon.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 3)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, true)

        let recovered = try anyGeometry.asGeometryXYM()
        XCTAssertEqual(recovered, polygon.geometry)
    }

    // MARK: - Read Tests - XYZM Coordinate Type

    func testReadAnyXYZMPoint() throws {
        let point = Point(x: 1, y: 2, z: 3, m: 4)
        let wkb = try point.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 4)
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, true)

        let recovered = try anyGeometry.asGeometryXYZM()
        XCTAssertEqual(recovered, point.geometry)
    }

    func testReadAnyXYZMLineString() throws {
        let lineString = try LineString(coordinates: [XYZM(0, 0, 0, 0), XYZM(1, 1, 1, 1)])
        let wkb = try lineString.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 4)
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, true)

        let recovered = try anyGeometry.asGeometryXYZM()
        XCTAssertEqual(recovered, lineString.geometry)
    }

    func testReadAnyXYZMPolygon() throws {
        let ring = try Polygon<XYZM>.LinearRing(coordinates: [XYZM(0, 0, 0, 0), XYZM(1, 0, 0, 0), XYZM(1, 1, 1, 1), XYZM(0, 0, 0, 0)])
        let polygon = Polygon(exterior: ring)
        let wkb = try polygon.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        XCTAssertEqual(anyGeometry.dimension, 4)
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, true)

        let recovered = try anyGeometry.asGeometryXYZM()
        XCTAssertEqual(recovered, polygon.geometry)
    }

    // MARK: - Error Handling Tests

    func testReadAnyWithInvalidWKB() {
        let invalidWKB = Data("invalid".utf8)

        do {
            let reader = try WKBReader()
            _ = try reader.readAny(wkb: invalidWKB)
            XCTFail("Expected GEOSError.libraryError to be thrown")
        } catch GEOSError.libraryError {
            // Pass - expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testReadAnyWithEmptyWKB() {
        let emptyWKB = Data()

        do {
            let reader = try WKBReader()
            _ = try reader.readAny(wkb: emptyWKB)
            XCTFail("Expected GEOSError to be thrown")
        } catch GEOSError.libraryError {
            // Pass - expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Conversion Tests

    func testReadAnyXYConvertToXY() throws {
        let point = Point(x: 1, y: 2)
        let wkb = try point.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        // Should succeed - same coordinate type
        let recovered = anyGeometry.asGeometryXY()
        if case .point(let recoveredPoint) = recovered {
            XCTAssertEqual(recoveredPoint.x, 1)
            XCTAssertEqual(recoveredPoint.y, 2)
        } else {
            XCTFail("Expected point geometry")
        }
    }

    func testReadAnyXYZConvertToXY() throws {
        let point = Point(x: 1, y: 2, z: 3)
        let wkb = try point.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        // Should succeed - can drop Z coordinate
        let recovered = anyGeometry.asGeometryXY()
        if case .point(let recoveredPoint) = recovered {
            XCTAssertEqual(recoveredPoint.x, 1)
            XCTAssertEqual(recoveredPoint.y, 2)
        } else {
            XCTFail("Expected point geometry")
        }
    }

    func testReadAnyXYConvertToXYZThrows() throws {
        let point = Point(x: 1, y: 2)
        let wkb = try point.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        // Should fail - cannot add Z coordinate
        XCTAssertThrowsError(try anyGeometry.asGeometryXYZ()) { error in
            XCTAssertEqual(error as? GEOSwiftError, .cannotConvertCoordinateTypes)
        }
    }

    func testReadAnyXYConvertToXYMThrows() throws {
        let point = Point(x: 1, y: 2)
        let wkb = try point.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        // Should fail - cannot add M coordinate
        XCTAssertThrowsError(try anyGeometry.asGeometryXYM()) { error in
            XCTAssertEqual(error as? GEOSwiftError, .cannotConvertCoordinateTypes)
        }
    }

    func testReadAnyXYZMConvertToXYZ() throws {
        let point = Point(x: 1, y: 2, z: 3, m: 4)
        let wkb = try point.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        // Should succeed - can drop M coordinate
        let recovered = try anyGeometry.asGeometryXYZ()
        if case .point(let recoveredPoint) = recovered {
            XCTAssertEqual(recoveredPoint.x, 1)
            XCTAssertEqual(recoveredPoint.y, 2)
            XCTAssertEqual(recoveredPoint.z, 3)
        } else {
            XCTFail("Expected point geometry")
        }
    }

    func testReadAnyXYZMConvertToXYM() throws {
        let point = Point(x: 1, y: 2, z: 3, m: 4)
        let wkb = try point.wkb()

        let reader = try WKBReader()
        let anyGeometry = try reader.readAny(wkb: wkb)

        // Should succeed - can drop Z coordinate
        let recovered = try anyGeometry.asGeometryXYM()
        if case .point(let recoveredPoint) = recovered {
            XCTAssertEqual(recoveredPoint.x, 1)
            XCTAssertEqual(recoveredPoint.y, 2)
            XCTAssertEqual(recoveredPoint.m, 4)
        } else {
            XCTFail("Expected point geometry")
        }
    }
}
