import XCTest
import GEOSwift

// MARK: - Test Value Extensions for XYM

private extension Point where C == XYM {
    static let testValue1 = Point(XYM(1, 2, 0))
    static let testValue3 = Point(XYM(3, 4, 1))
    static let testValue5 = Point(XYM(5, 6, 2))
    static let testValue7 = Point(XYM(7, 8, 3))
}

private extension LineString where C == XYM {
    static let testValue1 = try! LineString(coordinates: [
        Point<XYM>.testValue1.coordinates,
        Point<XYM>.testValue3.coordinates
    ])
    static let testValue5 = try! LineString(coordinates: [
        Point<XYM>.testValue5.coordinates,
        Point<XYM>.testValue7.coordinates
    ])
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

final class IntersectionTests_XYM: XCTestCase {
    let geometryConvertibles: [any GeometryConvertible<XYM>] = [
        Point<XYM>.testValue1,
        Geometry.point(Point<XYM>.testValue1),
        MultiPoint<XYM>.testValue,
        Geometry.multiPoint(MultiPoint<XYM>.testValue),
        LineString<XYM>.testValue1,
        Geometry.lineString(LineString<XYM>.testValue1),
        MultiLineString<XYM>.testValue,
        Geometry.multiLineString(MultiLineString<XYM>.testValue),
        Polygon<XYM>.LinearRing.testValueHole1,
        Polygon<XYM>.testValueWithHole,
        Geometry.polygon(Polygon<XYM>.testValueWithHole),
        MultiPolygon<XYM>.testValue,
        Geometry.multiPolygon(MultiPolygon<XYM>.testValue),
        GeometryCollection<XYM>.testValue,
        GeometryCollection<XYM>.testValueWithRecursion,
        Geometry.geometryCollection(GeometryCollection<XYM>.testValue)]

    let unitPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
        XYM(0, 0, 0),
        XYM(1, 0, 1),
        XYM(1, 1, 2),
        XYM(0, 1, 3),
        XYM(0, 0, 4)]))

    // MARK: - XYM ∩ XY → XYM

    func testIntersectionXYMWithXY() throws {
        let lineXY = try! LineString(coordinates: [
            XY(-1, 2),
            XY(2, -1)])
        let result: Geometry<XYM>? = try unitPoly.intersection(with: lineXY)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    // MARK: - XYM ∩ XYZ → XYZM

    func testIntersectionXYMWithXYZ() throws {
        let lineXYZ = try! LineString(coordinates: [
            XYZ(-1, 2, 10),
            XYZ(2, -1, 20)])
        let result: Geometry<XYZM>? = try unitPoly.intersection(with: lineXYZ)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    // MARK: - XYM ∩ XYM → XYM

    func testIntersectionXYMWithXYM() throws {
        let line = try! LineString(coordinates: [
            XYM(-1, 2, 100),
            XYM(2, -1, 200)])
        let result: Geometry<XYM>? = try unitPoly.intersection(with: line)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    func testIntersectionXYMWithXYMAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            XCTAssertNoThrow(try g1.intersection(with: g2) as Geometry<XYM>?)
        }
    }

    // MARK: - XYM ∩ XYZM → XYZM

    func testIntersectionXYMWithXYZM() throws {
        let lineXYZM = try! LineString(coordinates: [
            XYZM(-1, 2, 10, 100),
            XYZM(2, -1, 20, 200)])
        let result: Geometry<XYZM>? = try unitPoly.intersection(with: lineXYZM)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }
}
