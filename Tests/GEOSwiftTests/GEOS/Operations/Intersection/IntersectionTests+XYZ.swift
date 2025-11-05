import XCTest
import GEOSwift

// MARK: - Tests

final class IntersectionTests_XYZ: XCTestCase {
    // Convert XYZM fixtures to XYZ using copy constructors
    let point1 = Point<XYZ>(Fixtures.point1)
    let multiPoint = MultiPoint<XYZ>(Fixtures.multiPoint)
    let lineString1 = LineString<XYZ>(Fixtures.lineString1)
    let multiLineString = MultiLineString<XYZ>(Fixtures.multiLineString)
    let linearRingHole1 = Polygon<XYZ>.LinearRing(Fixtures.linearRingHole1)
    let polygonWithHole = Polygon<XYZ>(Fixtures.polygonWithHole)
    let multiPolygon = MultiPolygon<XYZ>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XYZ>(Fixtures.geometryCollection)
    let unitPoly = Polygon<XYZ>(Fixtures.unitPolygon)

    lazy var geometryConvertibles: [any GeometryConvertible<XYZ>] = [
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
        GeometryCollection<XYZ>(Fixtures.recursiveGeometryCollection),
        Geometry.geometryCollection(geometryCollection)
    ]

    // MARK: - XYZ ∩ XY → XYZ

    func testIntersectionXYZWithXY() throws {
        let lineXY = try! LineString(coordinates: [
            XY(-1, 2),
            XY(2, -1)])
        let result: Geometry<XYZ>? = try unitPoly.intersection(with: lineXY)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    // MARK: - XYZ ∩ XYZ → XYZ

    func testIntersectionXYZWithXYZ() throws {
        let line = try! LineString(coordinates: [
            XYZ(-1, 2, 10),
            XYZ(2, -1, 20)])
        let result: Geometry<XYZ>? = try unitPoly.intersection(with: line)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    func testIntersectionXYZWithXYZAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            XCTAssertNoThrow(try g1.intersection(with: g2) as Geometry<XYZ>?)
        }
    }

    // MARK: - XYZ ∩ XYM → XYZM

    func testIntersectionXYZWithXYM() throws {
        let lineXYM = try! LineString(coordinates: [
            XYM(-1, 2, 100),
            XYM(2, -1, 200)])
        let result: Geometry<XYZM>? = try unitPoly.intersection(with: lineXYM)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    // MARK: - XYZ ∩ XYZM → XYZM

    func testIntersectionXYZWithXYZM() throws {
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
