import XCTest
@testable import GEOSwift

final class MultiLineString_GEOSTests: GEOSContextTestCase {
    func testRoundtripToGEOS() {
        verifyRoundtripToGEOS(value: MultiLineString.testValue)
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try Point.testValue1.geosObject(with: context)
            _ = try MultiLineString(geosObject: geosObject)
        } catch let GEOSError.typeMismatch(actual, expected) {
            XCTAssertEqual(actual, .point)
            XCTAssertEqual(expected, .multiLineString)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
