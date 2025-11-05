import XCTest
import GEOSwift

final class WKTTestsXYZM: XCTestCase {

    typealias WKTCompatible = WKTConvertible & WKTInitializable & Equatable

    // Use XYZM fixtures directly (no conversion needed)
    let point1 = Fixtures.point1
    let lineString1 = Fixtures.lineString1
    let linearRingHole1 = Fixtures.linearRingHole1
    let polygonWithHole = Fixtures.polygonWithHole
    let multiPoint = Fixtures.multiPoint
    let multiLineString = Fixtures.multiLineString
    let multiPolygon = Fixtures.multiPolygon
    let geometryCollection = Fixtures.geometryCollection
    let recursiveGeometryCollection = Fixtures.recursiveGeometryCollection

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
            .point(point1),
            .lineString(lineString1),
            .polygon(polygonWithHole),
            .multiPoint(multiPoint),
            .multiLineString(multiLineString),
            .multiPolygon(multiPolygon),
            .geometryCollection(geometryCollection),
            .geometryCollection(recursiveGeometryCollection)]
        for value in values {
            verifyGeometryRoundtripToWKT(value)
        }
    }

    func testGeometryTypesRoundtripToWKT() {
        verifyGeometryRoundtripToWKT(point1)
        verifyGeometryRoundtripToWKT(lineString1)
        verifyGeometryRoundtripToWKT(linearRingHole1)
        verifyGeometryRoundtripToWKT(polygonWithHole)
        verifyGeometryRoundtripToWKT(multiPoint)
        verifyGeometryRoundtripToWKT(multiLineString)
        verifyGeometryRoundtripToWKT(multiPolygon)
        verifyGeometryRoundtripToWKT(geometryCollection)
        verifyGeometryRoundtripToWKT(recursiveGeometryCollection)
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
