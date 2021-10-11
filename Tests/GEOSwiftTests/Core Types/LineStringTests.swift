import XCTest
import GEOSwift

final class LineStringTests: XCTestCase {
    func testInitWithTooFewPoints() {
        let points = makePoints(withCount: 1)

        do {
            _ = try LineString(points: points)
            XCTFail("Expected constructor to throw")
        } catch GEOSwiftError.tooFewPoints {
            // Pass
        } catch {
            XCTFail("Expected GEOSwiftError.tooFewPoints, but got \(error)")
        }
    }

    func testInitWithEnoughPoints() {
        let points = makePoints(withCount: 2)

        let lineString = try? LineString(points: points)

        XCTAssertEqual(lineString?.points, points)
    }

    func testFirstAndLastPoint() {
        let points = makePoints(withCount: 3)

        let lineString = try? LineString(points: points)

        XCTAssertEqual(lineString?.firstPoint, points[0])
        XCTAssertEqual(lineString?.lastPoint, points[2])
    }

    func testInitWithLinearRing() {
        let lineString = LineString(.testValueHole1)

        XCTAssertEqual(lineString.points, Polygon.LinearRing.testValueHole1.points)
    }
}
