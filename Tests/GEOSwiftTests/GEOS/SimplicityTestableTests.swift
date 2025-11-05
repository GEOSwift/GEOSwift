import XCTest
import GEOSwift

final class SimplicityTestableTests: GEOSTestCase_XY {

    lazy var simplicityTestables: [any SimplicityTestable] = [
        point1,
        multiPoint,
        lineString1,
        multiLineString,
        linearRingHole1,
        polygonWithHole,
        multiPolygon]

    func testIsSimple() {
        // multi point is simple iff it contains no repeated points
        var multiPoint = MultiPoint(points: [point1])

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
