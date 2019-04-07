import XCTest
@testable import GEOSwift

final class MultiPolygon_GEOSTests: GEOSContextTestCase {
    func testRoundtripToGEOS() {
        verifyRoundtripToGEOS(value: MultiPolygon.testValue)
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try Point.testValue1.geosObject(with: context)
            _ = try MultiPolygon(geosObject: geosObject)
        } catch let GEOSError.typeMismatch(actual, expected) {
            XCTAssertEqual(actual, .point)
            XCTAssertEqual(expected, .multiPolygon)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
