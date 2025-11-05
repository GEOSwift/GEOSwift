import XCTest
import GEOSwift

// MARK: - Tests

final class UnionTests_XYM: GEOSTestCase_XYM {

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
