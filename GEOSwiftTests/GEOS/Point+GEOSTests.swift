import XCTest
@testable import GEOSwift

final class Point_GEOSTests: GEOSContextTestCase {
    func testRoundtripToGEOS() {
        verifyRoundtripToGEOS(value: Point.testValue1)
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try LineString.testValue1.geosObject(with: context)
            _ = try Point(geosObject: geosObject)
        } catch let GEOSError.typeMismatch(actual, expected) {
            XCTAssertEqual(actual, .lineString)
            XCTAssertEqual(expected, .point)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
