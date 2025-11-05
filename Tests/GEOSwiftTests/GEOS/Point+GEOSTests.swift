import XCTest
@testable import GEOSwift

final class Point_GEOSTests: GEOSContextTestCase {
    // Convert XYZM fixtures to XY using copy constructors
    let point1 = Point<XY>(Fixtures.point1)
    let lineString1 = LineString<XY>(Fixtures.lineString1)

    func testRoundtripToGEOS() {
        verifyRoundtripToGEOS(value: point1)
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try lineString1.geosObject(with: context)
            _ = try Point<XY>(geosObject: geosObject)
        } catch let GEOSError.typeMismatch(actual, expected) {
            XCTAssertEqual(actual, .lineString)
            XCTAssertEqual(expected, .point)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
