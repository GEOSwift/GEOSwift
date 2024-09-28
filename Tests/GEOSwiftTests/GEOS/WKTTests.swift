import XCTest
import GEOSwift

final class WKTTests: XCTestCase {

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
        let values: [Geometry] = [
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
        verifyGeometryRoundtripToWKT(Point.testValue1)
        verifyGeometryRoundtripToWKT(LineString.testValue1)
        verifyGeometryRoundtripToWKT(Polygon.LinearRing.testValueHole1)
        verifyGeometryRoundtripToWKT(Polygon.testValueWithHole)
        verifyGeometryRoundtripToWKT(MultiPoint.testValue)
        verifyGeometryRoundtripToWKT(MultiLineString.testValue)
        verifyGeometryRoundtripToWKT(MultiPolygon.testValue)
        verifyGeometryRoundtripToWKT(GeometryCollection.testValue)
        verifyGeometryRoundtripToWKT(GeometryCollection.testValueWithRecursion)
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
        verifyInitWithInvalidWKT(type: Point.self)
        verifyInitWithInvalidWKT(type: LineString.self)
        verifyInitWithInvalidWKT(type: Polygon.LinearRing.self)
        verifyInitWithInvalidWKT(type: Polygon.self)
        verifyInitWithInvalidWKT(type: MultiPoint.self)
        verifyInitWithInvalidWKT(type: MultiLineString.self)
        verifyInitWithInvalidWKT(type: MultiPolygon.self)
        verifyInitWithInvalidWKT(type: GeometryCollection.self)
        verifyInitWithInvalidWKT(type: Geometry.self)
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
        verifyInitWithEmptyWKT(type: Point.self)
        verifyInitWithEmptyWKT(type: LineString.self)
        verifyInitWithEmptyWKT(type: Polygon.LinearRing.self)
        verifyInitWithEmptyWKT(type: Polygon.self)
        verifyInitWithEmptyWKT(type: MultiPoint.self)
        verifyInitWithEmptyWKT(type: MultiLineString.self)
        verifyInitWithEmptyWKT(type: MultiPolygon.self)
        verifyInitWithEmptyWKT(type: GeometryCollection.self)
        verifyInitWithEmptyWKT(type: Geometry.self)
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
