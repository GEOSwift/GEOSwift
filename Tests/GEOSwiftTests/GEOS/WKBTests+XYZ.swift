import XCTest
import GEOSwift

// MARK: - Test Value Extensions for XYZ

private extension Point where C == XYZ {
    static let testValue1 = Point(x: 1, y: 2, z: 0)
    static let testValue3 = Point(x: 3, y: 4, z: 1)
    static let testValue5 = Point(x: 5, y: 6, z: 2)
    static let testValue7 = Point(x: 7, y: 8, z: 3)
}

private extension LineString where C == XYZ {
    static let testValue1 = try! LineString(points: [.testValue1, .testValue3])
    static let testValue5 = try! LineString(points: [.testValue5, .testValue7])
}

private extension Polygon.LinearRing where C == XYZ {
    // counterclockwise
    static let testValueExterior2 = try! Polygon.LinearRing(points: [
        Point(x: 2, y: 2, z: 0),
        Point(x: -2, y: 2, z: 1),
        Point(x: -2, y: -2, z: 2),
        Point(x: 2, y: -2, z: 3),
        Point(x: 2, y: 2, z: 4)])

    // clockwise
    static let testValueHole1 = try! Polygon.LinearRing(points: [
        Point(x: 1, y: 1, z: 4),
        Point(x: 1, y: -1, z: 3),
        Point(x: -1, y: -1, z: 2),
        Point(x: -1, y: 1, z: 1),
        Point(x: 1, y: 1, z: 0)])

    // counterclockwise
    static let testValueExterior7 = try! Polygon.LinearRing(points: [
        Point(x: 7, y: 2, z: 5),
        Point(x: 3, y: 2, z: 6),
        Point(x: 3, y: -2, z: 7),
        Point(x: 7, y: -2, z: 8),
        Point(x: 7, y: 2, z: 9)])
}

private extension Polygon where C == XYZ {
    static let testValueWithHole = Polygon(
        exterior: Polygon<XYZ>.LinearRing.testValueExterior2,
        holes: [Polygon<XYZ>.LinearRing.testValueHole1])

    static let testValueWithoutHole = Polygon(
        exterior: Polygon<XYZ>.LinearRing.testValueExterior7)
}

private extension MultiPoint where C == XYZ {
    static let testValue = MultiPoint(points: [.testValue1, .testValue3])
}

private extension MultiLineString where C == XYZ {
    static let testValue = MultiLineString(
        lineStrings: [.testValue1, .testValue5])
}

private extension MultiPolygon where C == XYZ {
    static let testValue = MultiPolygon(
        polygons: [.testValueWithHole, .testValueWithoutHole])
}

private extension GeometryCollection where C == XYZ {
    static let testValue = GeometryCollection(
        geometries: [
            Point<XYZ>.testValue1,
            MultiPoint<XYZ>.testValue,
            LineString<XYZ>.testValue1,
            MultiLineString<XYZ>.testValue,
            Polygon<XYZ>.testValueWithHole,
            MultiPolygon<XYZ>.testValue])

    static let testValueWithRecursion = GeometryCollection(
        geometries: [GeometryCollection<XYZ>.testValue])
}

final class WKBTestsXYZ: XCTestCase {

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
        verifyGeometryRoundtripToWKB(Point<XYZ>.testValue1)
        verifyGeometryRoundtripToWKB(LineString<XYZ>.testValue1)
        verifyGeometryRoundtripToWKB(Polygon<XYZ>.testValueWithHole)
        verifyGeometryRoundtripToWKB(MultiPoint<XYZ>.testValue)
        verifyGeometryRoundtripToWKB(MultiLineString<XYZ>.testValue)
        verifyGeometryRoundtripToWKB(MultiPolygon<XYZ>.testValue)
        verifyGeometryRoundtripToWKB(GeometryCollection<XYZ>.testValue)
        verifyGeometryRoundtripToWKB(GeometryCollection<XYZ>.testValueWithRecursion)
    }

    func testLinearRingRoundtripToWKB() {
        let value = Polygon<XYZ>.LinearRing.testValueHole1
        do {
            let wkb = try value.wkb()
            let actual = try LineString<XYZ>(wkb: wkb)
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
