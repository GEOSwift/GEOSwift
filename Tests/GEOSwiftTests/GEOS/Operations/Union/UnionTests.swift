import XCTest
import GEOSwift

final class UnionTests: XCTestCase {
    // Convert XYZM fixtures to XY using copy constructors
    let point1 = Point<XY>(Fixtures.point1)
    let multiPoint = MultiPoint<XY>(Fixtures.multiPoint)
    let lineString1 = LineString<XY>(Fixtures.lineString1)
    let multiLineString = MultiLineString<XY>(Fixtures.multiLineString)
    let linearRingHole1 = Polygon<XY>.LinearRing(Fixtures.linearRingHole1)
    let polygonWithHole = Polygon<XY>(Fixtures.polygonWithHole)
    let multiPolygon = MultiPolygon<XY>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XY>(Fixtures.geometryCollection)
    let recursiveGeometryCollection = GeometryCollection<XY>(Fixtures.recursiveGeometryCollection)

    let unitPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
        XY(0, 0),
        XY(1, 0),
        XY(1, 1),
        XY(0, 1),
        XY(0, 0)]))

    lazy var geometryConvertibles: [any GeometryConvertible<XY>] = [
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
        recursiveGeometryCollection,
        Geometry.geometryCollection(geometryCollection)]

    func testUnionPointAndLine() {
        let point = Point(x: 2, y: 0)
        XCTAssertEqual(try? lineString1.union(with: point),
                       .geometryCollection(GeometryCollection(geometries: [lineString1, point])))
    }

    func testUnionTwoPolygons() throws {
        let unitPoly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(1, 0),
            XY(2, 0),
            XY(2, 1),
            XY(1, 1),
            XY(1, 0)]))
        let expected = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 0),
            XY(2, 0),
            XY(2, 1),
            XY(0, 1),
            XY(0, 0)]))

        let result = try unitPoly.union(with: unitPoly2)
        XCTAssertTrue(try result?.isTopologicallyEquivalent(to: expected) ?? false)
    }

    func testUnionAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.union(with: g2)
            } catch {
                XCTFail("Unexpected error for \(g1) union(with: \(g2)) \(error)")
            }
        }
    }

    func testUnaryUnionCollectionOfTwoPolygons() throws {
        let unitPoly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(1, 0),
            XY(2, 0),
            XY(2, 1),
            XY(1, 1),
            XY(1, 0)]))
        let collection = GeometryCollection(geometries: [unitPoly, unitPoly2])
        let expected = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 0),
            XY(2, 0),
            XY(2, 1),
            XY(0, 1),
            XY(0, 0)]))

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
