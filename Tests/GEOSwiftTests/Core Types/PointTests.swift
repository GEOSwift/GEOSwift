import XCTest
import GEOSwift

final class PointTestsXY: XCTestCase {
    func testInitWithLonLat() {
        let point = Point(x: 1, y: 2)

        XCTAssertEqual(point.x, 1)
        XCTAssertEqual(point.y, 2)
    }

    func testInitWithCoordinate() {
        let point = Point(XY(1, 2))

        XCTAssertEqual(point.x, 1)
        XCTAssertEqual(point.y, 2)
    }

    func testInitWithXYZ() {
        let point1 = Point(x: 1, y: 2, z: 3)
        let point2 = Point<XY>(point1)

        XCTAssertEqual(point2.x, 1)
        XCTAssertEqual(point2.y, 2)
    }

    func testInitWithXYM() {
        let point1 = Point(x: 1, y: 2, m: 3)
        let point2 = Point<XY>(point1)

        XCTAssertEqual(point2.x, 1)
        XCTAssertEqual(point2.y, 2)
    }

    func testInitWithXYZM() {
        let point1 = Point(x: 1, y: 2, z: 3, m: 4)
        let point2 = Point<XY>(point1)

        XCTAssertEqual(point2.x, 1)
        XCTAssertEqual(point2.y, 2)
    }
}

final class PointTestsXYZ: XCTestCase {
    func testInitWithXYZ() {
        let point = Point(x: 1, y: 2, z: 3)

        XCTAssertEqual(point.x, 1)
        XCTAssertEqual(point.y, 2)
        XCTAssertEqual(point.z, 3)
    }

    func testInitWithCoordinate() {
        let point = Point(XYZ(1, 2, 3))

        XCTAssertEqual(point.x, 1)
        XCTAssertEqual(point.y, 2)
        XCTAssertEqual(point.z, 3)
    }

    func testInitWithXYZM() {
        let point1 = Point(x: 1, y: 2, z: 3, m: 4)
        let point2 = Point<XYZ>(point1)

        XCTAssertEqual(point2.x, 1)
        XCTAssertEqual(point2.y, 2)
        XCTAssertEqual(point2.z, 3)
    }
}

final class PointTestsXYM: XCTestCase {
    func testInitWithXYM() {
        let point = Point(x: 1, y: 2, m: 3)

        XCTAssertEqual(point.x, 1)
        XCTAssertEqual(point.y, 2)
        XCTAssertEqual(point.m, 3)
    }

    func testInitWithCoordinate() {
        let point = Point(XYM(1, 2, 3))

        XCTAssertEqual(point.x, 1)
        XCTAssertEqual(point.y, 2)
        XCTAssertEqual(point.m, 3)
    }

    func testInitWithXYZM() {
        let point1 = Point(x: 1, y: 2, z: 3, m: 4)
        let point2 = Point<XYM>(point1)

        XCTAssertEqual(point2.x, 1)
        XCTAssertEqual(point2.y, 2)
        XCTAssertEqual(point2.m, 4)
    }
}

final class PointTestsXYZM: XCTestCase {
    func testInitWithXYZM() {
        let point = Point(x: 1, y: 2, z: 3, m: 4)

        XCTAssertEqual(point.x, 1)
        XCTAssertEqual(point.y, 2)
        XCTAssertEqual(point.z, 3)
        XCTAssertEqual(point.m, 4)
    }

    func testInitWithCoordinate() {
        let point = Point(XYZM(1, 2, 3, 4))

        XCTAssertEqual(point.x, 1)
        XCTAssertEqual(point.y, 2)
        XCTAssertEqual(point.z, 3)
        XCTAssertEqual(point.m, 4)
    }
}
