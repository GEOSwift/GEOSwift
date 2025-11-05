import XCTest
import GEOSwift

// MARK: - Tests

final class WKBTestsXYM: XCTestCase {
    // Convert XYZM fixtures to XYM using copy constructors
    let point1 = Point<XYM>(Fixtures.point1)
    let lineString1 = LineString<XYM>(Fixtures.lineString1)
    let polygonWithHole = Polygon<XYM>(Fixtures.polygonWithHole)
    let multiPoint = MultiPoint<XYM>(Fixtures.multiPoint)
    let multiLineString = MultiLineString<XYM>(Fixtures.multiLineString)
    let multiPolygon = MultiPolygon<XYM>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XYM>(Fixtures.geometryCollection)
    let recursiveGeometryCollection = GeometryCollection<XYM>(Fixtures.recursiveGeometryCollection)
    let linearRingHole1 = Polygon<XYM>.LinearRing(Fixtures.linearRingHole1)

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
        let values: [Geometry<XYM>] = [
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
            let actual = try LineString<XYM>(wkb: wkb)
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
        verifyInitWithInvalidWKB(type: Point<XYM>.self)
        verifyInitWithInvalidWKB(type: LineString<XYM>.self)
        verifyInitWithInvalidWKB(type: Polygon<XYM>.self)
        verifyInitWithInvalidWKB(type: MultiPoint<XYM>.self)
        verifyInitWithInvalidWKB(type: MultiLineString<XYM>.self)
        verifyInitWithInvalidWKB(type: MultiPolygon<XYM>.self)
        verifyInitWithInvalidWKB(type: GeometryCollection<XYM>.self)
        verifyInitWithInvalidWKB(type: Geometry<XYM>.self)
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
        verifyInitWithEmptyWKB(type: Point<XYM>.self)
        verifyInitWithEmptyWKB(type: LineString<XYM>.self)
        verifyInitWithEmptyWKB(type: Polygon<XYM>.self)
        verifyInitWithEmptyWKB(type: MultiPoint<XYM>.self)
        verifyInitWithEmptyWKB(type: MultiLineString<XYM>.self)
        verifyInitWithEmptyWKB(type: MultiPolygon<XYM>.self)
        verifyInitWithEmptyWKB(type: GeometryCollection<XYM>.self)
        verifyInitWithEmptyWKB(type: Geometry<XYM>.self)
    }
}
