import XCTest
import GEOSwift

final class MultiLineStringTestsXY: XCTestCase {
    func testInitWithLineStrings() {
        let lineStrings = makeLineStrings(withCount: 3)

        let multiLineString = MultiLineString(lineStrings: lineStrings)

        XCTAssertEqual(multiLineString.lineStrings, lineStrings)
    }

    func testInitWithXYZ() throws {
        let lineString1 = try LineString(points: [
            Point(x: 1, y: 2, z: 3),
            Point(x: 4, y: 5, z: 6)
        ])
        let lineString2 = try LineString(points: [
            Point(x: 7, y: 8, z: 9),
            Point(x: 10, y: 11, z: 12)
        ])
        let multiLineString1 = MultiLineString(lineStrings: [lineString1, lineString2])
        let multiLineString2 = MultiLineString<XY>(multiLineString1)

        XCTAssertEqual(multiLineString2.lineStrings.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].x, 1)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].y, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].x, 4)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].y, 5)
        XCTAssertEqual(multiLineString2.lineStrings[1].points.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].x, 7)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].y, 8)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].x, 10)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].y, 11)
    }

    func testInitWithXYM() throws {
        let lineString1 = try LineString(points: [
            Point(x: 1, y: 2, m: 3),
            Point(x: 4, y: 5, m: 6)
        ])
        let lineString2 = try LineString(points: [
            Point(x: 7, y: 8, m: 9),
            Point(x: 10, y: 11, m: 12)
        ])
        let multiLineString1 = MultiLineString(lineStrings: [lineString1, lineString2])
        let multiLineString2 = MultiLineString<XY>(multiLineString1)

        XCTAssertEqual(multiLineString2.lineStrings.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].x, 1)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].y, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].x, 4)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].y, 5)
        XCTAssertEqual(multiLineString2.lineStrings[1].points.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].x, 7)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].y, 8)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].x, 10)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].y, 11)
    }

    func testInitWithXYZM() throws {
        let lineString1 = try LineString(points: [
            Point(x: 1, y: 2, z: 3, m: 4),
            Point(x: 5, y: 6, z: 7, m: 8)
        ])
        let lineString2 = try LineString(points: [
            Point(x: 9, y: 10, z: 11, m: 12),
            Point(x: 13, y: 14, z: 15, m: 16)
        ])
        let multiLineString1 = MultiLineString(lineStrings: [lineString1, lineString2])
        let multiLineString2 = MultiLineString<XY>(multiLineString1)

        XCTAssertEqual(multiLineString2.lineStrings.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].x, 1)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].y, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].x, 5)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].y, 6)
        XCTAssertEqual(multiLineString2.lineStrings[1].points.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].x, 9)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].y, 10)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].x, 13)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].y, 14)
    }
}

final class MultiLineStringTestsXYZ: XCTestCase {
    func testInitWithXYZM() throws {
        let lineString1 = try LineString(points: [
            Point(x: 1, y: 2, z: 3, m: 4),
            Point(x: 5, y: 6, z: 7, m: 8)
        ])
        let lineString2 = try LineString(points: [
            Point(x: 9, y: 10, z: 11, m: 12),
            Point(x: 13, y: 14, z: 15, m: 16)
        ])
        let multiLineString1 = MultiLineString(lineStrings: [lineString1, lineString2])
        let multiLineString2 = MultiLineString<XYZ>(multiLineString1)

        XCTAssertEqual(multiLineString2.lineStrings.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].x, 1)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].y, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].z, 3)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].x, 5)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].y, 6)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].z, 7)
        XCTAssertEqual(multiLineString2.lineStrings[1].points.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].x, 9)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].y, 10)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].z, 11)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].x, 13)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].y, 14)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].z, 15)
    }
}

final class MultiLineStringTestsXYM: XCTestCase {
    func testInitWithXYZM() throws {
        let lineString1 = try LineString(points: [
            Point(x: 1, y: 2, z: 3, m: 4),
            Point(x: 5, y: 6, z: 7, m: 8)
        ])
        let lineString2 = try LineString(points: [
            Point(x: 9, y: 10, z: 11, m: 12),
            Point(x: 13, y: 14, z: 15, m: 16)
        ])
        let multiLineString1 = MultiLineString(lineStrings: [lineString1, lineString2])
        let multiLineString2 = MultiLineString<XYM>(multiLineString1)

        XCTAssertEqual(multiLineString2.lineStrings.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].x, 1)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].y, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].m, 4)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].x, 5)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].y, 6)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].m, 8)
        XCTAssertEqual(multiLineString2.lineStrings[1].points.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].x, 9)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].y, 10)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].m, 12)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].x, 13)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].y, 14)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].m, 16)
    }
}

final class MultiLineStringTestsXYZM: XCTestCase {
    func testInitWithXYZM() throws {
        let lineString1 = try LineString(points: [
            Point(x: 1, y: 2, z: 3, m: 4),
            Point(x: 5, y: 6, z: 7, m: 8)
        ])
        let lineString2 = try LineString(points: [
            Point(x: 9, y: 10, z: 11, m: 12),
            Point(x: 13, y: 14, z: 15, m: 16)
        ])
        let multiLineString1 = MultiLineString(lineStrings: [lineString1, lineString2])
        let multiLineString2 = MultiLineString<XYZM>(multiLineString1)

        XCTAssertEqual(multiLineString2.lineStrings.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].x, 1)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].y, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].z, 3)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[0].m, 4)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].x, 5)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].y, 6)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].z, 7)
        XCTAssertEqual(multiLineString2.lineStrings[0].points[1].m, 8)
        XCTAssertEqual(multiLineString2.lineStrings[1].points.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].x, 9)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].y, 10)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].z, 11)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[0].m, 12)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].x, 13)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].y, 14)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].z, 15)
        XCTAssertEqual(multiLineString2.lineStrings[1].points[1].m, 16)
    }
}
