import XCTest
import GEOSwift

final class WKBTests: XCTestCase {
    // Convert XYZM fixtures to XY using copy constructors
    let point1 = Point<XY>(Fixtures.point1)
    let lineString1 = LineString<XY>(Fixtures.lineString1)
    let linearRingHole1 = Polygon<XY>.LinearRing(Fixtures.linearRingHole1)
    let polygonWithHole = Polygon<XY>(Fixtures.polygonWithHole)
    let multiPoint = MultiPoint<XY>(Fixtures.multiPoint)
    let multiLineString = MultiLineString<XY>(Fixtures.multiLineString)
    let multiPolygon = MultiPolygon<XY>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XY>(Fixtures.geometryCollection)
    let recursiveGeometryCollection = GeometryCollection<XY>(Fixtures.recursiveGeometryCollection)

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
        let values: [Geometry<XY>] = [
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
        let value = linearRingHole1
        do {
            let wkb = try value.wkb()
            let actual = try LineString<XY>(wkb: wkb)
            XCTAssertEqual(actual, LineString<XY>(value))
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
