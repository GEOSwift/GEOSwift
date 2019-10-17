import XCTest
import GEOSwift

final class WKTTests: XCTestCase {

    typealias WKTCompatible = WKTConvertible & WKTInitializable & Equatable

    func verifyGeometryRoundtripToWKT<T>(_ value: T, line: UInt = #line) where T: WKTCompatible {
        do {
            let wkt = try value.wkt()
            let actual = try T(wkt: wkt)
            XCTAssertEqual(actual, value, line: line)
        } catch {
            XCTFail("Unexpected error: \(error)", line: line)
        }
    }

    func testGeometryRoundtripToWKT() {
        let values: [Geometry] = [
            .point(.testValue1),
            .lineString(.testValue1),
            .polygon(.testValueWithHole),
            .multiPoint(.testValue),
            .multiLineString(.testValue),
            .multiPolygon(.testValue),
            .geometryCollection(.testValue),
            .geometryCollection(.testValueWithRecursion)]
        for value in values {
            verifyGeometryRoundtripToWKT(value)
        }
    }

    func testGeometryTypesRoundtripToWKT() {
        verifyGeometryRoundtripToWKT(Point.testValue1)
        verifyGeometryRoundtripToWKT(LineString.testValue1)
        verifyGeometryRoundtripToWKT(Polygon.LinearRing.testValueHole1)
        verifyGeometryRoundtripToWKT(Polygon.testValueWithHole)
        verifyGeometryRoundtripToWKT(MultiPoint.testValue)
        verifyGeometryRoundtripToWKT(MultiLineString.testValue)
        verifyGeometryRoundtripToWKT(MultiPolygon.testValue)
        verifyGeometryRoundtripToWKT(GeometryCollection.testValue)
        verifyGeometryRoundtripToWKT(GeometryCollection.testValueWithRecursion)
    }

    func verifyInitWithInvalidWKT<T>(type: T.Type, line: UInt = #line) where T: WKTInitializable {
        let invalidWKT = "invalid"
        do {
            _ = try T(wkt: invalidWKT)
            XCTFail("Unexpected success", line: line)
        } catch GEOSError.libraryError {
            // Pass
        } catch {
            XCTFail("Unexpected error: \(error)", line: line)
        }
    }

    func testInitWithInvalidWKT() {
        verifyInitWithInvalidWKT(type: Point.self)
        verifyInitWithInvalidWKT(type: LineString.self)
        verifyInitWithInvalidWKT(type: Polygon.LinearRing.self)
        verifyInitWithInvalidWKT(type: Polygon.self)
        verifyInitWithInvalidWKT(type: MultiPoint.self)
        verifyInitWithInvalidWKT(type: MultiLineString.self)
        verifyInitWithInvalidWKT(type: MultiPolygon.self)
        verifyInitWithInvalidWKT(type: GeometryCollection.self)
        verifyInitWithInvalidWKT(type: Geometry.self)
    }

    func verifyInitWithEmptyWKT<T>(type: T.Type, line: UInt = #line) where T: WKTInitializable {
        let emptyWKT = ""
        do {
            _ = try T(wkt: emptyWKT)
            XCTFail("Unexpected success", line: line)
        } catch GEOSError.libraryError {
            // Pass
        } catch {
            XCTFail("Unexpected error: \(error)", line: line)
        }
    }

    func testInitWithEmptyWKT() {
        verifyInitWithEmptyWKT(type: Point.self)
        verifyInitWithEmptyWKT(type: LineString.self)
        verifyInitWithEmptyWKT(type: Polygon.LinearRing.self)
        verifyInitWithEmptyWKT(type: Polygon.self)
        verifyInitWithEmptyWKT(type: MultiPoint.self)
        verifyInitWithEmptyWKT(type: MultiLineString.self)
        verifyInitWithEmptyWKT(type: MultiPolygon.self)
        verifyInitWithEmptyWKT(type: GeometryCollection.self)
        verifyInitWithEmptyWKT(type: Geometry.self)
    }
}
