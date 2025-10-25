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

// MARK: - Tests

final class WKTTestsXYZ: XCTestCase {

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
            verifyGeometryRoundtripToWKT(value)
        }
    }

    func testGeometryTypesRoundtripToWKT() {
        verifyGeometryRoundtripToWKT(Point<XYZ>.testValue1)
        verifyGeometryRoundtripToWKT(LineString<XYZ>.testValue1)
        verifyGeometryRoundtripToWKT(Polygon<XYZ>.LinearRing.testValueHole1)
        verifyGeometryRoundtripToWKT(Polygon<XYZ>.testValueWithHole)
        verifyGeometryRoundtripToWKT(MultiPoint<XYZ>.testValue)
        verifyGeometryRoundtripToWKT(MultiLineString<XYZ>.testValue)
        verifyGeometryRoundtripToWKT(MultiPolygon<XYZ>.testValue)
        verifyGeometryRoundtripToWKT(GeometryCollection<XYZ>.testValue)
        verifyGeometryRoundtripToWKT(GeometryCollection<XYZ>.testValueWithRecursion)
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
        verifyInitWithInvalidWKT(type: Point<XYZ>.self)
        verifyInitWithInvalidWKT(type: LineString<XYZ>.self)
        verifyInitWithInvalidWKT(type: Polygon<XYZ>.LinearRing.self)
        verifyInitWithInvalidWKT(type: Polygon<XYZ>.self)
        verifyInitWithInvalidWKT(type: MultiPoint<XYZ>.self)
        verifyInitWithInvalidWKT(type: MultiLineString<XYZ>.self)
        verifyInitWithInvalidWKT(type: MultiPolygon<XYZ>.self)
        verifyInitWithInvalidWKT(type: GeometryCollection<XYZ>.self)
        verifyInitWithInvalidWKT(type: Geometry<XYZ>.self)
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
        verifyInitWithEmptyWKT(type: Point<XYZ>.self)
        verifyInitWithEmptyWKT(type: LineString<XYZ>.self)
        verifyInitWithEmptyWKT(type: Polygon<XYZ>.LinearRing.self)
        verifyInitWithEmptyWKT(type: Polygon<XYZ>.self)
        verifyInitWithEmptyWKT(type: MultiPoint<XYZ>.self)
        verifyInitWithEmptyWKT(type: MultiLineString<XYZ>.self)
        verifyInitWithEmptyWKT(type: MultiPolygon<XYZ>.self)
        verifyInitWithEmptyWKT(type: GeometryCollection<XYZ>.self)
        verifyInitWithEmptyWKT(type: Geometry<XYZ>.self)
    }

    func verifyWKTOptions<T>(wktConvertible: T,
                             trim: Bool,
                             roundingPrecision: Int32,
                             expectedWKT: String,
                             line: UInt = #line) where T: WKTConvertible {
        let wktString = try? wktConvertible.wkt(
            trim: trim,
            roundingPrecision: roundingPrecision)

        XCTAssertEqual(wktString, expectedWKT, line: line)
    }

    func testWKTOptionsWithoutFixedPrecisionAndALongFraction() {
        let point = Point(x: 1.11111111111111111, y: 987654321.1234567890, z: 42.123456789)

        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: -1,
            expectedWKT: "POINT Z (1.1111111111111112 987654321.1234568357467651 42.1234567890000022)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 0,
            expectedWKT: "POINT Z (1 987654321 42)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 1,
            expectedWKT: "POINT Z (1.1 987654321.1 42.1)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 5,
            expectedWKT: "POINT Z (1.11111 987654321.12346 42.12346)")
    }

    func testWKTOptionsWithoutFixedPrecisionAndAShortFraction() {
        let point = Point(x: 1, y: 987654321.1, z: 42)

        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: -1,
            expectedWKT: "POINT Z (1.0000000000000000 987654321.1000000238418579 42.0000000000000000)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 0,
            expectedWKT: "POINT Z (1 987654321 42)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 1,
            expectedWKT: "POINT Z (1.0 987654321.1 42.0)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 5,
            expectedWKT: "POINT Z (1.00000 987654321.10000 42.00000)")
    }

    func testWKTOptionsWithoutFixedPrecisionAndFractionalValues() {
        let point = Point(x: 0.1, y: 0.0000001, z: 0.000042)

        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: -1,
            expectedWKT: "POINT Z (0.1000000000000000 0.0000001000000000 0.0000420000000000)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 0,
            expectedWKT: "POINT Z (0 0 0)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 1,
            expectedWKT: "POINT Z (0.1 0.0 0.0)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 5,
            expectedWKT: "POINT Z (0.10000 0.00000 0.00004)")
    }

    func testWKTOptionsWithFixedPrecisionAndALongFraction() {
        let point = Point(x: 1.11111111111111111, y: 987654321.1234567890, z: 42.123456789)

        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: -1,
            expectedWKT: "POINT Z (1.1111111111111112 987654321.1234568 42.123456789)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 0,
            expectedWKT: "POINT Z (1 987654321 42)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 1,
            expectedWKT: "POINT Z (1.1 987654321.1 42.1)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 5,
            expectedWKT: "POINT Z (1.11111 987654321.12346 42.12346)")
    }

    func testWKTOptionsWithFixedPrecisionAndAShortFraction() {
        let point = Point(x: 1, y: 987654321.1, z: 42)

        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: -1,
            expectedWKT: "POINT Z (1 987654321.1 42)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 0,
            expectedWKT: "POINT Z (1 987654321 42)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 1,
            expectedWKT: "POINT Z (1 987654321.1 42)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 5,
            expectedWKT: "POINT Z (1 987654321.1 42)")
    }

    func testWKTOptionsWithFixedPrecisionAndFractionalValues() {
        let point = Point(x: 0.1, y: 0.000000123456, z: 0.000000987654)

        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: -1,
            expectedWKT: "POINT Z (0.1 1.23456e-7 9.87654e-7)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 0,
            expectedWKT: "POINT Z (0.1 1e-7 10e-7)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 1,
            expectedWKT: "POINT Z (0.1 1.2e-7 9.9e-7)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 5,
            expectedWKT: "POINT Z (0.1 1.23456e-7 9.87654e-7)")
    }
}
