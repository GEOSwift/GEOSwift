import XCTest
@testable import GEOSwift

final class MultiPoint_GEOSTests: GEOSContextTestCase {
    let multiPoint = MultiPoint<XY>(Fixtures.multiPoint)
    let point1 = Point<XY>(Fixtures.point1)

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
