import XCTest
import GEOSwift

final class Polygon_LinearRingTests: XCTestCase {
    func testInitWithTooFewPoints() {
        let points = makePoints(withCount: 3)

        do {
            _ = try Polygon.LinearRing(points: points)
            XCTFail("Expected constructor to throw")
        } catch GEOSwiftError.tooFewPoints {
            // Pass
        } catch {
            XCTFail("Expected GEOSwiftError.tooFewPoints, but got \(error)")
        }
    }

    func testInitWithUnclosedRing() {
        let points = makePoints(withCount: 4)

        do {
            _ = try Polygon.LinearRing(points: points)
            XCTFail("Expected constructor to throw")
        } catch GEOSwiftError.ringNotClosed {
            // Pass
        } catch {
            XCTFail("Expected GEOSwiftError.ringNotClosed, but got \(error)")
        }
    }

    func testInitSuccess() {
        var points = makePoints(withCount: 3)
        points.append(points[0])

        let linearRing = try? Polygon.LinearRing(points: points)

        XCTAssertEqual(linearRing?.points, points)
    }
}

final class PolygonTests: XCTestCase {
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
}
