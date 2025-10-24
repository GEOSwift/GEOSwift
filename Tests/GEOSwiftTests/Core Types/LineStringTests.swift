import XCTest
import GEOSwift

final class LineStringTestsXY: XCTestCase {
    func testInitWithTooFewPoints() {
        let points = makePoints(withCount: 1)

        do {
            _ = try LineString(points: points)
            XCTFail("Expected constructor to throw")
        } catch GEOSwiftError.tooFewPoints {
            // Pass
        } catch {
            XCTFail("Expected GEOSwiftError.tooFewPoints, but got \(error)")
        }
    }

    func testInitWithEnoughPoints() {
        let points = makePoints(withCount: 2)

        let lineString = try? LineString(points: points)

        XCTAssertEqual(lineString?.points, points)
    }

    func testFirstAndLastPoint() {
        let points = makePoints(withCount: 3)

        let lineString = try? LineString(points: points)

        XCTAssertEqual(lineString?.firstPoint, points[0])
        XCTAssertEqual(lineString?.lastPoint, points[2])
    }

    func testInitWithLinearRing() {
        let lineString = LineString(.testValueHole1)

        XCTAssertEqual(lineString.points, Polygon.LinearRing.testValueHole1.points)
    }

    func testInitWithXYZ() throws {
        let points = [Point(x: 1, y: 2, z: 3), Point(x: 4, y: 5, z: 6)]
        let lineString1 = try LineString(points: points)
        let lineString2 = LineString<XY>(lineString1)

        XCTAssertEqual(lineString2.points.count, 2)
        XCTAssertEqual(lineString2.points[0].x, 1)
        XCTAssertEqual(lineString2.points[0].y, 2)
        XCTAssertEqual(lineString2.points[1].x, 4)
        XCTAssertEqual(lineString2.points[1].y, 5)
    }

    func testInitWithXYM() throws {
        let points = [Point(x: 1, y: 2, m: 3), Point(x: 4, y: 5, m: 6)]
        let lineString1 = try LineString(points: points)
        let lineString2 = LineString<XY>(lineString1)

        XCTAssertEqual(lineString2.points.count, 2)
        XCTAssertEqual(lineString2.points[0].x, 1)
        XCTAssertEqual(lineString2.points[0].y, 2)
        XCTAssertEqual(lineString2.points[1].x, 4)
        XCTAssertEqual(lineString2.points[1].y, 5)
    }

    func testInitWithXYZM() throws {
        let points = [Point(x: 1, y: 2, z: 3, m: 4), Point(x: 5, y: 6, z: 7, m: 8)]
        let lineString1 = try LineString(points: points)
        let lineString2 = LineString<XY>(lineString1)

        XCTAssertEqual(lineString2.points.count, 2)
        XCTAssertEqual(lineString2.points[0].x, 1)
        XCTAssertEqual(lineString2.points[0].y, 2)
        XCTAssertEqual(lineString2.points[1].x, 5)
        XCTAssertEqual(lineString2.points[1].y, 6)
    }
}

final class LineStringTestsXYZ: XCTestCase {
    func testInitWithXYZM() throws {
        let points = [Point(x: 1, y: 2, z: 3, m: 4), Point(x: 5, y: 6, z: 7, m: 8)]
        let lineString1 = try LineString(points: points)
        let lineString2 = LineString<XYZ>(lineString1)

        XCTAssertEqual(lineString2.points.count, 2)
        XCTAssertEqual(lineString2.points[0].x, 1)
        XCTAssertEqual(lineString2.points[0].y, 2)
        XCTAssertEqual(lineString2.points[0].z, 3)
        XCTAssertEqual(lineString2.points[1].x, 5)
        XCTAssertEqual(lineString2.points[1].y, 6)
        XCTAssertEqual(lineString2.points[1].z, 7)
    }
}

final class LineStringTestsXYM: XCTestCase {
    func testInitWithXYZM() throws {
        let points = [Point(x: 1, y: 2, z: 3, m: 4), Point(x: 5, y: 6, z: 7, m: 8)]
        let lineString1 = try LineString(points: points)
        let lineString2 = LineString<XYM>(lineString1)

        XCTAssertEqual(lineString2.points.count, 2)
        XCTAssertEqual(lineString2.points[0].x, 1)
        XCTAssertEqual(lineString2.points[0].y, 2)
        XCTAssertEqual(lineString2.points[0].m, 4)
        XCTAssertEqual(lineString2.points[1].x, 5)
        XCTAssertEqual(lineString2.points[1].y, 6)
        XCTAssertEqual(lineString2.points[1].m, 8)
    }
}

final class LineStringTestsXYZM: XCTestCase {
    func testInitWithXYZM() throws {
        let points = [Point(x: 1, y: 2, z: 3, m: 4), Point(x: 5, y: 6, z: 7, m: 8)]
        let lineString1 = try LineString(points: points)
        let lineString2 = LineString<XYZM>(lineString1)

        XCTAssertEqual(lineString2.points.count, 2)
        XCTAssertEqual(lineString2.points[0].x, 1)
        XCTAssertEqual(lineString2.points[0].y, 2)
        XCTAssertEqual(lineString2.points[0].z, 3)
        XCTAssertEqual(lineString2.points[0].m, 4)
        XCTAssertEqual(lineString2.points[1].x, 5)
        XCTAssertEqual(lineString2.points[1].y, 6)
        XCTAssertEqual(lineString2.points[1].z, 7)
        XCTAssertEqual(lineString2.points[1].m, 8)
    }
}
