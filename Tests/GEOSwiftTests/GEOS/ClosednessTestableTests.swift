import XCTest
import GEOSwift

final class ClosednessTestableTests: XCTestCase {
    let closednessTestables: [ClosednessTestable] = [
        LineString.testValue1,
        MultiLineString.testValue,
        Polygon.LinearRing.testValueHole1]

    func testIsClosed() {
        var lineString = try! LineString(points: [
            Point(x: 0, y: 0),
            Point(x: 1, y: 0),
            Point(x: 1, y: 1),
            Point(x: 0, y: 1),
            Point(x: 0, y: 0)])

        XCTAssertTrue(try lineString.isClosed())

        lineString = try! LineString(points: lineString.points.dropLast())

        XCTAssertFalse(try lineString.isClosed())
    }

    func testIsClosedAllTypes() {
        for c in closednessTestables {
            do {
                _ = try c.isClosed()
            } catch {
                XCTFail("Unexpected error for \(c) isClosed() \(error)")
            }
        }
    }
}
