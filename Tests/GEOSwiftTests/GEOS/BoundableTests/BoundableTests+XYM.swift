import XCTest
import GEOSwift

final class BoundableTests_XYM: GEOSTestCase_XYM {
    let boundables: [any Boundable<XYM>] = [
        Point(x: 1, y: 2, m: 0),
        MultiPoint(points: [Point(x: 1, y: 2, m: 0), Point(x: 3, y: 4, m: 1)]),
        try! LineString(coordinates: [XYM(1, 2, 0), XYM(3, 4, 1)]),
        MultiLineString(lineStrings: [
            try! LineString(coordinates: [XYM(1, 2, 0), XYM(3, 4, 1)]),
            try! LineString(coordinates: [XYM(5, 6, 2), XYM(7, 8, 3)])
        ]),
        try! Polygon.LinearRing(coordinates: [
            XYM(1, 1, 0),
            XYM(1, -1, 0),
            XYM(-1, -1, 0),
            XYM(-1, 1, 0),
            XYM(1, 1, 1)]),
        Polygon(exterior: try! Polygon.LinearRing(coordinates: [
            XYM(2, 2, 0),
            XYM(-2, 2, 0),
            XYM(-2, -2, 0),
            XYM(2, -2, 0),
            XYM(2, 2, 1)]),
            holes: [try! Polygon.LinearRing(coordinates: [
                XYM(1, 1, 0),
                XYM(1, -1, 0),
                XYM(-1, -1, 0),
                XYM(-1, 1, 0),
                XYM(1, 1, 1)])]),
        MultiPolygon(polygons: [
            Polygon(exterior: try! Polygon.LinearRing(coordinates: [
                XYM(2, 2, 0),
                XYM(-2, 2, 0),
                XYM(-2, -2, 0),
                XYM(2, -2, 0),
                XYM(2, 2, 1)]),
                holes: [try! Polygon.LinearRing(coordinates: [
                    XYM(1, 1, 0),
                    XYM(1, -1, 0),
                    XYM(-1, -1, 0),
                    XYM(-1, 1, 0),
                    XYM(1, 1, 1)])]),
            Polygon(exterior: try! Polygon.LinearRing(coordinates: [
                XYM(7, 2, 0),
                XYM(3, 2, 0),
                XYM(3, -2, 0),
                XYM(7, -2, 0),
                XYM(7, 2, 1)]))
        ])]

    func testBoundaryLine() {
        let line = try! LineString(coordinates: [XYM(0, 0, 0), XYM(1, 0, 1)])

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
