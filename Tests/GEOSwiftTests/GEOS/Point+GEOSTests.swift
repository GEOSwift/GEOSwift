import XCTest
@testable import GEOSwift

final class Point_GEOSTests: GEOSTestCase_XY {

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
