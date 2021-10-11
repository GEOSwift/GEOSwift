import XCTest
@testable import GEOSwift

final class MultiPoint_GEOSTests: GEOSContextTestCase {
    func testRoundtripToGEOS() {
        verifyRoundtripToGEOS(value: MultiPoint.testValue)
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try Point.testValue1.geosObject(with: context)
            _ = try MultiPoint(geosObject: geosObject)
        } catch let GEOSError.typeMismatch(actual, expected) {
            XCTAssertEqual(actual, .point)
            XCTAssertEqual(expected, .multiPoint)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
