import XCTest
import GEOSwift

final class LineStringTestsXY: XCTestCase {
    func testInitWithTooFewCoordinates() {
        let coordinates: [XY] = [XY(0, 0)]

        do {
            _ = try LineString(coordinates: coordinates)
            XCTFail("Expected constructor to throw")
        } catch GEOSwiftError.tooFewCoordinates {
            // Pass
        } catch {
            XCTFail("Expected GEOSwiftError.tooFewCoordinates, but got \(error)")
        }
    }

    func testInitWithEnoughCoordinates() {
        let coordinates: [XY] = [XY(0, 0), XY(1, 1)]

        let lineString = try? LineString(coordinates: coordinates)

        XCTAssertEqual(lineString?.coordinates, coordinates)
    }

    func testFirstAndLastCoordinate() {
        let coordinates: [XY] = [XY(0, 0), XY(1, 1), XY(2, 2)]

        let lineString = try? LineString(coordinates: coordinates)

        XCTAssertEqual(lineString?.firstCoordinate, coordinates[0])
        XCTAssertEqual(lineString?.lastCoordinate, coordinates[2])
    }

    func testInitWithLinearRing() {
        let lineString = LineString(.testValueHole1)

        XCTAssertEqual(lineString.coordinates, Polygon.LinearRing.testValueHole1.coordinates)
    }

    func testInitWithPoints() throws {
        let points = makePoints(withCount: 2)
        let lineString = try LineString(points: points)

        XCTAssertEqual(lineString.coordinates.count, 2)
        XCTAssertEqual(lineString.coordinates[0].x, 0)
        XCTAssertEqual(lineString.coordinates[0].y, 0)
        XCTAssertEqual(lineString.coordinates[1].x, 1)
        XCTAssertEqual(lineString.coordinates[1].y, 1)
    }

    func testInitWithXYZ() throws {
        let coordinates: [XYZ] = [XYZ(1, 2, 3), XYZ(4, 5, 6)]
        let lineString1 = try LineString(coordinates: coordinates)
        let lineString2 = LineString<XY>(lineString1)

        XCTAssertEqual(lineString2.coordinates.count, 2)
        XCTAssertEqual(lineString2.coordinates[0].x, 1)
        XCTAssertEqual(lineString2.coordinates[0].y, 2)
        XCTAssertEqual(lineString2.coordinates[1].x, 4)
        XCTAssertEqual(lineString2.coordinates[1].y, 5)
    }

    func testInitWithXYM() throws {
        let coordinates: [XYM] = [XYM(1, 2, 3), XYM(4, 5, 6)]
        let lineString1 = try LineString(coordinates: coordinates)
        let lineString2 = LineString<XY>(lineString1)

        XCTAssertEqual(lineString2.coordinates.count, 2)
        XCTAssertEqual(lineString2.coordinates[0].x, 1)
        XCTAssertEqual(lineString2.coordinates[0].y, 2)
        XCTAssertEqual(lineString2.coordinates[1].x, 4)
        XCTAssertEqual(lineString2.coordinates[1].y, 5)
    }

    func testInitWithXYZM() throws {
        let coordinates: [XYZM] = [XYZM(1, 2, 3, 4), XYZM(5, 6, 7, 8)]
        let lineString1 = try LineString(coordinates: coordinates)
        let lineString2 = LineString<XY>(lineString1)

        XCTAssertEqual(lineString2.coordinates.count, 2)
        XCTAssertEqual(lineString2.coordinates[0].x, 1)
        XCTAssertEqual(lineString2.coordinates[0].y, 2)
        XCTAssertEqual(lineString2.coordinates[1].x, 5)
        XCTAssertEqual(lineString2.coordinates[1].y, 6)
    }
}

final class LineStringTestsXYZ: XCTestCase {
    func testInitWithXYZM() throws {
        let coordinates: [XYZM] = [XYZM(1, 2, 3, 4), XYZM(5, 6, 7, 8)]
        let lineString1 = try LineString(coordinates: coordinates)
        let lineString2 = LineString<XYZ>(lineString1)

        XCTAssertEqual(lineString2.coordinates.count, 2)
        XCTAssertEqual(lineString2.coordinates[0].x, 1)
        XCTAssertEqual(lineString2.coordinates[0].y, 2)
        XCTAssertEqual(lineString2.coordinates[0].z, 3)
        XCTAssertEqual(lineString2.coordinates[1].x, 5)
        XCTAssertEqual(lineString2.coordinates[1].y, 6)
        XCTAssertEqual(lineString2.coordinates[1].z, 7)
    }
}

final class LineStringTestsXYM: XCTestCase {
    func testInitWithXYZM() throws {
        let coordinates: [XYZM] = [XYZM(1, 2, 3, 4), XYZM(5, 6, 7, 8)]
        let lineString1 = try LineString(coordinates: coordinates)
        let lineString2 = LineString<XYM>(lineString1)

        XCTAssertEqual(lineString2.coordinates.count, 2)
        XCTAssertEqual(lineString2.coordinates[0].x, 1)
        XCTAssertEqual(lineString2.coordinates[0].y, 2)
        XCTAssertEqual(lineString2.coordinates[0].m, 4)
        XCTAssertEqual(lineString2.coordinates[1].x, 5)
        XCTAssertEqual(lineString2.coordinates[1].y, 6)
        XCTAssertEqual(lineString2.coordinates[1].m, 8)
    }
}

final class LineStringTestsXYZM: XCTestCase {
    func testInitWithXYZM() throws {
        let coordinates: [XYZM] = [XYZM(1, 2, 3, 4), XYZM(5, 6, 7, 8)]
        let lineString1 = try LineString(coordinates: coordinates)
        let lineString2 = LineString<XYZM>(lineString1)

        XCTAssertEqual(lineString2.coordinates.count, 2)
        XCTAssertEqual(lineString2.coordinates[0].x, 1)
        XCTAssertEqual(lineString2.coordinates[0].y, 2)
        XCTAssertEqual(lineString2.coordinates[0].z, 3)
        XCTAssertEqual(lineString2.coordinates[0].m, 4)
        XCTAssertEqual(lineString2.coordinates[1].x, 5)
        XCTAssertEqual(lineString2.coordinates[1].y, 6)
        XCTAssertEqual(lineString2.coordinates[1].z, 7)
        XCTAssertEqual(lineString2.coordinates[1].m, 8)
    }
}
