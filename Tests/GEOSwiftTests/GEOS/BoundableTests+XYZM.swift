import XCTest
import GEOSwift

final class BoundableTests_XYZM: XCTestCase {
    let boundables: [any Boundable<XYZM>] = [
        Point(x: 1, y: 2, z: 0, m: 0),
        MultiPoint(points: [Point(x: 1, y: 2, z: 0, m: 0), Point(x: 3, y: 4, z: 1, m: 1)]),
        try! LineString(points: [Point(x: 1, y: 2, z: 0, m: 0), Point(x: 3, y: 4, z: 1, m: 1)]),
        MultiLineString(lineStrings: [
            try! LineString(points: [Point(x: 1, y: 2, z: 0, m: 0), Point(x: 3, y: 4, z: 1, m: 1)]),
            try! LineString(points: [Point(x: 5, y: 6, z: 2, m: 2), Point(x: 7, y: 8, z: 3, m: 3)])
        ]),
        try! Polygon.LinearRing(points: [
            Point(x: 1, y: 1, z: 0, m: 0),
            Point(x: 1, y: -1, z: 0, m: 0),
            Point(x: -1, y: -1, z: 0, m: 0),
            Point(x: -1, y: 1, z: 0, m: 0),
            Point(x: 1, y: 1, z: 1, m: 1)]),
        Polygon(exterior: try! Polygon.LinearRing(points: [
            Point(x: 2, y: 2, z: 0, m: 0),
            Point(x: -2, y: 2, z: 0, m: 0),
            Point(x: -2, y: -2, z: 0, m: 0),
            Point(x: 2, y: -2, z: 0, m: 0),
            Point(x: 2, y: 2, z: 1, m: 1)]),
            holes: [try! Polygon.LinearRing(points: [
                Point(x: 1, y: 1, z: 0, m: 0),
                Point(x: 1, y: -1, z: 0, m: 0),
                Point(x: -1, y: -1, z: 0, m: 0),
                Point(x: -1, y: 1, z: 0, m: 0),
                Point(x: 1, y: 1, z: 1, m: 1)])]),
        MultiPolygon(polygons: [
            Polygon(exterior: try! Polygon.LinearRing(points: [
                Point(x: 2, y: 2, z: 0, m: 0),
                Point(x: -2, y: 2, z: 0, m: 0),
                Point(x: -2, y: -2, z: 0, m: 0),
                Point(x: 2, y: -2, z: 0, m: 0),
                Point(x: 2, y: 2, z: 1, m: 1)]),
                holes: [try! Polygon.LinearRing(points: [
                    Point(x: 1, y: 1, z: 0, m: 0),
                    Point(x: 1, y: -1, z: 0, m: 0),
                    Point(x: -1, y: -1, z: 0, m: 0),
                    Point(x: -1, y: 1, z: 0, m: 0),
                    Point(x: 1, y: 1, z: 1, m: 1)])]),
            Polygon(exterior: try! Polygon.LinearRing(points: [
                Point(x: 7, y: 2, z: 0, m: 0),
                Point(x: 3, y: 2, z: 0, m: 0),
                Point(x: 3, y: -2, z: 0, m: 0),
                Point(x: 7, y: -2, z: 0, m: 0),
                Point(x: 7, y: 2, z: 1, m: 1)]))
        ])]

    func testBoundaryLine() {
        let line = try! LineString(points: [Point(x: 0, y: 0, z: 0, m: 0), Point(x: 1, y: 0, z: 1, m: 1)])

        do {
            let boundary = try line.boundary()
            guard case let .multiPoint(multiPoint) = boundary else {
                XCTFail("Expected multipoint, but got \(boundary)")
                return
            }
            XCTAssertEqual(multiPoint.points.count, 2)
            XCTAssertTrue(multiPoint.points.contains(line.points[0]))
            XCTAssertTrue(multiPoint.points.contains(line.points[1]))
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
