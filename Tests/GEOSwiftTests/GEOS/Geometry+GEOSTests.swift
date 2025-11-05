import XCTest
@testable import GEOSwift

final class Geometry_GEOSTests: GEOSContextTestCase {
    let point1 = Point<XY>(Fixtures.point1)
    let multiPoint = MultiPoint<XY>(Fixtures.multiPoint)
    let lineString1 = LineString<XY>(Fixtures.lineString1)
    let multiLineString = MultiLineString<XY>(Fixtures.multiLineString)
    let polygonWithHole = Polygon<XY>(Fixtures.polygonWithHole)
    let multiPolygon = MultiPolygon<XY>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XY>(Fixtures.geometryCollection)
    let linearRingHole1 = Polygon<XY>.LinearRing(Fixtures.linearRingHole1)

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
