import XCTest
import GEOSwift

final class BoundableTests: XCTestCase {
    let boundables: [Boundable] = [
        Point.testValue1,
        MultiPoint.testValue,
        LineString.testValue1,
        MultiLineString.testValue,
        Polygon.LinearRing.testValueHole1,
        Polygon.testValueWithHole,
        MultiPolygon.testValue]

    func testBoundaryLine() {
        let line = try! LineString(points: [Point(x: 0, y: 0), Point(x: 1, y: 0)])

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
