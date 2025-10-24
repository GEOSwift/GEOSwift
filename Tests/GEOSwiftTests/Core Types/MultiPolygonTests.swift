import XCTest
import GEOSwift

final class MultiPolygonTestsXY: XCTestCase {
    func testInitWithLineStrings() {
        let polygons = makePolygons(withCount: 3)

        let multiPolygon = MultiPolygon(polygons: polygons)

        XCTAssertEqual(multiPolygon.polygons, polygons)
    }

    func testInitWithXYZ() throws {
        let points1 = [
            Point(x: 0, y: 0, z: 1),
            Point(x: 1, y: 0, z: 2),
            Point(x: 1, y: 1, z: 3),
            Point(x: 0, y: 0, z: 4)
        ]
        let points2 = [
            Point(x: 2, y: 2, z: 5),
            Point(x: 3, y: 2, z: 6),
            Point(x: 3, y: 3, z: 7),
            Point(x: 2, y: 2, z: 8)
        ]
        let ring1 = try Polygon<XYZ>.LinearRing(points: points1)
        let ring2 = try Polygon<XYZ>.LinearRing(points: points2)
        let multiPolygon1 = MultiPolygon(polygons: [Polygon(exterior: ring1), Polygon(exterior: ring2)])
        let multiPolygon2 = MultiPolygon<XY>(multiPolygon1)

        XCTAssertEqual(multiPolygon2.polygons.count, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].x, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].x, 3)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].y, 2)
    }

    func testInitWithXYM() throws {
        let points1 = [
            Point(x: 0, y: 0, m: 1),
            Point(x: 1, y: 0, m: 2),
            Point(x: 1, y: 1, m: 3),
            Point(x: 0, y: 0, m: 4)
        ]
        let points2 = [
            Point(x: 2, y: 2, m: 5),
            Point(x: 3, y: 2, m: 6),
            Point(x: 3, y: 3, m: 7),
            Point(x: 2, y: 2, m: 8)
        ]
        let ring1 = try Polygon<XYM>.LinearRing(points: points1)
        let ring2 = try Polygon<XYM>.LinearRing(points: points2)
        let multiPolygon1 = MultiPolygon(polygons: [Polygon(exterior: ring1), Polygon(exterior: ring2)])
        let multiPolygon2 = MultiPolygon<XY>(multiPolygon1)

        XCTAssertEqual(multiPolygon2.polygons.count, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].x, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].x, 3)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].y, 2)
    }

    func testInitWithXYZM() throws {
        let points1 = [
            Point(x: 0, y: 0, z: 1, m: 2),
            Point(x: 1, y: 0, z: 3, m: 4),
            Point(x: 1, y: 1, z: 5, m: 6),
            Point(x: 0, y: 0, z: 7, m: 8)
        ]
        let points2 = [
            Point(x: 2, y: 2, z: 9, m: 10),
            Point(x: 3, y: 2, z: 11, m: 12),
            Point(x: 3, y: 3, z: 13, m: 14),
            Point(x: 2, y: 2, z: 15, m: 16)
        ]
        let ring1 = try Polygon<XYZM>.LinearRing(points: points1)
        let ring2 = try Polygon<XYZM>.LinearRing(points: points2)
        let multiPolygon1 = MultiPolygon(polygons: [Polygon(exterior: ring1), Polygon(exterior: ring2)])
        let multiPolygon2 = MultiPolygon<XY>(multiPolygon1)

        XCTAssertEqual(multiPolygon2.polygons.count, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].x, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].x, 3)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].y, 2)
    }
}

final class MultiPolygonTestsXYZ: XCTestCase {
    func testInitWithXYZM() throws {
        let points1 = [
            Point(x: 0, y: 0, z: 1, m: 2),
            Point(x: 1, y: 0, z: 3, m: 4),
            Point(x: 1, y: 1, z: 5, m: 6),
            Point(x: 0, y: 0, z: 7, m: 8)
        ]
        let points2 = [
            Point(x: 2, y: 2, z: 9, m: 10),
            Point(x: 3, y: 2, z: 11, m: 12),
            Point(x: 3, y: 3, z: 13, m: 14),
            Point(x: 2, y: 2, z: 15, m: 16)
        ]
        let ring1 = try Polygon<XYZM>.LinearRing(points: points1)
        let ring2 = try Polygon<XYZM>.LinearRing(points: points2)
        let multiPolygon1 = MultiPolygon(polygons: [Polygon(exterior: ring1), Polygon(exterior: ring2)])
        let multiPolygon2 = MultiPolygon<XYZ>(multiPolygon1)

        XCTAssertEqual(multiPolygon2.polygons.count, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].z, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].x, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].z, 3)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[3].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[3].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[3].z, 7)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].z, 9)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].x, 3)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].z, 11)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[3].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[3].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[3].z, 15)
    }
}

final class MultiPolygonTestsXYM: XCTestCase {
    func testInitWithXYZM() throws {
        let points1 = [
            Point(x: 0, y: 0, z: 1, m: 2),
            Point(x: 1, y: 0, z: 3, m: 4),
            Point(x: 1, y: 1, z: 5, m: 6),
            Point(x: 0, y: 0, z: 7, m: 8)
        ]
        let points2 = [
            Point(x: 2, y: 2, z: 9, m: 10),
            Point(x: 3, y: 2, z: 11, m: 12),
            Point(x: 3, y: 3, z: 13, m: 14),
            Point(x: 2, y: 2, z: 15, m: 16)
        ]
        let ring1 = try Polygon<XYZM>.LinearRing(points: points1)
        let ring2 = try Polygon<XYZM>.LinearRing(points: points2)
        let multiPolygon1 = MultiPolygon(polygons: [Polygon(exterior: ring1), Polygon(exterior: ring2)])
        let multiPolygon2 = MultiPolygon<XYM>(multiPolygon1)

        XCTAssertEqual(multiPolygon2.polygons.count, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].m, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].x, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].m, 4)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[3].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[3].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[3].m, 8)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].m, 10)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].x, 3)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].m, 12)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[3].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[3].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[3].m, 16)
    }
}

final class MultiPolygonTestsXYZM: XCTestCase {
    func testInitWithXYZM() throws {
        let points1 = [
            Point(x: 0, y: 0, z: 1, m: 2),
            Point(x: 1, y: 0, z: 3, m: 4),
            Point(x: 1, y: 1, z: 5, m: 6),
            Point(x: 0, y: 0, z: 7, m: 8)
        ]
        let points2 = [
            Point(x: 2, y: 2, z: 9, m: 10),
            Point(x: 3, y: 2, z: 11, m: 12),
            Point(x: 3, y: 3, z: 13, m: 14),
            Point(x: 2, y: 2, z: 15, m: 16)
        ]
        let ring1 = try Polygon<XYZM>.LinearRing(points: points1)
        let ring2 = try Polygon<XYZM>.LinearRing(points: points2)
        let multiPolygon1 = MultiPolygon(polygons: [Polygon(exterior: ring1), Polygon(exterior: ring2)])
        let multiPolygon2 = MultiPolygon<XYZM>(multiPolygon1)

        XCTAssertEqual(multiPolygon2.polygons.count, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].z, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[0].m, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].x, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].z, 3)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[1].m, 4)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[3].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[3].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[3].z, 7)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.points[3].m, 8)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].z, 9)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[0].m, 10)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].x, 3)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].z, 11)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[1].m, 12)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[3].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[3].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[3].z, 15)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.points[3].m, 16)
    }
}
