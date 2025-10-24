import XCTest
import GEOSwift

final class Polygon_LinearRingTests: XCTestCase {
    func testInitWithTooFewPoints() {
        let points = makePoints(withCount: 3)

        do {
            _ = try Polygon.LinearRing(points: points)
            XCTFail("Expected constructor to throw")
        } catch GEOSwiftError.tooFewPoints {
            // Pass
        } catch {
            XCTFail("Expected GEOSwiftError.tooFewPoints, but got \(error)")
        }
    }

    func testInitWithUnclosedRing() {
        let points = makePoints(withCount: 4)

        do {
            _ = try Polygon.LinearRing(points: points)
            XCTFail("Expected constructor to throw")
        } catch GEOSwiftError.ringNotClosed {
            // Pass
        } catch {
            XCTFail("Expected GEOSwiftError.ringNotClosed, but got \(error)")
        }
    }

    func testInitSuccess() {
        var points = makePoints(withCount: 3)
        points.append(points[0])

        let linearRing = try? Polygon.LinearRing(points: points)

        XCTAssertEqual(linearRing?.points, points)
    }
}

final class PolygonTestsXY: XCTestCase {
    func testInitWithExteriorAndHoles() {
        let linearRings = makeLinearRings(withCount: 4)

        let polygon = Polygon(exterior: linearRings[0], holes: Array(linearRings[1...3]))

        XCTAssertEqual(polygon.exterior, linearRings[0])
        XCTAssertEqual(polygon.holes, Array(linearRings[1...3]))
    }

    func testInitWithExteriorOnly() {
        let linearRings = makeLinearRings(withCount: 1)

        let polygon = Polygon(exterior: linearRings[0])

        XCTAssertEqual(polygon.exterior, linearRings[0])
        XCTAssertEqual(polygon.holes, [])
    }

    func testInitWithXYZ() throws {
        let points = [
            Point(x: 0, y: 0, z: 1),
            Point(x: 1, y: 0, z: 2),
            Point(x: 1, y: 1, z: 3),
            Point(x: 0, y: 0, z: 4)
        ]
        let ring = try Polygon<XYZ>.LinearRing(points: points)
        let polygon1 = Polygon(exterior: ring)
        let polygon2 = Polygon<XY>(polygon1)

        XCTAssertEqual(polygon2.exterior.points.count, 4)
        XCTAssertEqual(polygon2.exterior.points[0].x, 0)
        XCTAssertEqual(polygon2.exterior.points[0].y, 0)
        XCTAssertEqual(polygon2.exterior.points[1].x, 1)
        XCTAssertEqual(polygon2.exterior.points[1].y, 0)
    }

    func testInitWithXYM() throws {
        let points = [
            Point(x: 0, y: 0, m: 1),
            Point(x: 1, y: 0, m: 2),
            Point(x: 1, y: 1, m: 3),
            Point(x: 0, y: 0, m: 4)
        ]
        let ring = try Polygon<XYM>.LinearRing(points: points)
        let polygon1 = Polygon(exterior: ring)
        let polygon2 = Polygon<XY>(polygon1)

        XCTAssertEqual(polygon2.exterior.points.count, 4)
        XCTAssertEqual(polygon2.exterior.points[0].x, 0)
        XCTAssertEqual(polygon2.exterior.points[0].y, 0)
        XCTAssertEqual(polygon2.exterior.points[1].x, 1)
        XCTAssertEqual(polygon2.exterior.points[1].y, 0)
    }

    func testInitWithXYZM() throws {
        let points = [
            Point(x: 0, y: 0, z: 1, m: 2),
            Point(x: 1, y: 0, z: 3, m: 4),
            Point(x: 1, y: 1, z: 5, m: 6),
            Point(x: 0, y: 0, z: 7, m: 8)
        ]
        let ring = try Polygon<XYZM>.LinearRing(points: points)
        let polygon1 = Polygon(exterior: ring)
        let polygon2 = Polygon<XY>(polygon1)

        XCTAssertEqual(polygon2.exterior.points.count, 4)
        XCTAssertEqual(polygon2.exterior.points[0].x, 0)
        XCTAssertEqual(polygon2.exterior.points[0].y, 0)
        XCTAssertEqual(polygon2.exterior.points[1].x, 1)
        XCTAssertEqual(polygon2.exterior.points[1].y, 0)
    }
}

