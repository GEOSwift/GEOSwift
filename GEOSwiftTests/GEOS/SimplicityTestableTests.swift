import XCTest
import GEOSwift

final class SimplicityTestableTests: XCTestCase {
    let simplicityTestables: [SimplicityTestable] = [
        Point.testValue1,
        MultiPoint.testValue,
        LineString.testValue1,
        MultiLineString.testValue,
        Polygon.LinearRing.testValueHole1,
        Polygon.testValueWithHole,
        MultiPolygon.testValue]

    func testIsSimple() {
        // multi point is simple iff it contains no repeated points
        var multiPoint = MultiPoint(points: [.testValue1])

        XCTAssertTrue(try multiPoint.isSimple())

        multiPoint.points += multiPoint.points

        XCTAssertFalse(try multiPoint.isSimple())
    }

    func testIsSimpleAllTypes() {
        for s in simplicityTestables {
            do {
                _ = try s.isSimple()
            } catch {
                XCTFail("Unexpected error for \(s) isSimple() \(error)")
            }
        }
    }
}
