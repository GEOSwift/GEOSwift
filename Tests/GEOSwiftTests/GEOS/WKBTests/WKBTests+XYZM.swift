import XCTest
import GEOSwift

// MARK: - Test Value Extensions for XYZM

private extension Point where C == XYZM {
    static let testValue1 = Point(x: 1, y: 2, z: 0, m: 0)
    static let testValue3 = Point(x: 3, y: 4, z: 1, m: 1)
    static let testValue5 = Point(x: 5, y: 6, z: 2, m: 2)
    static let testValue7 = Point(x: 7, y: 8, z: 3, m: 3)
}

private extension LineString where C == XYZM {
    static let testValue1 = try! LineString(points: [.testValue1, .testValue3])
    static let testValue5 = try! LineString(points: [.testValue5, .testValue7])
}

private extension Polygon.LinearRing where C == XYZM {
    // counterclockwise
    static let testValueExterior2 = try! Polygon.LinearRing(points: [
        Point(x: 2, y: 2, z: 0, m: 0),
        Point(x: -2, y: 2, z: 0, m: 0),
        Point(x: -2, y: -2, z: 0, m: 0),
        Point(x: 2, y: -2, z: 0, m: 0),
        Point(x: 2, y: 2, z: 1, m: 1)])

    // clockwise
    static let testValueHole1 = try! Polygon.LinearRing(points: [
        Point(x: 1, y: 1, z: 0, m: 0),
        Point(x: 1, y: -1, z: 0, m: 0),
        Point(x: -1, y: -1, z: 0, m: 0),
        Point(x: -1, y: 1, z: 0, m: 0),
        Point(x: 1, y: 1, z: 1, m: 1)])

    // counterclockwise
    static let testValueExterior7 = try! Polygon.LinearRing(points: [
        Point(x: 7, y: 2, z: 0, m: 0),
        Point(x: 3, y: 2, z: 0, m: 0),
        Point(x: 3, y: -2, z: 0, m: 0),
        Point(x: 7, y: -2, z: 0, m: 0),
        Point(x: 7, y: 2, z: 1, m: 1)])
}

private extension Polygon where C == XYZM {
    static let testValueWithHole = Polygon(
        exterior: Polygon<XYZM>.LinearRing.testValueExterior2,
        holes: [Polygon<XYZM>.LinearRing.testValueHole1])

    static let testValueWithoutHole = Polygon(
        exterior: Polygon<XYZM>.LinearRing.testValueExterior7)
}

private extension MultiPoint where C == XYZM {
    static let testValue = MultiPoint(points: [.testValue1, .testValue3])
}

private extension MultiLineString where C == XYZM {
    static let testValue = MultiLineString(
        lineStrings: [.testValue1, .testValue5])
}

private extension MultiPolygon where C == XYZM {
    static let testValue = MultiPolygon(
        polygons: [.testValueWithHole, .testValueWithoutHole])
}

private extension GeometryCollection where C == XYZM {
    static let testValue = GeometryCollection(
        geometries: [
            Point<XYZM>.testValue1,
            MultiPoint<XYZM>.testValue,
            LineString<XYZM>.testValue1,
            MultiLineString<XYZM>.testValue,
            Polygon<XYZM>.testValueWithHole,
            MultiPolygon<XYZM>.testValue])

    static let testValueWithRecursion = GeometryCollection(
        geometries: [GeometryCollection<XYZM>.testValue])
}

// MARK: - Tests

final class WKBTestsXYZM: XCTestCase {

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
        verifyGeometryRoundtripToWKB(Point<XYZM>.testValue1)
        verifyGeometryRoundtripToWKB(LineString<XYZM>.testValue1)
        verifyGeometryRoundtripToWKB(Polygon<XYZM>.testValueWithHole)
        verifyGeometryRoundtripToWKB(MultiPoint<XYZM>.testValue)
        verifyGeometryRoundtripToWKB(MultiLineString<XYZM>.testValue)
        verifyGeometryRoundtripToWKB(MultiPolygon<XYZM>.testValue)
        verifyGeometryRoundtripToWKB(GeometryCollection<XYZM>.testValue)
        verifyGeometryRoundtripToWKB(GeometryCollection<XYZM>.testValueWithRecursion)
    }

    func testLinearRingRoundtripToWKB() {
        let value = Polygon<XYZM>.LinearRing.testValueHole1
        do {
            let wkb = try value.wkb()
            let actual = try LineString<XYZM>(wkb: wkb)
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
