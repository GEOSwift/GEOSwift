import XCTest
@testable import GEOSwift

final class Polygon_LinearRing_GEOSTests: GEOSContextTestCase {
    func testRoundtripToGEOS() {
        let linearRings: [Polygon.LinearRing] = [
            .testValueHole1, .testValueExterior2, .testValueExterior7]
        for linearRing in linearRings {
            verifyRoundtripToGEOS(value: linearRing)
        }
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try Point.testValue1.geosObject(with: context)
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
    func testRoundtripToGEOS() {
        let polygons: [Polygon] = [.testValueWithHole, .testValueWithoutHole]
        for polygon in polygons {
            verifyRoundtripToGEOS(value: polygon)
        }
    }

    func testInitFromWrongGEOSType() {
        do {
            let geosObject = try Point.testValue1.geosObject(with: context)
            _ = try Polygon<XY>(geosObject: geosObject)
        } catch let GEOSError.typeMismatch(actual, expected) {
            XCTAssertEqual(actual, .point)
            XCTAssertEqual(expected, .polygon)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
