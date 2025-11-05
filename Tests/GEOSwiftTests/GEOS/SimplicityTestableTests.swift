import XCTest
import GEOSwift

final class SimplicityTestableTests: XCTestCase {
    // Convert XYZM fixtures to XY using copy constructors
    let point1 = Point<XY>(Fixtures.point1)
    let multiPoint = MultiPoint<XY>(Fixtures.multiPoint)
    let lineString1 = LineString<XY>(Fixtures.lineString1)
    let multiLineString = MultiLineString<XY>(Fixtures.multiLineString)
    let linearRingHole1 = Polygon<XY>.LinearRing(Fixtures.linearRingHole1)
    let polygonWithHole = Polygon<XY>(Fixtures.polygonWithHole)
    let multiPolygon = MultiPolygon<XY>(Fixtures.multiPolygon)

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
