import XCTest
import GEOSwift

final class WKBTests: XCTestCase {

    typealias WKBCompatible = WKBConvertible & WKBInitializable & Equatable

    func verifyGeometryRoundtripToWKB<T>(_ value: T, line: UInt = #line) where T: WKBCompatible {
        do {
            let wkb = try value.wkb()
            let actual = try T(wkb: wkb)
            XCTAssertEqual(actual, value, line: line)
        } catch {
            XCTFail("Unexpected error: \(error)", line: line)
        }
    }

    func testGeometryRoundtripToWKB() {
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
            verifyGeometryRoundtripToWKB(value)
        }
    }

    func testGeometryTypesRoundtripToWKB() {
        verifyGeometryRoundtripToWKB(Point.testValue1)
        verifyGeometryRoundtripToWKB(LineString.testValue1)
        verifyGeometryRoundtripToWKB(Polygon.testValueWithHole)
        verifyGeometryRoundtripToWKB(MultiPoint.testValue)
        verifyGeometryRoundtripToWKB(MultiLineString.testValue)
        verifyGeometryRoundtripToWKB(MultiPolygon.testValue)
        verifyGeometryRoundtripToWKB(GeometryCollection.testValue)
        verifyGeometryRoundtripToWKB(GeometryCollection.testValueWithRecursion)
    }

    func testLinearRingRoundtripToWKB() {
        let value = Polygon.LinearRing.testValueHole1
        do {
            let wkb = try value.wkb()
            let actual = try LineString<XY>(wkb: wkb)
            XCTAssertEqual(actual, LineString(value))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func verifyInitWithInvalidWKB<T>(type: T.Type, line: UInt = #line) where T: WKBInitializable {
        let invalidWKB = Data("invalid".utf8)
        do {
            _ = try T(wkb: invalidWKB)
            XCTFail("Unexpected success", line: line)
        } catch GEOSError.libraryError {
            // Pass
        } catch {
            XCTFail("Unexpected error: \(error)", line: line)
        }
    }

    func testInitWithInvalidWKB() {
        verifyInitWithInvalidWKB(type: Point<XY>.self)
        verifyInitWithInvalidWKB(type: LineString<XY>.self)
        verifyInitWithInvalidWKB(type: Polygon<XY>.self)
        verifyInitWithInvalidWKB(type: MultiPoint<XY>.self)
        verifyInitWithInvalidWKB(type: MultiLineString<XY>.self)
        verifyInitWithInvalidWKB(type: MultiPolygon<XY>.self)
        verifyInitWithInvalidWKB(type: GeometryCollection<XY>.self)
        verifyInitWithInvalidWKB(type: Geometry<XY>.self)
    }

    func verifyInitWithEmptyWKB<T>(type: T.Type, line: UInt = #line) where T: WKBInitializable {
        let emptyWKB = Data()
        do {
            _ = try T(wkb: emptyWKB)
            XCTFail("Unexpected success", line: line)
        } catch GEOSError.libraryError {
            // Pass
        } catch {
            XCTFail("Unexpected error: \(error)", line: line)
        }
    }

    func testInitWithEmptyWKB() {
        verifyInitWithEmptyWKB(type: Point<XY>.self)
        verifyInitWithEmptyWKB(type: LineString<XY>.self)
        verifyInitWithEmptyWKB(type: Polygon<XY>.self)
        verifyInitWithEmptyWKB(type: MultiPoint<XY>.self)
        verifyInitWithEmptyWKB(type: MultiLineString<XY>.self)
        verifyInitWithEmptyWKB(type: MultiPolygon<XY>.self)
        verifyInitWithEmptyWKB(type: GeometryCollection<XY>.self)
        verifyInitWithEmptyWKB(type: Geometry<XY>.self)
    }
}
