import XCTest
import GEOSwift

final class MultiPolygonTestsXY: XCTestCase {
    func testInitWithLineStrings() {
        let polygons = makePolygons(withCount: 3)

        let multiPolygon = MultiPolygon(polygons: polygons)

        XCTAssertEqual(multiPolygon.polygons, polygons)
    }

    func testInitWithXYZ() throws {
        let coordinates1: [XYZ] = [
            XYZ(0, 0, 1),
            XYZ(1, 0, 2),
            XYZ(1, 1, 3),
            XYZ(0, 0, 4)
        ]
        let coordinates2: [XYZ] = [
            XYZ(2, 2, 5),
            XYZ(3, 2, 6),
            XYZ(3, 3, 7),
            XYZ(2, 2, 8)
        ]
        let ring1 = try Polygon<XYZ>.LinearRing(coordinates: coordinates1)
        let ring2 = try Polygon<XYZ>.LinearRing(coordinates: coordinates2)
        let multiPolygon1 = MultiPolygon(polygons: [Polygon(exterior: ring1), Polygon(exterior: ring2)])
        let multiPolygon2 = MultiPolygon<XY>(multiPolygon1)

        XCTAssertEqual(multiPolygon2.polygons.count, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].x, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].x, 3)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].y, 2)
    }

    func testInitWithXYM() throws {
        let coordinates1: [XYM] = [
            XYM(0, 0, 1),
            XYM(1, 0, 2),
            XYM(1, 1, 3),
            XYM(0, 0, 4)
        ]
        let coordinates2: [XYM] = [
            XYM(2, 2, 5),
            XYM(3, 2, 6),
            XYM(3, 3, 7),
            XYM(2, 2, 8)
        ]
        let ring1 = try Polygon<XYM>.LinearRing(coordinates: coordinates1)
        let ring2 = try Polygon<XYM>.LinearRing(coordinates: coordinates2)
        let multiPolygon1 = MultiPolygon(polygons: [Polygon(exterior: ring1), Polygon(exterior: ring2)])
        let multiPolygon2 = MultiPolygon<XY>(multiPolygon1)

        XCTAssertEqual(multiPolygon2.polygons.count, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].x, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].x, 3)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].y, 2)
    }

    func testInitWithXYZM() throws {
        let coordinates1: [XYZM] = [
            XYZM(0, 0, 1, 2),
            XYZM(1, 0, 3, 4),
            XYZM(1, 1, 5, 6),
            XYZM(0, 0, 7, 8)
        ]
        let coordinates2: [XYZM] = [
            XYZM(2, 2, 9, 10),
            XYZM(3, 2, 11, 12),
            XYZM(3, 3, 13, 14),
            XYZM(2, 2, 15, 16)
        ]
        let ring1 = try Polygon<XYZM>.LinearRing(coordinates: coordinates1)
        let ring2 = try Polygon<XYZM>.LinearRing(coordinates: coordinates2)
        let multiPolygon1 = MultiPolygon(polygons: [Polygon(exterior: ring1), Polygon(exterior: ring2)])
        let multiPolygon2 = MultiPolygon<XY>(multiPolygon1)

        XCTAssertEqual(multiPolygon2.polygons.count, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].x, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].x, 3)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].y, 2)
    }
}

final class MultiPolygonTestsXYZ: XCTestCase {
    func testInitWithXYZM() throws {
        let coordinates1: [XYZM] = [
            XYZM(0, 0, 1, 2),
            XYZM(1, 0, 3, 4),
            XYZM(1, 1, 5, 6),
            XYZM(0, 0, 7, 8)
        ]
        let coordinates2: [XYZM] = [
            XYZM(2, 2, 9, 10),
            XYZM(3, 2, 11, 12),
            XYZM(3, 3, 13, 14),
            XYZM(2, 2, 15, 16)
        ]
        let ring1 = try Polygon<XYZM>.LinearRing(coordinates: coordinates1)
        let ring2 = try Polygon<XYZM>.LinearRing(coordinates: coordinates2)
        let multiPolygon1 = MultiPolygon(polygons: [Polygon(exterior: ring1), Polygon(exterior: ring2)])
        let multiPolygon2 = MultiPolygon<XYZ>(multiPolygon1)

        XCTAssertEqual(multiPolygon2.polygons.count, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].z, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].x, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].z, 3)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[3].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[3].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[3].z, 7)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].z, 9)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].x, 3)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].z, 11)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[3].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[3].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[3].z, 15)
    }
}

final class MultiPolygonTestsXYM: XCTestCase {
    func testInitWithXYZM() throws {
        let coordinates1: [XYZM] = [
            XYZM(0, 0, 1, 2),
            XYZM(1, 0, 3, 4),
            XYZM(1, 1, 5, 6),
            XYZM(0, 0, 7, 8)
        ]
        let coordinates2: [XYZM] = [
            XYZM(2, 2, 9, 10),
            XYZM(3, 2, 11, 12),
            XYZM(3, 3, 13, 14),
            XYZM(2, 2, 15, 16)
        ]
        let ring1 = try Polygon<XYZM>.LinearRing(coordinates: coordinates1)
        let ring2 = try Polygon<XYZM>.LinearRing(coordinates: coordinates2)
        let multiPolygon1 = MultiPolygon(polygons: [Polygon(exterior: ring1), Polygon(exterior: ring2)])
        let multiPolygon2 = MultiPolygon<XYM>(multiPolygon1)

        XCTAssertEqual(multiPolygon2.polygons.count, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].m, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].x, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].m, 4)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[3].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[3].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[3].m, 8)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].m, 10)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].x, 3)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].m, 12)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[3].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[3].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[3].m, 16)
    }
}

final class MultiPolygonTestsXYZM: XCTestCase {
    func testInitWithXYZM() throws {
        let coordinates1: [XYZM] = [
            XYZM(0, 0, 1, 2),
            XYZM(1, 0, 3, 4),
            XYZM(1, 1, 5, 6),
            XYZM(0, 0, 7, 8)
        ]
        let coordinates2: [XYZM] = [
            XYZM(2, 2, 9, 10),
            XYZM(3, 2, 11, 12),
            XYZM(3, 3, 13, 14),
            XYZM(2, 2, 15, 16)
        ]
        let ring1 = try Polygon<XYZM>.LinearRing(coordinates: coordinates1)
        let ring2 = try Polygon<XYZM>.LinearRing(coordinates: coordinates2)
        let multiPolygon1 = MultiPolygon(polygons: [Polygon(exterior: ring1), Polygon(exterior: ring2)])
        let multiPolygon2 = MultiPolygon<XYZM>(multiPolygon1)

        XCTAssertEqual(multiPolygon2.polygons.count, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].z, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[0].m, 2)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].x, 1)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].z, 3)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[1].m, 4)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[3].x, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[3].y, 0)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[3].z, 7)
        XCTAssertEqual(multiPolygon2.polygons[0].exterior.coordinates[3].m, 8)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].z, 9)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[0].m, 10)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].x, 3)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].z, 11)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[1].m, 12)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[3].x, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[3].y, 2)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[3].z, 15)
        XCTAssertEqual(multiPolygon2.polygons[1].exterior.coordinates[3].m, 16)
    }
}
