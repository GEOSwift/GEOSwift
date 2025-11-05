import XCTest
@testable import GEOSwift

final class MultiPolygon_GEOSTests: GEOSContextTestCase {
    let multiPolygon = MultiPolygon<XY>(Fixtures.multiPolygon)
    let point1 = Point<XY>(Fixtures.point1)

    func testRoundtripToGEOS() {
        verifyRoundtripToGEOS(value: multiPolygon)
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try point1.geosObject(with: context)
            _ = try MultiPolygon<XY>(geosObject: geosObject)
        } catch let GEOSError.typeMismatch(actual, expected) {
            XCTAssertEqual(actual, .point)
            XCTAssertEqual(expected, .multiPolygon)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
