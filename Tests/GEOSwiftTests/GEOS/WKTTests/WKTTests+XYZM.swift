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
    static let testValueExterior2 = try! Polygon.LinearRing(coordinates: [
        XYZM(2, 2, 0, 0),
        XYZM(-2, 2, 0, 0),
        XYZM(-2, -2, 0, 0),
        XYZM(2, -2, 0, 0),
        XYZM(2, 2, 1, 1)])

    // clockwise
    static let testValueHole1 = try! Polygon.LinearRing(coordinates: [
        XYZM(1, 1, 0, 0),
        XYZM(1, -1, 0, 0),
        XYZM(-1, -1, 0, 0),
        XYZM(-1, 1, 0, 0),
        XYZM(1, 1, 1, 1)])

    // counterclockwise
    static let testValueExterior7 = try! Polygon.LinearRing(coordinates: [
        XYZM(7, 2, 0, 0),
        XYZM(3, 2, 0, 0),
        XYZM(3, -2, 0, 0),
        XYZM(7, -2, 0, 0),
        XYZM(7, 2, 1, 1)])
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

final class WKTTestsXYZM: XCTestCase {

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
            verifyGeometryRoundtripToWKT(value)
        }
    }

    func testGeometryTypesRoundtripToWKT() {
        verifyGeometryRoundtripToWKT(Point<XYZM>.testValue1)
        verifyGeometryRoundtripToWKT(LineString<XYZM>.testValue1)
        verifyGeometryRoundtripToWKT(Polygon<XYZM>.LinearRing.testValueHole1)
        verifyGeometryRoundtripToWKT(Polygon<XYZM>.testValueWithHole)
        verifyGeometryRoundtripToWKT(MultiPoint<XYZM>.testValue)
        verifyGeometryRoundtripToWKT(MultiLineString<XYZM>.testValue)
        verifyGeometryRoundtripToWKT(MultiPolygon<XYZM>.testValue)
        verifyGeometryRoundtripToWKT(GeometryCollection<XYZM>.testValue)
        verifyGeometryRoundtripToWKT(GeometryCollection<XYZM>.testValueWithRecursion)
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
        verifyInitWithInvalidWKT(type: Point<XYZM>.self)
        verifyInitWithInvalidWKT(type: LineString<XYZM>.self)
        verifyInitWithInvalidWKT(type: Polygon<XYZM>.LinearRing.self)
        verifyInitWithInvalidWKT(type: Polygon<XYZM>.self)
        verifyInitWithInvalidWKT(type: MultiPoint<XYZM>.self)
        verifyInitWithInvalidWKT(type: MultiLineString<XYZM>.self)
        verifyInitWithInvalidWKT(type: MultiPolygon<XYZM>.self)
        verifyInitWithInvalidWKT(type: GeometryCollection<XYZM>.self)
        verifyInitWithInvalidWKT(type: Geometry<XYZM>.self)
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
        verifyInitWithEmptyWKT(type: Point<XYZM>.self)
        verifyInitWithEmptyWKT(type: LineString<XYZM>.self)
        verifyInitWithEmptyWKT(type: Polygon<XYZM>.LinearRing.self)
        verifyInitWithEmptyWKT(type: Polygon<XYZM>.self)
        verifyInitWithEmptyWKT(type: MultiPoint<XYZM>.self)
        verifyInitWithEmptyWKT(type: MultiLineString<XYZM>.self)
        verifyInitWithEmptyWKT(type: MultiPolygon<XYZM>.self)
        verifyInitWithEmptyWKT(type: GeometryCollection<XYZM>.self)
        verifyInitWithEmptyWKT(type: Geometry<XYZM>.self)
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

    // swiftlint:disable line_length

    func testWKTOptionsWithoutFixedPrecisionAndALongFraction() {
        let point = Point(x: 1.11111111111111111, y: 987654321.1234567890, z: 42.123456789, m: 99.987654321)

        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: -1,
            expectedWKT: "POINT ZM (1.1111111111111112 987654321.1234568357467651 42.1234567890000022 99.9876543209999937)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 0,
            expectedWKT: "POINT ZM (1 987654321 42 100)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 1,
            expectedWKT: "POINT ZM (1.1 987654321.1 42.1 100.0)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 5,
            expectedWKT: "POINT ZM (1.11111 987654321.12346 42.12346 99.98765)")
    }

    func testWKTOptionsWithoutFixedPrecisionAndAShortFraction() {
        let point = Point(x: 1, y: 987654321.1, z: 42, m: 99)

        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: -1,
            expectedWKT: "POINT ZM (1.0000000000000000 987654321.1000000238418579 42.0000000000000000 99.0000000000000000)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 0,
            expectedWKT: "POINT ZM (1 987654321 42 99)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 1,
            expectedWKT: "POINT ZM (1.0 987654321.1 42.0 99.0)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 5,
            expectedWKT: "POINT ZM (1.00000 987654321.10000 42.00000 99.00000)")
    }

    func testWKTOptionsWithoutFixedPrecisionAndFractionalValues() {
        let point = Point(x: 0.1, y: 0.0000001, z: 0.000042, m: 0.00000789)

        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: -1,
            expectedWKT: "POINT ZM (0.1000000000000000 0.0000001000000000 0.0000420000000000 0.0000078900000000)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 0,
            expectedWKT: "POINT ZM (0 0 0 0)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 1,
            expectedWKT: "POINT ZM (0.1 0.0 0.0 0.0)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 5,
            expectedWKT: "POINT ZM (0.10000 0.00000 0.00004 0.00001)")
    }

    func testWKTOptionsWithFixedPrecisionAndALongFraction() {
        let point = Point(x: 1.11111111111111111, y: 987654321.1234567890, z: 42.123456789, m: 99.987654321)

        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: -1,
            expectedWKT: "POINT ZM (1.1111111111111112 987654321.1234568 42.123456789 99.987654321)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 0,
            expectedWKT: "POINT ZM (1 987654321 42 100)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 1,
            expectedWKT: "POINT ZM (1.1 987654321.1 42.1 100)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 5,
            expectedWKT: "POINT ZM (1.11111 987654321.12346 42.12346 99.98765)")
    }

    func testWKTOptionsWithFixedPrecisionAndAShortFraction() {
        let point = Point(x: 1, y: 987654321.1, z: 42, m: 99)

        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: -1,
            expectedWKT: "POINT ZM (1 987654321.1 42 99)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 0,
            expectedWKT: "POINT ZM (1 987654321 42 99)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 1,
            expectedWKT: "POINT ZM (1 987654321.1 42 99)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 5,
            expectedWKT: "POINT ZM (1 987654321.1 42 99)")
    }

    func testWKTOptionsWithFixedPrecisionAndFractionalValues() {
        let point = Point(x: 0.1, y: 0.000000123456, z: 0.000042, m: 0.00000789)

        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: -1,
            expectedWKT: "POINT ZM (0.1 1.23456e-7 4.2e-5 7.89e-6)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 0,
            expectedWKT: "POINT ZM (0.1 1e-7 4e-5 8e-6)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 1,
            expectedWKT: "POINT ZM (0.1 1.2e-7 4.2e-5 7.9e-6)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 5,
            expectedWKT: "POINT ZM (0.1 1.23456e-7 4.2e-5 7.89e-6)")
    }

    // swiftlint:enable line_length
}
