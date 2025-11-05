import XCTest
import GEOSwift

// MARK: - Tests

final class WKTTestsXYM: XCTestCase {

    typealias WKTCompatible = WKTConvertible & WKTInitializable & Equatable

    // Convert XYZM fixtures to XYM using copy constructors
    let point1 = Point<XYM>(Fixtures.point1)
    let lineString1 = LineString<XYM>(Fixtures.lineString1)
    let linearRingHole1 = Polygon<XYM>.LinearRing(Fixtures.linearRingHole1)
    let polygonWithHole = Polygon<XYM>(Fixtures.polygonWithHole)
    let multiPoint = MultiPoint<XYM>(Fixtures.multiPoint)
    let multiLineString = MultiLineString<XYM>(Fixtures.multiLineString)
    let multiPolygon = MultiPolygon<XYM>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XYM>(Fixtures.geometryCollection)
    let recursiveGeometryCollection = GeometryCollection<XYM>(Fixtures.recursiveGeometryCollection)

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
        verifyInitWithInvalidWKT(type: Point<XYM>.self)
        verifyInitWithInvalidWKT(type: LineString<XYM>.self)
        verifyInitWithInvalidWKT(type: Polygon<XYM>.LinearRing.self)
        verifyInitWithInvalidWKT(type: Polygon<XYM>.self)
        verifyInitWithInvalidWKT(type: MultiPoint<XYM>.self)
        verifyInitWithInvalidWKT(type: MultiLineString<XYM>.self)
        verifyInitWithInvalidWKT(type: MultiPolygon<XYM>.self)
        verifyInitWithInvalidWKT(type: GeometryCollection<XYM>.self)
        verifyInitWithInvalidWKT(type: Geometry<XYM>.self)
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
        verifyInitWithEmptyWKT(type: Point<XYM>.self)
        verifyInitWithEmptyWKT(type: LineString<XYM>.self)
        verifyInitWithEmptyWKT(type: Polygon<XYM>.LinearRing.self)
        verifyInitWithEmptyWKT(type: Polygon<XYM>.self)
        verifyInitWithEmptyWKT(type: MultiPoint<XYM>.self)
        verifyInitWithEmptyWKT(type: MultiLineString<XYM>.self)
        verifyInitWithEmptyWKT(type: MultiPolygon<XYM>.self)
        verifyInitWithEmptyWKT(type: GeometryCollection<XYM>.self)
        verifyInitWithEmptyWKT(type: Geometry<XYM>.self)
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
        let point = Point(x: 1.11111111111111111, y: 987654321.1234567890, m: 42.123456789)

        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: -1,
            expectedWKT: "POINT M (1.1111111111111112 987654321.1234568357467651 42.1234567890000022)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 0,
            expectedWKT: "POINT M (1 987654321 42)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 1,
            expectedWKT: "POINT M (1.1 987654321.1 42.1)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 5,
            expectedWKT: "POINT M (1.11111 987654321.12346 42.12346)")
    }

    func testWKTOptionsWithoutFixedPrecisionAndAShortFraction() {
        let point = Point(x: 1, y: 987654321.1, m: 42.5)

        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: -1,
            expectedWKT: "POINT M (1.0000000000000000 987654321.1000000238418579 42.5000000000000000)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 0,
            expectedWKT: "POINT M (1 987654321 42)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 1,
            expectedWKT: "POINT M (1.0 987654321.1 42.5)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 5,
            expectedWKT: "POINT M (1.00000 987654321.10000 42.50000)")
    }

    func testWKTOptionsWithoutFixedPrecisionAndFractionalValues() {
        let point = Point(x: 0.1, y: 0.0000001, m: 0.5)

        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: -1,
            expectedWKT: "POINT M (0.1000000000000000 0.0000001000000000 0.5000000000000000)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 0,
            expectedWKT: "POINT M (0 0 0)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 1,
            expectedWKT: "POINT M (0.1 0.0 0.5)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 5,
            expectedWKT: "POINT M (0.10000 0.00000 0.50000)")
    }

    func testWKTOptionsWithFixedPrecisionAndALongFraction() {
        let point = Point(x: 1.11111111111111111, y: 987654321.1234567890, m: 42.123456789)

        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: -1,
            expectedWKT: "POINT M (1.1111111111111112 987654321.1234568 42.123456789)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 0,
            expectedWKT: "POINT M (1 987654321 42)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 1,
            expectedWKT: "POINT M (1.1 987654321.1 42.1)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 5,
            expectedWKT: "POINT M (1.11111 987654321.12346 42.12346)")
    }

    func testWKTOptionsWithFixedPrecisionAndAShortFraction() {
        let point = Point(x: 1, y: 987654321.1, m: 42.5)

        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: -1,
            expectedWKT: "POINT M (1 987654321.1 42.5)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 0,
            expectedWKT: "POINT M (1 987654321 42)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 1,
            expectedWKT: "POINT M (1 987654321.1 42.5)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 5,
            expectedWKT: "POINT M (1 987654321.1 42.5)")
    }

    func testWKTOptionsWithFixedPrecisionAndFractionalValues() {
        let point = Point(x: 0.1, y: 0.000000123456, m: 0.5)

        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: -1,
            expectedWKT: "POINT M (0.1 1.23456e-7 0.5)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 0,
            expectedWKT: "POINT M (0.1 1e-7 0.5)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 1,
            expectedWKT: "POINT M (0.1 1.2e-7 0.5)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 5,
            expectedWKT: "POINT M (0.1 1.23456e-7 0.5)")
    }
}
