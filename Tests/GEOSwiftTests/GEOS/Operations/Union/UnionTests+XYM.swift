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

final class UnionTests_XYM: XCTestCase {
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

    let lineString1 = try! LineString(coordinates: [
        XYM(0, 0, 0),
        XYM(1, 0, 1)])

    let unitPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
        XYM(0, 0, 0),
        XYM(1, 0, 1),
        XYM(1, 1, 2),
        XYM(0, 1, 3),
        XYM(0, 0, 4)]))

    func testUnionPointAndLine() {
        let point = Point(x: 2, y: 0)
        let pointWithM = Point(XYM(2, 0, 7))

        // Topological operations only return XY geometries.
        let expected = Geometry.geometryCollection(GeometryCollection(geometries: [LineString<XY>(lineString1), point]))

        XCTAssertEqual(try? lineString1.union(with: pointWithM), expected)
    }

    func testUnionTwoPolygons() {
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

        // Union produces XY geometry and topological equivalence only tests XY geometry
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

        // Topological equivalence only tests XY
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
