import XCTest
@testable import GEOSwift

final class Polygon_LinearRing_GEOSTests: GEOSContextTestCase {
    // Convert XYZM fixtures to XY using copy constructors
    let point1 = Point<XY>(Fixtures.point1)
    let linearRingHole1 = Polygon<XY>.LinearRing(Fixtures.linearRingHole1)
    let linearRingExterior2 = Polygon<XY>.LinearRing(Fixtures.linearRingExterior2)
    let linearRingExterior7 = Polygon<XY>.LinearRing(Fixtures.linearRingExterior7)

    func testRoundtripToGEOS() {
        let linearRings: [Polygon.LinearRing] = [
            linearRingHole1, linearRingExterior2, linearRingExterior7]
        for linearRing in linearRings {
            verifyRoundtripToGEOS(value: linearRing)
        }
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try point1.geosObject(with: context)
            _ = try Polygon<XY>.LinearRing(geosObject: geosObject)
        } catch let GEOSError.typeMismatch(actual, expected) {
            XCTAssertEqual(actual, .point)
            XCTAssertEqual(expected, .linearRing)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

final class Polygon_GEOSTests: GEOSContextTestCase {
    // Convert XYZM fixtures to XY using copy constructors
    let point1 = Point<XY>(Fixtures.point1)
    let polygonWithHole = Polygon<XY>(Fixtures.polygonWithHole)
    let polygonWithoutHole = Polygon<XY>(Fixtures.polygonWithoutHole)

    func testRoundtripToGEOS() {
        let polygons: [Polygon] = [polygonWithHole, polygonWithoutHole]
        for polygon in polygons {
            verifyRoundtripToGEOS(value: polygon)
        }
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try point1.geosObject(with: context)
            _ = try Polygon<XY>(geosObject: geosObject)
        } catch let GEOSError.typeMismatch(actual, expected) {
            XCTAssertEqual(actual, .point)
            XCTAssertEqual(expected, .polygon)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
