import XCTest
@testable import GEOSwift

final class MultiPoint_GEOSTests: GEOSTestCase_XY {

    func testRoundtripToGEOS() {
        verifyRoundtripToGEOS(value: multiPoint)
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try point1.geosObject(with: context)
            _ = try MultiPoint<XY>(geosObject: geosObject)
        } catch let GEOSError.typeMismatch(actual, expected) {
            XCTAssertEqual(actual, .point)
            XCTAssertEqual(expected, .multiPoint)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
