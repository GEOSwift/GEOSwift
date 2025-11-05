import XCTest
@testable import GEOSwift

final class MultiLineString_GEOSTests: GEOSContextTestCase {
    let multiLineString = MultiLineString<XY>(Fixtures.multiLineString)
    let point1 = Point<XY>(Fixtures.point1)

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