final class PolygonTestsXYZ: XCTestCase {
    func testInitWithXYZM() throws {
        let points = [
            Point(x: 0, y: 0, z: 1, m: 2),
            Point(x: 1, y: 0, z: 3, m: 4),
            Point(x: 1, y: 1, z: 5, m: 6),
            Point(x: 0, y: 0, z: 7, m: 8)
        ]
        let ring = try Polygon<XYZM>.LinearRing(points: points)
        let polygon1 = Polygon(exterior: ring)
        let polygon2 = Polygon<XYZ>(polygon1)

        XCTAssertEqual(polygon2.exterior.points.count, 4)
        XCTAssertEqual(polygon2.exterior.points[0].x, 0)
        XCTAssertEqual(polygon2.exterior.points[0].y, 0)
        XCTAssertEqual(polygon2.exterior.points[0].z, 1)
        XCTAssertEqual(polygon2.exterior.points[1].x, 1)
        XCTAssertEqual(polygon2.exterior.points[1].y, 0)
        XCTAssertEqual(polygon2.exterior.points[1].z, 3)
        XCTAssertEqual(polygon2.exterior.points[3].x, 0)
        XCTAssertEqual(polygon2.exterior.points[3].y, 0)
        XCTAssertEqual(polygon2.exterior.points[3].z, 7)
    }
}

final class PolygonTestsXYM: XCTestCase {
    func testInitWithXYZM() throws {
        let points = [
            Point(x: 0, y: 0, z: 1, m: 2),
            Point(x: 1, y: 0, z: 3, m: 4),
            Point(x: 1, y: 1, z: 5, m: 6),
            Point(x: 0, y: 0, z: 7, m: 8)
        ]
        let ring = try Polygon<XYZM>.LinearRing(points: points)
        let polygon1 = Polygon(exterior: ring)
        let polygon2 = Polygon<XYM>(polygon1)

        XCTAssertEqual(polygon2.exterior.points.count, 4)
        XCTAssertEqual(polygon2.exterior.points[0].x, 0)
        XCTAssertEqual(polygon2.exterior.points[0].y, 0)
        XCTAssertEqual(polygon2.exterior.points[0].m, 2)
        XCTAssertEqual(polygon2.exterior.points[1].x, 1)
        XCTAssertEqual(polygon2.exterior.points[1].y, 0)
        XCTAssertEqual(polygon2.exterior.points[1].m, 4)
        XCTAssertEqual(polygon2.exterior.points[3].x, 0)
        XCTAssertEqual(polygon2.exterior.points[3].y, 0)
        XCTAssertEqual(polygon2.exterior.points[3].m, 8)
    }
}

final class PolygonTestsXYZM: XCTestCase {
    func testInitWithXYZM() throws {
        let points = [
            Point(x: 0, y: 0, z: 1, m: 2),
            Point(x: 1, y: 0, z: 3, m: 4),
            Point(x: 1, y: 1, z: 5, m: 6),
            Point(x: 0, y: 0, z: 7, m: 8)
        ]
        let ring = try Polygon<XYZM>.LinearRing(points: points)
        let polygon1 = Polygon(exterior: ring)
        let polygon2 = Polygon<XYZM>(polygon1)

        XCTAssertEqual(polygon2.exterior.points.count, 4)
        XCTAssertEqual(polygon2.exterior.points[0].x, 0)
        XCTAssertEqual(polygon2.exterior.points[0].y, 0)
        XCTAssertEqual(polygon2.exterior.points[0].z, 1)
        XCTAssertEqual(polygon2.exterior.points[0].m, 2)
        XCTAssertEqual(polygon2.exterior.points[1].x, 1)
        XCTAssertEqual(polygon2.exterior.points[1].y, 0)
        XCTAssertEqual(polygon2.exterior.points[1].z, 3)
        XCTAssertEqual(polygon2.exterior.points[1].m, 4)
        XCTAssertEqual(polygon2.exterior.points[3].x, 0)
        XCTAssertEqual(polygon2.exterior.points[3].y, 0)
        XCTAssertEqual(polygon2.exterior.points[3].z, 7)
        XCTAssertEqual(polygon2.exterior.points[3].m, 8)
    }
}
