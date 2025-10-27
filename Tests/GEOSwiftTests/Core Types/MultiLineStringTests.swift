import XCTest
import GEOSwift

final class MultiLineStringTestsXY: XCTestCase {
    func testInitWithLineStrings() {
        let lineStrings = makeLineStrings(withCount: 3)

        let multiLineString = MultiLineString(lineStrings: lineStrings)

        XCTAssertEqual(multiLineString.lineStrings, lineStrings)
    }

    func testInitWithXYZ() throws {
        let coordinates1: [XYZ] = [XYZ(1, 2, 3), XYZ(4, 5, 6)]
        let coordinates2: [XYZ] = [XYZ(7, 8, 9), XYZ(10, 11, 12)]
        let lineString1 = try LineString(coordinates: coordinates1)
        let lineString2 = try LineString(coordinates: coordinates2)
        let multiLineString1 = MultiLineString(lineStrings: [lineString1, lineString2])
        let multiLineString2 = MultiLineString<XY>(multiLineString1)

        XCTAssertEqual(multiLineString2.lineStrings.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].x, 1)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].y, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].x, 4)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].y, 5)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].x, 7)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].y, 8)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].x, 10)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].y, 11)
    }

    func testInitWithXYM() throws {
        let coordinates1: [XYM] = [XYM(1, 2, 3), XYM(4, 5, 6)]
        let coordinates2: [XYM] = [XYM(7, 8, 9), XYM(10, 11, 12)]
        let lineString1 = try LineString(coordinates: coordinates1)
        let lineString2 = try LineString(coordinates: coordinates2)
        let multiLineString1 = MultiLineString(lineStrings: [lineString1, lineString2])
        let multiLineString2 = MultiLineString<XY>(multiLineString1)

        XCTAssertEqual(multiLineString2.lineStrings.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].x, 1)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].y, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].x, 4)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].y, 5)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].x, 7)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].y, 8)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].x, 10)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].y, 11)
    }

    func testInitWithXYZM() throws {
        let coordinates1: [XYZM] = [XYZM(1, 2, 3, 4), XYZM(5, 6, 7, 8)]
        let coordinates2: [XYZM] = [XYZM(9, 10, 11, 12), XYZM(13, 14, 15, 16)]
        let lineString1 = try LineString(coordinates: coordinates1)
        let lineString2 = try LineString(coordinates: coordinates2)
        let multiLineString1 = MultiLineString(lineStrings: [lineString1, lineString2])
        let multiLineString2 = MultiLineString<XY>(multiLineString1)

        XCTAssertEqual(multiLineString2.lineStrings.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].x, 1)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].y, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].x, 5)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].y, 6)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].x, 9)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].y, 10)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].x, 13)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].y, 14)
    }
}

final class MultiLineStringTestsXYZ: XCTestCase {
    func testInitWithXYZM() throws {
        let coordinates1: [XYZM] = [XYZM(1, 2, 3, 4), XYZM(5, 6, 7, 8)]
        let coordinates2: [XYZM] = [XYZM(9, 10, 11, 12), XYZM(13, 14, 15, 16)]
        let lineString1 = try LineString(coordinates: coordinates1)
        let lineString2 = try LineString(coordinates: coordinates2)
        let multiLineString1 = MultiLineString(lineStrings: [lineString1, lineString2])
        let multiLineString2 = MultiLineString<XYZ>(multiLineString1)

        XCTAssertEqual(multiLineString2.lineStrings.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].x, 1)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].y, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].z, 3)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].x, 5)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].y, 6)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].z, 7)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].x, 9)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].y, 10)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].z, 11)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].x, 13)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].y, 14)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].z, 15)
    }
}

final class MultiLineStringTestsXYM: XCTestCase {
    func testInitWithXYZM() throws {
        let coordinates1: [XYZM] = [XYZM(1, 2, 3, 4), XYZM(5, 6, 7, 8)]
        let coordinates2: [XYZM] = [XYZM(9, 10, 11, 12), XYZM(13, 14, 15, 16)]
        let lineString1 = try LineString(coordinates: coordinates1)
        let lineString2 = try LineString(coordinates: coordinates2)
        let multiLineString1 = MultiLineString(lineStrings: [lineString1, lineString2])
        let multiLineString2 = MultiLineString<XYM>(multiLineString1)

        XCTAssertEqual(multiLineString2.lineStrings.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].x, 1)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].y, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].m, 4)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].x, 5)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].y, 6)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].m, 8)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].x, 9)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].y, 10)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].m, 12)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].x, 13)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].y, 14)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].m, 16)
    }
}

final class MultiLineStringTestsXYZM: XCTestCase {
    func testInitWithXYZM() throws {
        let coordinates1: [XYZM] = [XYZM(1, 2, 3, 4), XYZM(5, 6, 7, 8)]
        let coordinates2: [XYZM] = [XYZM(9, 10, 11, 12), XYZM(13, 14, 15, 16)]
        let lineString1 = try LineString(coordinates: coordinates1)
        let lineString2 = try LineString(coordinates: coordinates2)
        let multiLineString1 = MultiLineString(lineStrings: [lineString1, lineString2])
        let multiLineString2 = MultiLineString<XYZM>(multiLineString1)

        XCTAssertEqual(multiLineString2.lineStrings.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].x, 1)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].y, 2)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].z, 3)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[0].m, 4)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].x, 5)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].y, 6)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].z, 7)
        XCTAssertEqual(multiLineString2.lineStrings[0].coordinates[1].m, 8)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates.count, 2)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].x, 9)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].y, 10)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].z, 11)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[0].m, 12)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].x, 13)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].y, 14)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].z, 15)
        XCTAssertEqual(multiLineString2.lineStrings[1].coordinates[1].m, 16)
    }
}
