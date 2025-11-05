import XCTest
@testable import GEOSwift

final class LineString_GEOSTests: GEOSContextTestCase {
    let lineString1 = LineString<XY>(Fixtures.lineString1)
    let point1 = Point<XY>(Fixtures.point1)

    func testRoundtripToGEOS() {
        verifyRoundtripToGEOS(value: lineString1)
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try point1.geosObject(with: context)
            _ = try LineString<XY>(geosObject: geosObject)
        } catch let GEOSError.typeMismatch(actual, expected) {
            XCTAssertEqual(actual, .point)
            XCTAssertEqual(expected, .lineString)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
