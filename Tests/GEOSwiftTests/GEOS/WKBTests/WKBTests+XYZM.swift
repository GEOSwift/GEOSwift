import XCTest
import GEOSwift

// MARK: - Tests

final class WKBTestsXYZM: GEOSTestCase_XYZM {
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
        let values: [Geometry<XYZM>] = [
            .point(point1),
            .lineString(lineString1),
            .polygon(polygonWithHole),
            .multiPoint(multiPoint),
            .multiLineString(multiLineString),
            .multiPolygon(multiPolygon),
            .geometryCollection(geometryCollection),
            .geometryCollection(recursiveGeometryCollection)]
        for value in values {
            verifyGeometryRoundtripToWKB(value)
        }
    }

    func testGeometryTypesRoundtripToWKB() {
        verifyGeometryRoundtripToWKB(point1)
        verifyGeometryRoundtripToWKB(lineString1)
        verifyGeometryRoundtripToWKB(polygonWithHole)
        verifyGeometryRoundtripToWKB(multiPoint)
        verifyGeometryRoundtripToWKB(multiLineString)
        verifyGeometryRoundtripToWKB(multiPolygon)
        verifyGeometryRoundtripToWKB(geometryCollection)
        verifyGeometryRoundtripToWKB(recursiveGeometryCollection)
    }

    func testLinearRingRoundtripToWKB() {
        do {
            let wkb = try linearRingHole1.wkb()
            let actual = try LineString<XYZM>(wkb: wkb)
            XCTAssertEqual(actual, LineString(linearRingHole1))
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
        verifyInitWithInvalidWKB(type: Point<XYZM>.self)
        verifyInitWithInvalidWKB(type: LineString<XYZM>.self)
        verifyInitWithInvalidWKB(type: Polygon<XYZM>.self)
        verifyInitWithInvalidWKB(type: MultiPoint<XYZM>.self)
        verifyInitWithInvalidWKB(type: MultiLineString<XYZM>.self)
        verifyInitWithInvalidWKB(type: MultiPolygon<XYZM>.self)
        verifyInitWithInvalidWKB(type: GeometryCollection<XYZM>.self)
        verifyInitWithInvalidWKB(type: Geometry<XYZM>.self)
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
        verifyInitWithEmptyWKB(type: Point<XYZM>.self)
        verifyInitWithEmptyWKB(type: LineString<XYZM>.self)
        verifyInitWithEmptyWKB(type: Polygon<XYZM>.self)
        verifyInitWithEmptyWKB(type: MultiPoint<XYZM>.self)
        verifyInitWithEmptyWKB(type: MultiLineString<XYZM>.self)
        verifyInitWithEmptyWKB(type: MultiPolygon<XYZM>.self)
        verifyInitWithEmptyWKB(type: GeometryCollection<XYZM>.self)
        verifyInitWithEmptyWKB(type: Geometry<XYZM>.self)
    }
}
