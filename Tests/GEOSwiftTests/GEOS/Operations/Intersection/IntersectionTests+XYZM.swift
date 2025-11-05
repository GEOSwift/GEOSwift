import XCTest
import GEOSwift

// MARK: - Tests

final class IntersectionTests_XYZM: XCTestCase {
    // Use XYZM fixtures directly
    let point1 = Fixtures.point1
    let multiPoint = Fixtures.multiPoint
    let lineString1 = Fixtures.lineString1
    let multiLineString = Fixtures.multiLineString
    let linearRingHole1 = Fixtures.linearRingHole1
    let polygonWithHole = Fixtures.polygonWithHole
    let multiPolygon = Fixtures.multiPolygon
    let geometryCollection = Fixtures.geometryCollection
    let unitPoly = Fixtures.unitPolygon

    lazy var geometryConvertibles: [any GeometryConvertible<XYZM>] = [
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
        Fixtures.recursiveGeometryCollection,
        Geometry.geometryCollection(geometryCollection)
    ]

    // MARK: - XYZM ∩ XY → XYZM

    func testIntersectionXYZMWithXY() throws {
        let lineXY = try! LineString(coordinates: [
            XY(-1, 2),
            XY(2, -1)])
        let result: Geometry<XYZM>? = try unitPoly.intersection(with: lineXY)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    // MARK: - XYZM ∩ XYZ → XYZM

    func testIntersectionXYZMWithXYZ() throws {
        let lineXYZ = try! LineString(coordinates: [
            XYZ(-1, 2, 10),
            XYZ(2, -1, 20)])
        let result: Geometry<XYZM>? = try unitPoly.intersection(with: lineXYZ)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    // MARK: - XYZM ∩ XYM → XYZM

    func testIntersectionXYZMWithXYM() throws {
        let lineXYM = try! LineString(coordinates: [
            XYM(-1, 2, 100),
            XYM(2, -1, 200)])
        let result: Geometry<XYZM>? = try unitPoly.intersection(with: lineXYM)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    // MARK: - XYZM ∩ XYZM → XYZM

    func testIntersectionXYZMWithXYZM() throws {
        let line = try! LineString(coordinates: [
            XYZM(-1, 2, 10, 100),
            XYZM(2, -1, 20, 200)])
        let result: Geometry<XYZM>? = try unitPoly.intersection(with: line)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    func testIntersectionXYZMWithXYZMAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            XCTAssertNoThrow(try g1.intersection(with: g2) as Geometry<XYZM>?)
        }
    }
}
