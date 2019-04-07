import XCTest
@testable import GEOSwift

final class Geometry_GEOSTests: GEOSContextTestCase {
    func testRoundtripToGEOS() {
        let values: [Geometry] = [
            .point(.testValue1),
            .multiPoint(.testValue),
            .lineString(.testValue1),
            .multiLineString(.testValue),
            .polygon(.testValueWithHole),
            .multiPolygon(.testValue),
            .geometryCollection(.testValue)]
        for value in values {
            verifyRoundtripToGEOS(value: value)
        }
    }

    func testInitWithGEOSLinearRing() {
        let linearRing = Polygon.LinearRing.testValueHole1

        do {
            let geosObject = try linearRing.geosObject(with: context)

            let geometry = try Geometry(geosObject: geosObject)

            XCTAssertEqual(geometry, .lineString(LineString(linearRing)))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
