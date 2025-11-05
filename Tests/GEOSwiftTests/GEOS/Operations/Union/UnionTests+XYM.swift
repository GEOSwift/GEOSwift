import XCTest
import GEOSwift

// MARK: - Tests

final class UnionTests_XYM: XCTestCase {
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

    func testUnionPointAndLine() throws {
        let pointWithM = Point(XYM(2, 0, 7))

        let result: Geometry<XYM>? = try lineString1.union(with: pointWithM)
        XCTAssertNotNil(result)
    }

    func testUnionTwoPolygons() throws {
        let unitPoly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(1, 0, 0),
            XYM(2, 0, 1),
            XYM(2, 1, 2),
            XYM(1, 1, 3),
            XYM(1, 0, 0)]))
        let expected = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0, 0, 0),
            XYM(2, 0, 1),
            XYM(2, 1, 2),
            XYM(0, 1, 3),
            XYM(0, 0, 0)]))

        let result: Geometry<XYM>? = try unitPoly.union(with: unitPoly2)
        XCTAssertNotNil(result)
        XCTAssertTrue(try result?.isTopologicallyEquivalent(to: expected) ?? false)
    }

    func testUnionAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            XCTAssertNoThrow(try g1.union(with: g2) as Geometry<XYM>?)
        }
    }

    func testUnaryUnionCollectionOfTwoPolygons() throws {
        let unitPoly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(1, 0, 0),
            XYM(2, 0, 1),
            XYM(2, 1, 2),
            XYM(1, 1, 3),
            XYM(1, 0, 0)]))
        let collection = GeometryCollection(geometries: [unitPoly, unitPoly2])
        let expected = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYM(0, 0, 0),
            XYM(2, 0, 1),
            XYM(2, 1, 2),
            XYM(0, 1, 3),
            XYM(0, 0, 0)]))

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
