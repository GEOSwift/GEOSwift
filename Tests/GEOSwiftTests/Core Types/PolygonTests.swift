import XCTest
import GEOSwift

final class Polygon_LinearRingTests: XCTestCase {
    func testInitWithTooFewCoordinates() {
        let coordinates: [XY] = [XY(0, 0), XY(1, 1), XY(2, 2)]

        do {
            _ = try Polygon.LinearRing(coordinates: coordinates)
            XCTFail("Expected constructor to throw")
        } catch GEOSwiftError.tooFewPoints {
            // Pass
        } catch {
            XCTFail("Expected GEOSwiftError.tooFewPoints, but got \(error)")
        }
    }

    func testInitWithUnclosedRing() {
        let coordinates: [XY] = [XY(0, 0), XY(1, 1), XY(2, 2), XY(3, 3)]

        do {
            _ = try Polygon.LinearRing(coordinates: coordinates)
            XCTFail("Expected constructor to throw")
        } catch GEOSwiftError.ringNotClosed {
            // Pass
        } catch {
            XCTFail("Expected GEOSwiftError.ringNotClosed, but got \(error)")
        }
    }

    func testInitSuccess() {
        let coordinates: [XY] = [XY(0, 0), XY(1, 1), XY(2, 2), XY(0, 0)]

        let linearRing = try? Polygon.LinearRing(coordinates: coordinates)

        XCTAssertEqual(linearRing?.coordinates, coordinates)
    }

    func testInitWithPoints() {
        var points = makePoints(withCount: 3)
        points.append(points[0])

        let linearRing: Polygon<XY>.LinearRing? = try? Polygon.LinearRing(coordinates: points.map { $0.coordinates })

        XCTAssertEqual(linearRing?.coordinates.count, 4)
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
        let coordinates: [XYZ] = [
            XYZ(0, 0, 1),
            XYZ(1, 0, 2),
            XYZ(1, 1, 3),
            XYZ(0, 0, 4)
        ]
        let ring = try Polygon<XYZ>.LinearRing(coordinates: coordinates)
        let polygon1 = Polygon(exterior: ring)
        let polygon2 = Polygon<XY>(polygon1)

        XCTAssertEqual(polygon2.exterior.coordinates.count, 4)
        XCTAssertEqual(polygon2.exterior.coordinates[0].x, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[0].y, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[1].x, 1)
        XCTAssertEqual(polygon2.exterior.coordinates[1].y, 0)
    }

    func testInitWithXYM() throws {
        let coordinates: [XYM] = [
            XYM(0, 0, 1),
            XYM(1, 0, 2),
            XYM(1, 1, 3),
            XYM(0, 0, 4)
        ]
        let ring = try Polygon<XYM>.LinearRing(coordinates: coordinates)
        let polygon1 = Polygon(exterior: ring)
        let polygon2 = Polygon<XY>(polygon1)

        XCTAssertEqual(polygon2.exterior.coordinates.count, 4)
        XCTAssertEqual(polygon2.exterior.coordinates[0].x, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[0].y, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[1].x, 1)
        XCTAssertEqual(polygon2.exterior.coordinates[1].y, 0)
    }

    func testInitWithXYZM() throws {
        let coordinates: [XYZM] = [
            XYZM(0, 0, 1, 2),
            XYZM(1, 0, 3, 4),
            XYZM(1, 1, 5, 6),
            XYZM(0, 0, 7, 8)
        ]
        let ring = try Polygon<XYZM>.LinearRing(coordinates: coordinates)
        let polygon1 = Polygon(exterior: ring)
        let polygon2 = Polygon<XY>(polygon1)

        XCTAssertEqual(polygon2.exterior.coordinates.count, 4)
        XCTAssertEqual(polygon2.exterior.coordinates[0].x, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[0].y, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[1].x, 1)
        XCTAssertEqual(polygon2.exterior.coordinates[1].y, 0)
    }
}

final class PolygonTestsXYZ: XCTestCase {
    func testInitWithXYZM() throws {
        let coordinates: [XYZM] = [
            XYZM(0, 0, 1, 2),
            XYZM(1, 0, 3, 4),
            XYZM(1, 1, 5, 6),
            XYZM(0, 0, 7, 8)
        ]
        let ring = try Polygon<XYZM>.LinearRing(coordinates: coordinates)
        let polygon1 = Polygon(exterior: ring)
        let polygon2 = Polygon<XYZ>(polygon1)

        XCTAssertEqual(polygon2.exterior.coordinates.count, 4)
        XCTAssertEqual(polygon2.exterior.coordinates[0].x, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[0].y, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[0].z, 1)
        XCTAssertEqual(polygon2.exterior.coordinates[1].x, 1)
        XCTAssertEqual(polygon2.exterior.coordinates[1].y, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[1].z, 3)
        XCTAssertEqual(polygon2.exterior.coordinates[3].x, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[3].y, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[3].z, 7)
    }
}

final class PolygonTestsXYM: XCTestCase {
    func testInitWithXYZM() throws {
        let coordinates: [XYZM] = [
            XYZM(0, 0, 1, 2),
            XYZM(1, 0, 3, 4),
            XYZM(1, 1, 5, 6),
            XYZM(0, 0, 7, 8)
        ]
        let ring = try Polygon<XYZM>.LinearRing(coordinates: coordinates)
        let polygon1 = Polygon(exterior: ring)
        let polygon2 = Polygon<XYM>(polygon1)

        XCTAssertEqual(polygon2.exterior.coordinates.count, 4)
        XCTAssertEqual(polygon2.exterior.coordinates[0].x, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[0].y, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[0].m, 2)
        XCTAssertEqual(polygon2.exterior.coordinates[1].x, 1)
        XCTAssertEqual(polygon2.exterior.coordinates[1].y, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[1].m, 4)
        XCTAssertEqual(polygon2.exterior.coordinates[3].x, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[3].y, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[3].m, 8)
    }
}

final class PolygonTestsXYZM: XCTestCase {
    func testInitWithXYZM() throws {
        let coordinates: [XYZM] = [
            XYZM(0, 0, 1, 2),
            XYZM(1, 0, 3, 4),
            XYZM(1, 1, 5, 6),
            XYZM(0, 0, 7, 8)
        ]
        let ring = try Polygon<XYZM>.LinearRing(coordinates: coordinates)
        let polygon1 = Polygon(exterior: ring)
        let polygon2 = Polygon<XYZM>(polygon1)

        XCTAssertEqual(polygon2.exterior.coordinates.count, 4)
        XCTAssertEqual(polygon2.exterior.coordinates[0].x, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[0].y, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[0].z, 1)
        XCTAssertEqual(polygon2.exterior.coordinates[0].m, 2)
        XCTAssertEqual(polygon2.exterior.coordinates[1].x, 1)
        XCTAssertEqual(polygon2.exterior.coordinates[1].y, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[1].z, 3)
        XCTAssertEqual(polygon2.exterior.coordinates[1].m, 4)
        XCTAssertEqual(polygon2.exterior.coordinates[3].x, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[3].y, 0)
        XCTAssertEqual(polygon2.exterior.coordinates[3].z, 7)
        XCTAssertEqual(polygon2.exterior.coordinates[3].m, 8)
    }
}
