import XCTest
import GEOSwift

final class WKBTestsXYZ: XCTestCase {
    // Convert XYZM fixtures to XYZ using copy constructors
    let point1 = Point<XYZ>(Fixtures.point1)
    let lineString1 = LineString<XYZ>(Fixtures.lineString1)
    let polygonWithHole = Polygon<XYZ>(Fixtures.polygonWithHole)
    let multiPoint = MultiPoint<XYZ>(Fixtures.multiPoint)
    let multiLineString = MultiLineString<XYZ>(Fixtures.multiLineString)
    let multiPolygon = MultiPolygon<XYZ>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XYZ>(Fixtures.geometryCollection)
    let recursiveGeometryCollection = GeometryCollection<XYZ>(Fixtures.recursiveGeometryCollection)
    let linearRingHole1 = Polygon<XYZ>.LinearRing(Fixtures.linearRingHole1)

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
        let values: [Geometry<XYZ>] = [
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
            let actual = try LineString<XYZ>(wkb: wkb)
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
        verifyInitWithInvalidWKB(type: Point<XYZ>.self)
        verifyInitWithInvalidWKB(type: LineString<XYZ>.self)
        verifyInitWithInvalidWKB(type: Polygon<XYZ>.self)
        verifyInitWithInvalidWKB(type: MultiPoint<XYZ>.self)
        verifyInitWithInvalidWKB(type: MultiLineString<XYZ>.self)
        verifyInitWithInvalidWKB(type: MultiPolygon<XYZ>.self)
        verifyInitWithInvalidWKB(type: GeometryCollection<XYZ>.self)
        verifyInitWithInvalidWKB(type: Geometry<XYZ>.self)
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
        verifyInitWithEmptyWKB(type: Point<XYZ>.self)
        verifyInitWithEmptyWKB(type: LineString<XYZ>.self)
        verifyInitWithEmptyWKB(type: Polygon<XYZ>.self)
        verifyInitWithEmptyWKB(type: MultiPoint<XYZ>.self)
        verifyInitWithEmptyWKB(type: MultiLineString<XYZ>.self)
        verifyInitWithEmptyWKB(type: MultiPolygon<XYZ>.self)
        verifyInitWithEmptyWKB(type: GeometryCollection<XYZ>.self)
        verifyInitWithEmptyWKB(type: Geometry<XYZ>.self)
    }
}
