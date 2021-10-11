import XCTest
import GEOSwift

final class MultiPointTests: XCTestCase {
    func testInitWithPoints() {
        let points = makePoints(withCount: 3)

        let multiPoint = MultiPoint(points: points)

        XCTAssertEqual(multiPoint.points, points)
    }
}
