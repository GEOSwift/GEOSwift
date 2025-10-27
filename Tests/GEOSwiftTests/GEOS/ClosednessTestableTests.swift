import XCTest
import GEOSwift

final class ClosednessTestableTests: XCTestCase {
    let closednessTestables: [any ClosednessTestable<XY>] = [
        LineString.testValue1,
        MultiLineString.testValue,
        Polygon.LinearRing.testValueHole1]

    func testIsClosed() {
        var lineString = try! LineString(coordinates: [
            XY(0, 0),
            XY(1, 0),
            XY(1, 1),
            XY(0, 1),
            XY(0, 0)])

        XCTAssertTrue(try lineString.isClosed())

        lineString = try! LineString(coordinates: lineString.coordinates.dropLast())

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
