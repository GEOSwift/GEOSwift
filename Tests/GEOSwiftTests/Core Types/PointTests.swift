import XCTest
import GEOSwift

final class PointTests: XCTestCase {
    func testInitWithLonLat() {
        let point = Point(x: 1, y: 2)

        XCTAssertEqual(point.x, 1)
        XCTAssertEqual(point.y, 2)
    }
}
