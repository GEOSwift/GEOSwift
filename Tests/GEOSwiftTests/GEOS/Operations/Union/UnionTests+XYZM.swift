import XCTest
import GEOSwift

// MARK: - Tests

final class UnionTests_XYZM: XCTestCase {
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

    func testUnionPointAndLine() throws {
        let pointWithZM = Point(XYZM(2, 0, 7, 7))

        let result: Geometry<XYZM>? = try lineString1.union(with: pointWithZM)
        XCTAssertNotNil(result)
    }

    func testUnionTwoPolygons() throws {
        let unitPoly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(1, 0, 0, 0),
            XYZM(2, 0, 1, 1),
            XYZM(2, 1, 2, 2),
            XYZM(1, 1, 3, 3),
            XYZM(1, 0, 0, 0)]))
        let expected = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 0, 0),
            XYZM(2, 0, 3, 1),
            XYZM(2, 1, 2, 2),
            XYZM(0, 1, 1, 3),
            XYZM(0, 0, 0, 0)]))

        let result: Geometry<XYZM>? = try unitPoly.union(with: unitPoly2)
        XCTAssertNotNil(result)
        XCTAssertTrue(try result?.isTopologicallyEquivalent(to: expected) ?? false)
    }

    func testUnionAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            XCTAssertNoThrow(try g1.union(with: g2) as Geometry<XYZM>?)
        }
    }

    func testUnaryUnionCollectionOfTwoPolygons() throws {
        let unitPoly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(1, 0, 0, 0),
            XYZM(2, 0, 1, 1),
            XYZM(2, 1, 2, 2),
            XYZM(1, 1, 3, 3),
            XYZM(1, 0, 0, 0)]))
        let collection = GeometryCollection(geometries: [unitPoly, unitPoly2])
        let expected = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 0, 0),
            XYZM(2, 0, 1, 1),
            XYZM(2, 1, 3, 2),
            XYZM(0, 1, 0, 3),
            XYZM(0, 0, 0, 0)]))

        let result = try collection.unaryUnion()
        XCTAssertTrue(try result.isTopologicallyEquivalent(to: expected))
    }

    func testUnaryUnionAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.unaryUnion()
            } catch {
                XCTFail("Unexpected error for \(g) unaryUnion() \(error)")
            }
        }
    }
}
