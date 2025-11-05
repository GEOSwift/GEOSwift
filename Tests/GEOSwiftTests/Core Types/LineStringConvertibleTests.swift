import XCTest
import GEOSwift

final class LineStringConvertibleTests: XCTestCase {
    // Convert XYZM fixtures to XY using copy constructors
    let lineString1 = LineString<XY>(Fixtures.lineString1)
    let linearRingHole1 = Polygon<XY>.LinearRing(Fixtures.linearRingHole1)

    func testLineStringLineString() {
        XCTAssertEqual(lineString1.lineString, lineString1)
    }

    func testPolygon_LinearRingLineString() {
        XCTAssertEqual(
            linearRingHole1.lineString,
            LineString(linearRingHole1))
    }
}
