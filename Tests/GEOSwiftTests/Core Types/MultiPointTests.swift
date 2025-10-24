import XCTest
import GEOSwift

final class MultiPointTestsXY: XCTestCase {
    func testInitWithPoints() {
        let points = makePoints(withCount: 3)

        let multiPoint = MultiPoint(points: points)

        XCTAssertEqual(multiPoint.points, points)
    }

    func testInitWithXYZ() {
        let multiPoint1 = MultiPoint(points: [
            Point(x: 1, y: 2, z: 3),
            Point(x: 4, y: 5, z: 6),
            Point(x: 7, y: 8, z: 9)
        ])
        let multiPoint2 = MultiPoint<XY>(multiPoint1)

        XCTAssertEqual(multiPoint2.points.count, 3)
        XCTAssertEqual(multiPoint2.points[0].x, 1)
        XCTAssertEqual(multiPoint2.points[0].y, 2)
        XCTAssertEqual(multiPoint2.points[1].x, 4)
        XCTAssertEqual(multiPoint2.points[1].y, 5)
        XCTAssertEqual(multiPoint2.points[2].x, 7)
        XCTAssertEqual(multiPoint2.points[2].y, 8)
    }

    func testInitWithXYM() {
        let multiPoint1 = MultiPoint(points: [
            Point(x: 1, y: 2, m: 3),
            Point(x: 4, y: 5, m: 6),
            Point(x: 7, y: 8, m: 9)
        ])
        let multiPoint2 = MultiPoint<XY>(multiPoint1)

        XCTAssertEqual(multiPoint2.points.count, 3)
        XCTAssertEqual(multiPoint2.points[0].x, 1)
        XCTAssertEqual(multiPoint2.points[0].y, 2)
        XCTAssertEqual(multiPoint2.points[1].x, 4)
        XCTAssertEqual(multiPoint2.points[1].y, 5)
        XCTAssertEqual(multiPoint2.points[2].x, 7)
        XCTAssertEqual(multiPoint2.points[2].y, 8)
    }

    func testInitWithXYZM() {
        let multiPoint1 = MultiPoint(points: [
            Point(x: 1, y: 2, z: 3, m: 4),
            Point(x: 5, y: 6, z: 7, m: 8),
            Point(x: 9, y: 10, z: 11, m: 12)
        ])
        let multiPoint2 = MultiPoint<XY>(multiPoint1)

        XCTAssertEqual(multiPoint2.points.count, 3)
        XCTAssertEqual(multiPoint2.points[0].x, 1)
        XCTAssertEqual(multiPoint2.points[0].y, 2)
        XCTAssertEqual(multiPoint2.points[1].x, 5)
        XCTAssertEqual(multiPoint2.points[1].y, 6)
        XCTAssertEqual(multiPoint2.points[2].x, 9)
        XCTAssertEqual(multiPoint2.points[2].y, 10)
    }
}

final class MultiPointTestsXYZ: XCTestCase {
    func testInitWithXYZM() {
        let multiPoint1 = MultiPoint(points: [
            Point(x: 1, y: 2, z: 3, m: 4),
            Point(x: 5, y: 6, z: 7, m: 8),
            Point(x: 9, y: 10, z: 11, m: 12)
        ])
        let multiPoint2 = MultiPoint<XYZ>(multiPoint1)

        XCTAssertEqual(multiPoint2.points.count, 3)
        XCTAssertEqual(multiPoint2.points[0].x, 1)
        XCTAssertEqual(multiPoint2.points[0].y, 2)
        XCTAssertEqual(multiPoint2.points[0].z, 3)
        XCTAssertEqual(multiPoint2.points[1].x, 5)
        XCTAssertEqual(multiPoint2.points[1].y, 6)
        XCTAssertEqual(multiPoint2.points[1].z, 7)
        XCTAssertEqual(multiPoint2.points[2].x, 9)
        XCTAssertEqual(multiPoint2.points[2].y, 10)
        XCTAssertEqual(multiPoint2.points[2].z, 11)
    }
}

final class MultiPointTestsXYM: XCTestCase {
    func testInitWithXYZM() {
        let multiPoint1 = MultiPoint(points: [
            Point(x: 1, y: 2, z: 3, m: 4),
            Point(x: 5, y: 6, z: 7, m: 8),
            Point(x: 9, y: 10, z: 11, m: 12)
        ])
        let multiPoint2 = MultiPoint<XYM>(multiPoint1)

        XCTAssertEqual(multiPoint2.points.count, 3)
        XCTAssertEqual(multiPoint2.points[0].x, 1)
        XCTAssertEqual(multiPoint2.points[0].y, 2)
        XCTAssertEqual(multiPoint2.points[0].m, 4)
        XCTAssertEqual(multiPoint2.points[1].x, 5)
        XCTAssertEqual(multiPoint2.points[1].y, 6)
        XCTAssertEqual(multiPoint2.points[1].m, 8)
        XCTAssertEqual(multiPoint2.points[2].x, 9)
        XCTAssertEqual(multiPoint2.points[2].y, 10)
        XCTAssertEqual(multiPoint2.points[2].m, 12)
    }
}

final class MultiPointTestsXYZM: XCTestCase {
    func testInitWithXYZM() {
        let multiPoint1 = MultiPoint(points: [
            Point(x: 1, y: 2, z: 3, m: 4),
            Point(x: 5, y: 6, z: 7, m: 8),
            Point(x: 9, y: 10, z: 11, m: 12)
        ])
        let multiPoint2 = MultiPoint<XYZM>(multiPoint1)

        XCTAssertEqual(multiPoint2.points.count, 3)
        XCTAssertEqual(multiPoint2.points[0].x, 1)
        XCTAssertEqual(multiPoint2.points[0].y, 2)
        XCTAssertEqual(multiPoint2.points[0].z, 3)
        XCTAssertEqual(multiPoint2.points[0].m, 4)
        XCTAssertEqual(multiPoint2.points[1].x, 5)
        XCTAssertEqual(multiPoint2.points[1].y, 6)
        XCTAssertEqual(multiPoint2.points[1].z, 7)
        XCTAssertEqual(multiPoint2.points[1].m, 8)
        XCTAssertEqual(multiPoint2.points[2].x, 9)
        XCTAssertEqual(multiPoint2.points[2].y, 10)
        XCTAssertEqual(multiPoint2.points[2].z, 11)
        XCTAssertEqual(multiPoint2.points[2].m, 12)
    }
}
