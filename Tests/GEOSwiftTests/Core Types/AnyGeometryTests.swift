import XCTest
import GEOSwift

final class AnyGeometryTests: XCTestCase {

    // MARK: - Initialization Tests

    func testInitWithGeometryXY() {
        let point = Point(x: 1, y: 2)
        let anyGeometry = AnyGeometry(point)

        XCTAssertEqual(anyGeometry.dimension, 2) // XY has 2 dimensions
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, false)
    }

    func testInitWithGeometryXYZ() {
        let point = Point(x: 1, y: 2, z: 3)
        let anyGeometry = AnyGeometry(point)

        XCTAssertEqual(anyGeometry.dimension, 3) // XYZ has 3 dimensions
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, false)
    }

    func testInitWithGeometryXYM() {
        let point = Point(x: 1, y: 2, m: 3)
        let anyGeometry = AnyGeometry(point)

        XCTAssertEqual(anyGeometry.dimension, 3) // XYM has 3 dimensions
        XCTAssertEqual(anyGeometry.hasZ, false)
        XCTAssertEqual(anyGeometry.hasM, true)
    }

    func testInitWithGeometryXYZM() {
        let point = Point(x: 1, y: 2, z: 3, m: 4)
        let anyGeometry = AnyGeometry(point)

        XCTAssertEqual(anyGeometry.dimension, 4) // XYZM has 4 dimensions
        XCTAssertEqual(anyGeometry.hasZ, true)
        XCTAssertEqual(anyGeometry.hasM, true)
    }

    func testInitWithDifferentGeometryTypes() {
        // Point
        let point = Point(x: 1, y: 2)
        let anyPoint = AnyGeometry(point)
        XCTAssertEqual(anyPoint.dimension, 2) // XY coordinate dimension

        // LineString
        let lineString = try! LineString(coordinates: [XY(0, 0), XY(1, 1)])
        let anyLineString = AnyGeometry(lineString)
        XCTAssertEqual(anyLineString.dimension, 2) // XY coordinate dimension

        // Polygon
        let ring = try! Polygon<XY>.LinearRing(coordinates: [XY(0, 0), XY(1, 0), XY(1, 1), XY(0, 0)])
        let polygon = Polygon(exterior: ring)
        let anyPolygon = AnyGeometry(polygon)
        XCTAssertEqual(anyPolygon.dimension, 2) // XY coordinate dimension
    }

    // MARK: - Type Conversion Tests - asGeometryXY

    func testAsGeometryXYFromXY() {
        let point = Point(x: 1, y: 2)
        let anyGeometry = AnyGeometry(point)

        let recovered = anyGeometry.asGeometryXY()
        XCTAssertEqual(recovered, point.geometry)
    }

    func testAsGeometryXYFromXYZ() {
        let anyGeometry = AnyGeometry(Point(x: 1, y: 2, z: 3))

        let recovered = anyGeometry.asGeometryXY()

        // Verify it's converted to XY
        if case .point(let recoveredPoint) = recovered {
            XCTAssertEqual(recoveredPoint.x, 1)
            XCTAssertEqual(recoveredPoint.y, 2)
        } else {
            XCTFail("Expected point geometry")
        }
    }

    func testAsGeometryXYFromXYM() {
        let anyGeometry = AnyGeometry(Point(x: 1, y: 2, m: 3))

        let recovered = anyGeometry.asGeometryXY()

        // Verify it's converted to XY
        if case .point(let recoveredPoint) = recovered {
            XCTAssertEqual(recoveredPoint.x, 1)
            XCTAssertEqual(recoveredPoint.y, 2)
        } else {
            XCTFail("Expected point geometry")
        }
    }

    func testAsGeometryXYFromXYZM() {
        let anyGeometry = AnyGeometry(Point(x: 1, y: 2, z: 3, m: 4))

        let recovered = anyGeometry.asGeometryXY()

        // Verify it's converted to XY
        if case .point(let recoveredPoint) = recovered {
            XCTAssertEqual(recoveredPoint.x, 1)
            XCTAssertEqual(recoveredPoint.y, 2)
        } else {
            XCTFail("Expected point geometry")
        }
    }

    // MARK: - Type Conversion Tests - asGeometryXYZ

    func testAsGeometryXYZFromXYZ() throws {
        let point = Point(x: 1, y: 2, z: 3)
        let anyGeometry = AnyGeometry(point)

        let recovered = try anyGeometry.asGeometryXYZ()
        XCTAssertEqual(recovered, point.geometry)
    }

    func testAsGeometryXYZFromXYZM() throws {
        let anyGeometry = AnyGeometry(Point(x: 1, y: 2, z: 3, m: 4))

        let recovered = try anyGeometry.asGeometryXYZ()

        // Verify it's converted to XYZ
        if case .point(let recoveredPoint) = recovered {
            XCTAssertEqual(recoveredPoint.x, 1)
            XCTAssertEqual(recoveredPoint.y, 2)
            XCTAssertEqual(recoveredPoint.z, 3)
        } else {
            XCTFail("Expected point geometry")
        }
    }

    func testAsGeometryXYZFromXYThrows() {
        let anyGeometry = AnyGeometry(Point(x: 1, y: 2))

        XCTAssertThrowsError(try anyGeometry.asGeometryXYZ()) { error in
            XCTAssertEqual(error as? GEOSwiftError, .cannotConvertCoordinateTypes)
        }
    }

    func testAsGeometryXYZFromXYMThrows() {
        let anyGeometry = AnyGeometry(Point(x: 1, y: 2, m: 3))

        XCTAssertThrowsError(try anyGeometry.asGeometryXYZ()) { error in
            XCTAssertEqual(error as? GEOSwiftError, .cannotConvertCoordinateTypes)
        }
    }

    // MARK: - Type Conversion Tests - asGeometryXYM

    func testAsGeometryXYMFromXYM() throws {
        let point = Point(x: 1, y: 2, m: 3)
        let anyGeometry = AnyGeometry(point)

        let recovered = try anyGeometry.asGeometryXYM()
        XCTAssertEqual(recovered, point.geometry)
    }

    func testAsGeometryXYMFromXYZM() throws {
        let anyGeometry = AnyGeometry(Point(x: 1, y: 2, z: 3, m: 4))

        let recovered = try anyGeometry.asGeometryXYM()

        // Verify it's converted to XYM
        if case .point(let recoveredPoint) = recovered {
            XCTAssertEqual(recoveredPoint.x, 1)
            XCTAssertEqual(recoveredPoint.y, 2)
            XCTAssertEqual(recoveredPoint.m, 4)
        } else {
            XCTFail("Expected point geometry")
        }
    }

    func testAsGeometryXYMFromXYThrows() {
        let anyGeometry = AnyGeometry(Point(x: 1, y: 2))

        XCTAssertThrowsError(try anyGeometry.asGeometryXYM()) { error in
            XCTAssertEqual(error as? GEOSwiftError, .cannotConvertCoordinateTypes)
        }
    }

    func testAsGeometryXYMFromXYZThrows() {
        let anyGeometry = AnyGeometry(Point(x: 1, y: 2, z: 3))

        XCTAssertThrowsError(try anyGeometry.asGeometryXYM()) { error in
            XCTAssertEqual(error as? GEOSwiftError, .cannotConvertCoordinateTypes)
        }
    }

    // MARK: - Type Conversion Tests - asGeometryXYZM

    func testAsGeometryXYZMFromXYZM() throws {
        let point = Point(x: 1, y: 2, z: 3, m: 4)
        let anyGeometry = AnyGeometry(point)

        let recovered = try anyGeometry.asGeometryXYZM()
        XCTAssertEqual(recovered, point.geometry)
    }

    func testAsGeometryXYZMFromXYThrows() {
        let anyGeometry = AnyGeometry(Point(x: 1, y: 2))

        XCTAssertThrowsError(try anyGeometry.asGeometryXYZM()) { error in
            XCTAssertEqual(error as? GEOSwiftError, .cannotConvertCoordinateTypes)
        }
    }

    func testAsGeometryXYZMFromXYZThrows() {
        let anyGeometry = AnyGeometry(Point(x: 1, y: 2, z: 3))

        XCTAssertThrowsError(try anyGeometry.asGeometryXYZM()) { error in
            XCTAssertEqual(error as? GEOSwiftError, .cannotConvertCoordinateTypes)
        }
    }

    func testAsGeometryXYZMFromXYMThrows() {
        let anyGeometry = AnyGeometry(Point(x: 1, y: 2, m: 3))

        XCTAssertThrowsError(try anyGeometry.asGeometryXYZM()) { error in
            XCTAssertEqual(error as? GEOSwiftError, .cannotConvertCoordinateTypes)
        }
    }

    // MARK: - Hashable Tests

    func testHashableEquality() {
        let anyGeometry1 = AnyGeometry(Point(x: 1, y: 2))
        let anyGeometry2 = AnyGeometry(Point(x: 1, y: 2))

        XCTAssertEqual(anyGeometry1, anyGeometry2)
    }

    func testHashableInequality() {
        let anyGeometry1 = AnyGeometry(Point(x: 1, y: 2))
        let anyGeometry2 = AnyGeometry(Point(x: 2, y: 3))

        XCTAssertNotEqual(anyGeometry1, anyGeometry2)
    }

    func testHashableWithDifferentCoordinateTypes() {
        let anyGeometryXY = AnyGeometry(Point(x: 1, y: 2))
        let anyGeometryXYZ = AnyGeometry(Point(x: 1, y: 2, z: 3))

        XCTAssertNotEqual(anyGeometryXY, anyGeometryXYZ)
    }

    func testHashValue() {
        let point = Point(x: 1, y: 2)
        let anyGeometry1 = AnyGeometry(point)
        let anyGeometry2 = AnyGeometry(point)

        XCTAssertEqual(anyGeometry1.hashValue, anyGeometry2.hashValue)
    }

    func testCanBeUsedInSet() {
        let anyGeometry1 = AnyGeometry(Point(x: 1, y: 2))
        let anyGeometry2 = AnyGeometry(Point(x: 1, y: 2))
        let anyGeometry3 = AnyGeometry(Point(x: 2, y: 3))

        let set: Set<AnyGeometry> = [anyGeometry1, anyGeometry2, anyGeometry3]

        XCTAssertEqual(set.count, 2) // anyGeometry1 and anyGeometry2 are equal
    }
}
