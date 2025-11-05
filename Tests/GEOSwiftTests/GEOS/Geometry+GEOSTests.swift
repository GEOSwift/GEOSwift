import XCTest
@testable import GEOSwift

final class Geometry_GEOSTests: GEOSTestCase_XY {

    func testRoundtripToGEOS() {
        let values: [Geometry] = [
            .point(point1),
            .multiPoint(multiPoint),
            .lineString(lineString1),
            .multiLineString(multiLineString),
            .polygon(polygonWithHole),
            .multiPolygon(multiPolygon),
            .geometryCollection(geometryCollection)]
        for value in values {
            verifyRoundtripToGEOS(value: value)
        }
    }

    func testInitWithGEOSLinearRing() {
        let linearRing = linearRingHole1

        do {
            let geosObject = try linearRing.geosObject(with: context)

            let geometry = try Geometry<XY>(geosObject: geosObject)

            XCTAssertEqual(geometry, .lineString(LineString(linearRing)))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
