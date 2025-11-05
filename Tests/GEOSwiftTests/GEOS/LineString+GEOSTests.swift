import XCTest
@testable import GEOSwift

final class LineString_GEOSTests: GEOSTestCase_XY {

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
