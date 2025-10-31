import XCTest
import GEOSwift

final class WKTReaderTests: XCTestCase {

    // MARK: - Initialization Tests

    func testInitWithDefaultContext() throws {
        let reader = try WKTReader()
        XCTAssertNotNil(reader)
    }

    // MARK: - Read Tests - XY Coordinate Type

    func testReadAnyXYPoint() throws {
        let point = Point(x: 1, y: 2)
        let wkt = try point.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 2)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = anyGeometry.asXY()
        XCTAssertEqual(recovered, point.geometry)
    }

    func testReadAnyXYLineString() throws {
        let lineString = try LineString(coordinates: [XY(0, 0), XY(1, 1)])
        let wkt = try lineString.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 2)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = anyGeometry.asXY()
        XCTAssertEqual(recovered, lineString.geometry)
    }

    func testReadAnyXYPolygon() throws {
        let ring = try Polygon<XY>.LinearRing(coordinates: [XY(0, 0), XY(1, 0), XY(1, 1), XY(0, 0)])
        let polygon = Polygon(exterior: ring)
        let wkt = try polygon.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 2)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = anyGeometry.asXY()
        XCTAssertEqual(recovered, polygon.geometry)
    }

    func testReadAnyXYMultiPoint() throws {
        let multiPoint = MultiPoint(points: [Point(x: 1, y: 2), Point(x: 3, y: 4)])
        let wkt = try multiPoint.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 2)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = anyGeometry.asXY()
        XCTAssertEqual(recovered, multiPoint.geometry)
    }

    func testReadAnyXYMultiLineString() throws {
        let multiLineString = MultiLineString(
            lineStrings: [
                try LineString(coordinates: [XY(0, 0), XY(1, 1)]),
                try LineString(coordinates: [XY(2, 2), XY(3, 3)])
            ]
        )
        let wkt = try multiLineString.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 2)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = anyGeometry.asXY()
        XCTAssertEqual(recovered, multiLineString.geometry)
    }

    func testReadAnyXYMultiPolygon() throws {
        let ring1 = try Polygon<XY>.LinearRing(coordinates: [XY(0, 0), XY(1, 0), XY(1, 1), XY(0, 0)])
        let polygon1 = Polygon(exterior: ring1)
        let ring2 = try Polygon<XY>.LinearRing(coordinates: [XY(2, 2), XY(3, 2), XY(3, 3), XY(2, 2)])
        let polygon2 = Polygon(exterior: ring2)
        let multiPolygon = MultiPolygon(polygons: [polygon1, polygon2])
        let wkt = try multiPolygon.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 2)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = anyGeometry.asXY()
        XCTAssertEqual(recovered, multiPolygon.geometry)
    }

    func testReadAnyXYGeometryCollection() throws {
        let point = Point(x: 1, y: 2)
        let lineString = try LineString(coordinates: [XY(0, 0), XY(1, 1)])
        let collection = GeometryCollection(geometries: [point, lineString])
        let wkt = try collection.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 2)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = anyGeometry.asXY()
        XCTAssertEqual(recovered, collection.geometry)
    }

    // MARK: - Read Tests - XYZ Coordinate Type

    func testReadAnyXYZPoint() throws {
        let point = Point(x: 1, y: 2, z: 3)
        let wkt = try point.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 3)
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = try anyGeometry.asXYZ()
        XCTAssertEqual(recovered, point.geometry)
    }

    func testReadAnyXYZLineString() throws {
        let lineString = try LineString(coordinates: [XYZ(0, 0, 0), XYZ(1, 1, 1)])
        let wkt = try lineString.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 3)
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = try anyGeometry.asXYZ()
        XCTAssertEqual(recovered, lineString.geometry)
    }

    func testReadAnyXYZPolygon() throws {
        let ring = try Polygon<XYZ>.LinearRing(coordinates: [XYZ(0, 0, 0), XYZ(1, 0, 0), XYZ(1, 1, 1), XYZ(0, 0, 0)])
        let polygon = Polygon(exterior: ring)
        let wkt = try polygon.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 3)
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = try anyGeometry.asXYZ()
        XCTAssertEqual(recovered, polygon.geometry)
    }

    // MARK: - Read Tests - XYM Coordinate Type

    func testReadAnyXYMPoint() throws {
        let point = Point(x: 1, y: 2, m: 3)
        let wkt = try point.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 3)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, true)

        let recovered = try anyGeometry.asXYM()
        XCTAssertEqual(recovered, point.geometry)
    }

    func testReadAnyXYMLineString() throws {
        let lineString = try LineString(coordinates: [XYM(0, 0, 0), XYM(1, 1, 1)])
        let wkt = try lineString.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 3)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, true)

        let recovered = try anyGeometry.asXYM()
        XCTAssertEqual(recovered, lineString.geometry)
    }

    func testReadAnyXYMPolygon() throws {
        let ring = try Polygon<XYM>.LinearRing(coordinates: [XYM(0, 0, 0), XYM(1, 0, 0), XYM(1, 1, 1), XYM(0, 0, 0)])
        let polygon = Polygon(exterior: ring)
        let wkt = try polygon.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 3)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, true)

        let recovered = try anyGeometry.asXYM()
        XCTAssertEqual(recovered, polygon.geometry)
    }

    // MARK: - Read Tests - XYZM Coordinate Type

    func testReadAnyXYZMPoint() throws {
        let point = Point(x: 1, y: 2, z: 3, m: 4)
        let wkt = try point.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 4)
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, true)

        let recovered = try anyGeometry.asXYZM()
        XCTAssertEqual(recovered, point.geometry)
    }

    func testReadAnyXYZMLineString() throws {
        let lineString = try LineString(coordinates: [XYZM(0, 0, 0, 0), XYZM(1, 1, 1, 1)])
        let wkt = try lineString.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 4)
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, true)

        let recovered = try anyGeometry.asXYZM()
        XCTAssertEqual(recovered, lineString.geometry)
    }

    func testReadAnyXYZMPolygon() throws {
        let ring = try Polygon<XYZM>.LinearRing(coordinates: [
            XYZM(0, 0, 0, 0),
            XYZM(1, 0, 0, 0),
            XYZM(1, 1, 1, 1),
            XYZM(0, 0, 0, 0)
        ])
        let polygon = Polygon(exterior: ring)
        let wkt = try polygon.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 4)
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, true)

        let recovered = try anyGeometry.asXYZM()
        XCTAssertEqual(recovered, polygon.geometry)
    }

    // MARK: - Error Handling Tests

    func testReadAnyWithInvalidWKT() {
        let invalidWKT = "invalid"

        do {
            let reader = try WKTReader()
            _ = try reader.readAny(wkt: invalidWKT)
            XCTFail("Expected GEOSError.libraryError to be thrown")
        } catch GEOSError.libraryError {
            // Pass - expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testReadAnyWithEmptyWKT() {
        let emptyWKT = ""

        do {
            let reader = try WKTReader()
            _ = try reader.readAny(wkt: emptyWKT)
            XCTFail("Expected GEOSError to be thrown")
        } catch GEOSError.libraryError {
            // Pass - expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Spot Check Tests with WKT Literals

    func testReadAnyWKTLiteralXYPoint() throws {
        let wkt = "POINT (1.5 2.5)"

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 2)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = anyGeometry.asXY()
        let expectedPoint = Point(x: 1.5, y: 2.5)
        XCTAssertEqual(recovered, expectedPoint.geometry)
    }

    func testReadAnyWKTLiteralXYZLineString() throws {
        let wkt = "LINESTRING Z (0 0 10, 1 1 20, 2 2 30)"

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 3)
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, false)

        let recovered = try anyGeometry.asXYZ()
        let expectedLineString = try LineString(coordinates: [
            XYZ(0, 0, 10),
            XYZ(1, 1, 20),
            XYZ(2, 2, 30)
        ])
        XCTAssertEqual(recovered, expectedLineString.geometry)
    }

    func testReadAnyWKTLiteralXYMPolygon() throws {
        let wkt = "POLYGON M ((0 0 1, 4 0 2, 4 4 3, 0 4 4, 0 0 1))"

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 3)
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, true)

        let recovered = try anyGeometry.asXYM()
        let ring = try Polygon<XYM>.LinearRing(coordinates: [
            XYM(0, 0, 1),
            XYM(4, 0, 2),
            XYM(4, 4, 3),
            XYM(0, 4, 4),
            XYM(0, 0, 1)
        ])
        let expectedPolygon = Polygon(exterior: ring)
        XCTAssertEqual(recovered, expectedPolygon.geometry)
    }

    func testReadAnyWKTLiteralXYZMMultiPoint() throws {
        let wkt = "MULTIPOINT ZM ((1 2 3 4), (5 6 7 8))"

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        XCTAssertEqual(anyGeometry.dimension, 4)
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, true)

        let recovered = try anyGeometry.asXYZM()
        let expectedMultiPoint = MultiPoint(points: [
            Point(x: 1, y: 2, z: 3, m: 4),
            Point(x: 5, y: 6, z: 7, m: 8)
        ])
        XCTAssertEqual(recovered, expectedMultiPoint.geometry)
    }

    // MARK: - Conversion Tests

    func testReadAnyXYConvertToXY() throws {
        let point = Point(x: 1, y: 2)
        let wkt = try point.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        // Should succeed - same coordinate type
        let recovered = anyGeometry.asXY()
        XCTAssertEqual(recovered, point.geometry)
    }

    func testReadAnyXYZConvertToXY() throws {
        let point = Point(x: 1, y: 2, z: 3)
        let wkt = try point.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        // Should succeed - can drop Z coordinate
        let recovered = anyGeometry.asXY()
        let expectedPoint = Point(x: 1, y: 2)
        XCTAssertEqual(recovered, expectedPoint.geometry)
    }

    func testReadAnyXYConvertToXYZThrows() throws {
        let point = Point(x: 1, y: 2)
        let wkt = try point.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        // Should fail - cannot add Z coordinate
        XCTAssertThrowsError(try anyGeometry.asXYZ()) { error in
            XCTAssertEqual(error as? GEOSwiftError, .cannotConvertCoordinateTypes)
        }
    }

    func testReadAnyXYConvertToXYMThrows() throws {
        let point = Point(x: 1, y: 2)
        let wkt = try point.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        // Should fail - cannot add M coordinate
        XCTAssertThrowsError(try anyGeometry.asXYM()) { error in
            XCTAssertEqual(error as? GEOSwiftError, .cannotConvertCoordinateTypes)
        }
    }

    func testReadAnyXYZMConvertToXYZ() throws {
        let point = Point(x: 1, y: 2, z: 3, m: 4)
        let wkt = try point.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        // Should succeed - can drop M coordinate
        let recovered = try anyGeometry.asXYZ()
        let expectedPoint = Point(x: 1, y: 2, z: 3)
        XCTAssertEqual(recovered, expectedPoint.geometry)
    }

    func testReadAnyXYZMConvertToXYM() throws {
        let point = Point(x: 1, y: 2, z: 3, m: 4)
        let wkt = try point.wkt()

        let reader = try WKTReader()
        let anyGeometry = try reader.readAny(wkt: wkt)

        // Should succeed - can drop Z coordinate
        let recovered = try anyGeometry.asXYM()
        let expectedPoint = Point(x: 1, y: 2, m: 4)
        XCTAssertEqual(recovered, expectedPoint.geometry)
    }
}
