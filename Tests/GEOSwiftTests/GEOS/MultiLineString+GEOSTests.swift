import XCTest
@testable import GEOSwift

final class MultiLineString_GEOSTests: GEOSTestCase_XY {

    func testRoundtripToGEOS() {
        verifyRoundtripToGEOS(value: multiLineString)
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try point1.geosObject(with: context)
            _ = try MultiLineString<XY>(geosObject: geosObject)
        } catch let GEOSError.typeMismatch(actual, expected) {
            XCTAssertEqual(actual, .point)
            XCTAssertEqual(expected, .multiLineString)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
