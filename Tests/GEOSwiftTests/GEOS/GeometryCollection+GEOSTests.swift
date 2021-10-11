import XCTest
@testable import GEOSwift

final class GeometryCollection_GEOSTests: GEOSContextTestCase {
    func testRoundtripToGEOS() {
        verifyRoundtripToGEOS(value: GeometryCollection.testValue)
        verifyRoundtripToGEOS(value: GeometryCollection.testValueWithRecursion)
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try Point.testValue1.geosObject(with: context)
            _ = try GeometryCollection(geosObject: geosObject)
        } catch let GEOSError.typeMismatch(actual, expected) {
            XCTAssertEqual(actual, .point)
            XCTAssertEqual(expected, .geometryCollection)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
