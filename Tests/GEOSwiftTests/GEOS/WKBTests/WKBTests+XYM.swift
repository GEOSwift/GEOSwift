import XCTest
import GEOSwift

// MARK: - Test Value Extensions for XYM

private extension Point where C == XYM {
    static let testValue1 = Point(x: 1, y: 2, m: 0)
    static let testValue3 = Point(x: 3, y: 4, m: 1)
    static let testValue5 = Point(x: 5, y: 6, m: 2)
    static let testValue7 = Point(x: 7, y: 8, m: 3)
}

private extension LineString where C == XYM {
    static let testValue1 = try! LineString(points: [.testValue1, .testValue3])
    static let testValue5 = try! LineString(points: [.testValue5, .testValue7])
}

private extension Polygon.LinearRing where C == XYM {
    // counterclockwise
    static let testValueExterior2 = try! Polygon.LinearRing(coordinates: [
        XYM(2, 2, 0),
        XYM(-2, 2, 0),
        XYM(-2, -2, 0),
        XYM(2, -2, 0),
        XYM(2, 2, 1)])

    // clockwise
    static let testValueHole1 = try! Polygon.LinearRing(coordinates: [
        XYM(1, 1, 0),
        XYM(1, -1, 0),
        XYM(-1, -1, 0),
        XYM(-1, 1, 0),
        XYM(1, 1, 1)])

    // counterclockwise
    static let testValueExterior7 = try! Polygon.LinearRing(coordinates: [
        XYM(7, 2, 0),
        XYM(3, 2, 0),
        XYM(3, -2, 0),
        XYM(7, -2, 0),
        XYM(7, 2, 1)])
}

private extension Polygon where C == XYM {
    static let testValueWithHole = Polygon(
        exterior: Polygon<XYM>.LinearRing.testValueExterior2,
        holes: [Polygon<XYM>.LinearRing.testValueHole1])

    static let testValueWithoutHole = Polygon(
        exterior: Polygon<XYM>.LinearRing.testValueExterior7)
}

private extension MultiPoint where C == XYM {
    static let testValue = MultiPoint(points: [.testValue1, .testValue3])
}

private extension MultiLineString where C == XYM {
    static let testValue = MultiLineString(
        lineStrings: [.testValue1, .testValue5])
}

private extension MultiPolygon where C == XYM {
    static let testValue = MultiPolygon(
        polygons: [.testValueWithHole, .testValueWithoutHole])
}

private extension GeometryCollection where C == XYM {
    static let testValue = GeometryCollection(
        geometries: [
            Point<XYM>.testValue1,
            MultiPoint<XYM>.testValue,
            LineString<XYM>.testValue1,
            MultiLineString<XYM>.testValue,
            Polygon<XYM>.testValueWithHole,
            MultiPolygon<XYM>.testValue])

    static let testValueWithRecursion = GeometryCollection(
        geometries: [GeometryCollection<XYM>.testValue])
}

// MARK: - Tests

final class WKBTestsXYM: XCTestCase {

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
        verifyGeometryRoundtripToWKB(Point<XYM>.testValue1)
        verifyGeometryRoundtripToWKB(LineString<XYM>.testValue1)
        verifyGeometryRoundtripToWKB(Polygon<XYM>.testValueWithHole)
        verifyGeometryRoundtripToWKB(MultiPoint<XYM>.testValue)
        verifyGeometryRoundtripToWKB(MultiLineString<XYM>.testValue)
        verifyGeometryRoundtripToWKB(MultiPolygon<XYM>.testValue)
        verifyGeometryRoundtripToWKB(GeometryCollection<XYM>.testValue)
        verifyGeometryRoundtripToWKB(GeometryCollection<XYM>.testValueWithRecursion)
    }

    func testLinearRingRoundtripToWKB() {
        let value = Polygon<XYM>.LinearRing.testValueHole1
        do {
            let wkb = try value.wkb()
            let actual = try LineString<XYM>(wkb: wkb)
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
