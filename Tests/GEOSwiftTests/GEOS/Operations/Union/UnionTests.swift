import XCTest
import GEOSwift

final class UnionTests: XCTestCase {
    let geometryConvertibles: [any GeometryConvertible<XY>] = [
        Point.testValue1,
        Geometry.point(.testValue1),
        MultiPoint.testValue,
        Geometry.multiPoint(.testValue),
        LineString.testValue1,
        Geometry.lineString(.testValue1),
        MultiLineString.testValue,
        Geometry.multiLineString(.testValue),
        Polygon.LinearRing.testValueHole1,
        Polygon.testValueWithHole,
        Geometry.polygon(.testValueWithHole),
        MultiPolygon.testValue,
        Geometry.multiPolygon(.testValue),
        GeometryCollection.testValue,
        GeometryCollection.testValueWithRecursion,
        Geometry.geometryCollection(.testValue)]

    let lineString1 = try! LineString(coordinates: [
        XY(0, 0),
        XY(1, 0)])

    let unitPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
        XY(0, 0),
        XY(1, 0),
        XY(1, 1),
        XY(0, 1),
        XY(0, 0)]))

    func testUnionPointAndLine() {
        let point = Point(x: 2, y: 0)
        XCTAssertEqual(try? lineString1.union(with: point),
                       .geometryCollection(GeometryCollection(geometries: [lineString1, point])))
    }

    func testUnionTwoPolygons() {
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
        XCTAssertEqual(try? unitPoly.union(with: unitPoly2).isTopologicallyEquivalent(to: expected), true)
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

    func testUnaryUnionCollectionOfTwoPolygons() {
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
        XCTAssertEqual(try? collection.unaryUnion().isTopologicallyEquivalent(to: expected), true)
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
