import XCTest
import GEOSwift

final class BoundableTests_XYZM: GEOSTestCase_XYZM {
    let boundables: [any Boundable<XYZM>] = [
        Point(x: 1, y: 2, z: 0, m: 0),
        MultiPoint(points: [Point(x: 1, y: 2, z: 0, m: 0), Point(x: 3, y: 4, z: 1, m: 1)]),
        try! LineString(coordinates: [XYZM(1, 2, 0, 0), XYZM(3, 4, 1, 1)]),
        MultiLineString(lineStrings: [
            try! LineString(coordinates: [XYZM(1, 2, 0, 0), XYZM(3, 4, 1, 1)]),
            try! LineString(coordinates: [XYZM(5, 6, 2, 2), XYZM(7, 8, 3, 3)])
        ]),
        try! Polygon.LinearRing(coordinates: [
            XYZM(1, 1, 0, 0),
            XYZM(1, -1, 0, 0),
            XYZM(-1, -1, 0, 0),
            XYZM(-1, 1, 0, 0),
            XYZM(1, 1, 1, 1)]),
        Polygon(exterior: try! Polygon.LinearRing(coordinates: [
            XYZM(2, 2, 0, 0),
            XYZM(-2, 2, 0, 0),
            XYZM(-2, -2, 0, 0),
            XYZM(2, -2, 0, 0),
            XYZM(2, 2, 1, 1)]),
            holes: [try! Polygon.LinearRing(coordinates: [
                XYZM(1, 1, 0, 0),
                XYZM(1, -1, 0, 0),
                XYZM(-1, -1, 0, 0),
                XYZM(-1, 1, 0, 0),
                XYZM(1, 1, 1, 1)])]),
        MultiPolygon(polygons: [
            Polygon(exterior: try! Polygon.LinearRing(coordinates: [
                XYZM(2, 2, 0, 0),
                XYZM(-2, 2, 0, 0),
                XYZM(-2, -2, 0, 0),
                XYZM(2, -2, 0, 0),
                XYZM(2, 2, 1, 1)]),
                holes: [try! Polygon.LinearRing(coordinates: [
                    XYZM(1, 1, 0, 0),
                    XYZM(1, -1, 0, 0),
                    XYZM(-1, -1, 0, 0),
                    XYZM(-1, 1, 0, 0),
                    XYZM(1, 1, 1, 1)])]),
            Polygon(exterior: try! Polygon.LinearRing(coordinates: [
                XYZM(7, 2, 0, 0),
                XYZM(3, 2, 0, 0),
                XYZM(3, -2, 0, 0),
                XYZM(7, -2, 0, 0),
                XYZM(7, 2, 1, 1)]))
        ])]

    func testBoundaryLine() {
        let line = try! LineString(coordinates: [XYZM(0, 0, 0, 0), XYZM(1, 0, 1, 1)])

        do {
            let boundary = try line.boundary()
            guard case let .multiPoint(multiPoint) = boundary else {
                XCTFail("Expected multipoint, but got \(boundary)")
                return
            }
            XCTAssertEqual(multiPoint.points.count, 2)
            XCTAssertTrue(multiPoint.points.contains(Point(line.coordinates[0])))
            XCTAssertTrue(multiPoint.points.contains(Point(line.coordinates[1])))
        } catch {
            XCTFail("Unexpected error for \(line) boundary() \(error)")
        }
    }

    func testBoundaryAllTypes() {
        for b in boundables {
            do {
                _ = try b.boundary()
            } catch {
                XCTFail("Unexpected error for \(b) boundary() \(error)")
            }
        }
    }
}
