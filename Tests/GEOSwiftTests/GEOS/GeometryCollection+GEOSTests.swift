import XCTest
@testable import GEOSwift

final class GeometryCollection_GEOSTests: GEOSTestCase_XY {

    func testRoundtripToGEOS() {
        verifyRoundtripToGEOS(value: geometryCollection)
        verifyRoundtripToGEOS(value: recursiveGeometryCollection)
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try point1.geosObject(with: context)
            _ = try GeometryCollection<XY>(geosObject: geosObject)
        } catch let GEOSError.typeMismatch(actual, expected) {
            XCTAssertEqual(actual, .point)
            XCTAssertEqual(expected, .geometryCollection)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
