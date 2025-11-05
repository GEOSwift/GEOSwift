import XCTest
import GEOSwift

// MARK: - Tests

final class UnionTests_XYZ: XCTestCase {
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

    func testUnionPointAndLine() throws {
        let pointWithZ = Point(XYZ(2, 0, 7))

        let result: Geometry<XYZ>? = try lineString1.union(with: pointWithZ)
        XCTAssertNotNil(result)
    }

    func testUnionTwoPolygons() throws {
        let unitPoly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(1, 0, 0),
            XYZ(2, 0, 1),
            XYZ(2, 1, 2),
            XYZ(1, 1, 3),
            XYZ(1, 0, 0)]))
        let expected = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 0),
            XYZ(2, 0, 3),
            XYZ(2, 1, 2),
            XYZ(0, 1, 1),
            XYZ(0, 0, 0)]))

        let result: Geometry<XYZ>? = try unitPoly.union(with: unitPoly2)
        XCTAssertNotNil(result)
        XCTAssertTrue(try result?.isTopologicallyEquivalent(to: expected) ?? false)
    }

    func testUnionAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            XCTAssertNoThrow(try g1.union(with: g2) as Geometry<XYZ>?)
        }
    }

    func testUnaryUnionCollectionOfTwoPolygons() throws {
        let unitPoly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(1, 0, 0),
            XYZ(2, 0, 1),
            XYZ(2, 1, 2),
            XYZ(1, 1, 3),
            XYZ(1, 0, 0)]))
        let collection = GeometryCollection(geometries: [unitPoly, unitPoly2])
        let expected = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 0),
            XYZ(2, 0, 1),
            XYZ(2, 1, 3),
            XYZ(0, 1, 0),
            XYZ(0, 0, 0)]))

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
