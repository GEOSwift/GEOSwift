import XCTest
@testable import GEOSwift

final class MultiPolygon_GEOSTests: GEOSTestCase_XY {

    func testRoundtripToGEOS() {
        verifyRoundtripToGEOS(value: multiPolygon)
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try point1.geosObject(with: context)
            _ = try MultiPolygon<XY>(geosObject: geosObject)
        } catch let GEOSError.typeMismatch(actual, expected) {
            XCTAssertEqual(actual, .point)
            XCTAssertEqual(expected, .multiPolygon)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
