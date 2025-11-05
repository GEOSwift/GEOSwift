import XCTest
@testable import GEOSwift

final class Polygon_LinearRing_GEOSTests: GEOSTestCase_XY {

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

final class Polygon_GEOSTests: GEOSTestCase_XY {

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
