import XCTest
import GEOSwift

final class WKTTests: GEOSTestCase_XY {
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
        verifyInitWithInvalidWKT(type: Point<XY>.self)
        verifyInitWithInvalidWKT(type: LineString<XY>.self)
        verifyInitWithInvalidWKT(type: Polygon<XY>.LinearRing.self)
        verifyInitWithInvalidWKT(type: Polygon<XY>.self)
        verifyInitWithInvalidWKT(type: MultiPoint<XY>.self)
        verifyInitWithInvalidWKT(type: MultiLineString<XY>.self)
        verifyInitWithInvalidWKT(type: MultiPolygon<XY>.self)
        verifyInitWithInvalidWKT(type: GeometryCollection<XY>.self)
        verifyInitWithInvalidWKT(type: Geometry<XY>.self)
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
        verifyInitWithEmptyWKT(type: Point<XY>.self)
        verifyInitWithEmptyWKT(type: LineString<XY>.self)
        verifyInitWithEmptyWKT(type: Polygon<XY>.LinearRing.self)
        verifyInitWithEmptyWKT(type: Polygon<XY>.self)
        verifyInitWithEmptyWKT(type: MultiPoint<XY>.self)
        verifyInitWithEmptyWKT(type: MultiLineString<XY>.self)
        verifyInitWithEmptyWKT(type: MultiPolygon<XY>.self)
        verifyInitWithEmptyWKT(type: GeometryCollection<XY>.self)
        verifyInitWithEmptyWKT(type: Geometry<XY>.self)
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
        let point = Point(x: 1.11111111111111111, y: 987654321.1234567890)

        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: -1,
            expectedWKT: "POINT (1.1111111111111112 987654321.1234568357467651)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 0,
            expectedWKT: "POINT (1 987654321)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 1,
            expectedWKT: "POINT (1.1 987654321.1)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 5,
            expectedWKT: "POINT (1.11111 987654321.12346)")
    }

    func testWKTOptionsWithoutFixedPrecisionAndAShortFraction() {
        let point = Point(x: 1, y: 987654321.1)

        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: -1,
            expectedWKT: "POINT (1.0000000000000000 987654321.1000000238418579)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 0,
            expectedWKT: "POINT (1 987654321)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 1,
            expectedWKT: "POINT (1.0 987654321.1)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 5,
            expectedWKT: "POINT (1.00000 987654321.10000)")
    }

    func testWKTOptionsWithoutFixedPrecisionAndFractionalValues() {
        let point = Point(x: 0.1, y: 0.0000001)

        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: -1,
            expectedWKT: "POINT (0.1000000000000000 0.0000001000000000)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 0,
            expectedWKT: "POINT (0 0)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 1,
            expectedWKT: "POINT (0.1 0.0)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: false,
            roundingPrecision: 5,
            expectedWKT: "POINT (0.10000 0.00000)")
    }

    func testWKTOptionsWithFixedPrecisionAndALongFraction() {
        let point = Point(x: 1.11111111111111111, y: 987654321.1234567890)

        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: -1,
            expectedWKT: "POINT (1.1111111111111112 987654321.1234568)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 0,
            expectedWKT: "POINT (1 987654321)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 1,
            expectedWKT: "POINT (1.1 987654321.1)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 5,
            expectedWKT: "POINT (1.11111 987654321.12346)")
    }

    func testWKTOptionsWithFixedPrecisionAndAShortFraction() {
        let point = Point(x: 1, y: 987654321.1)

        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: -1,
            expectedWKT: "POINT (1 987654321.1)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 0,
            expectedWKT: "POINT (1 987654321)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 1,
            expectedWKT: "POINT (1 987654321.1)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 5,
            expectedWKT: "POINT (1 987654321.1)")
    }

    func testWKTOptionsWithFixedPrecisionAndFractionalValues() {
        let point = Point(x: 0.1, y: 0.000000123456)

        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: -1,
            expectedWKT: "POINT (0.1 1.23456e-7)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 0,
            expectedWKT: "POINT (0.1 1e-7)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 1,
            expectedWKT: "POINT (0.1 1.2e-7)")
        verifyWKTOptions(
            wktConvertible: point,
            trim: true,
            roundingPrecision: 5,
            expectedWKT: "POINT (0.1 1.23456e-7)")
    }
}
