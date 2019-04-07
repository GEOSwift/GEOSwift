import XCTest
import GEOSwift

final class LineStringConvertibleTests: XCTestCase {
    func testLineStringLineString() {
        XCTAssertEqual(LineString.testValue1.lineString, .testValue1)
    }

    func testPolygon_LinearRingLineString() {
        XCTAssertEqual(
            Polygon.LinearRing.testValueHole1.lineString,
            LineString(Polygon.LinearRing.testValueHole1))
    }
}
