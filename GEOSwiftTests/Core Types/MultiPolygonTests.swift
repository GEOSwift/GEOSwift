import XCTest
import GEOSwift

final class MultiPolygonTests: XCTestCase {
    func testInitWithLineStrings() {
        let polygons = makePolygons(withCount: 3)

        let multiPolygon = MultiPolygon(polygons: polygons)

        XCTAssertEqual(multiPolygon.polygons, polygons)
    }
}
