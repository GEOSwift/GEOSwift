import XCTest
import GEOSwift

// MARK: - Tests

final class IntersectionTests_XYM: XCTestCase {
    // Convert XYZM fixtures to XYM using copy constructors
    let point1 = Point<XYM>(Fixtures.point1)
    let multiPoint = MultiPoint<XYM>(Fixtures.multiPoint)
    let lineString1 = LineString<XYM>(Fixtures.lineString1)
    let multiLineString = MultiLineString<XYM>(Fixtures.multiLineString)
    let linearRingHole1 = Polygon<XYM>.LinearRing(Fixtures.linearRingHole1)
    let polygonWithHole = Polygon<XYM>(Fixtures.polygonWithHole)
    let multiPolygon = MultiPolygon<XYM>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XYM>(Fixtures.geometryCollection)
    let unitPoly = Polygon<XYM>(Fixtures.unitPolygon)

    lazy var geometryConvertibles: [any GeometryConvertible<XYM>] = [
        point1,
        Geometry.point(point1),
        multiPoint,
        Geometry.multiPoint(multiPoint),
        lineString1,
        Geometry.lineString(lineString1),
        multiLineString,
        Geometry.multiLineString(multiLineString),
        linearRingHole1,
        polygonWithHole,
        Geometry.polygon(polygonWithHole),
        multiPolygon,
        Geometry.multiPolygon(multiPolygon),
        geometryCollection,
        GeometryCollection<XYM>(Fixtures.recursiveGeometryCollection),
        Geometry.geometryCollection(geometryCollection)
    ]

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
