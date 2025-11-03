import XCTest
import GEOSwift

// MARK: - Test Value Extensions for XYZ

private extension Point where C == XYZ {
    static let testValue1 = Point(XYZ(1, 2, 0))
    static let testValue3 = Point(XYZ(3, 4, 1))
    static let testValue5 = Point(XYZ(5, 6, 2))
    static let testValue7 = Point(XYZ(7, 8, 3))
}

private extension LineString where C == XYZ {
    static let testValue1 = try! LineString(coordinates: [
        Point<XYZ>.testValue1.coordinates,
        Point<XYZ>.testValue3.coordinates
    ])
    static let testValue5 = try! LineString(coordinates: [
        Point<XYZ>.testValue5.coordinates,
        Point<XYZ>.testValue7.coordinates
    ])
}

private extension Polygon.LinearRing where C == XYZ {
    // counterclockwise
    static let testValueExterior2 = try! Polygon.LinearRing(coordinates: [
        XYZ(2, 2, 0),
        XYZ(-2, 2, 1),
        XYZ(-2, -2, 2),
        XYZ(2, -2, 3),
        XYZ(2, 2, 4)])

    // clockwise
    static let testValueHole1 = try! Polygon.LinearRing(coordinates: [
        XYZ(1, 1, 4),
        XYZ(1, -1, 3),
        XYZ(-1, -1, 2),
        XYZ(-1, 1, 1),
        XYZ(1, 1, 0)])

    // counterclockwise
    static let testValueExterior7 = try! Polygon.LinearRing(coordinates: [
        XYZ(7, 2, 5),
        XYZ(3, 2, 6),
        XYZ(3, -2, 7),
        XYZ(7, -2, 8),
        XYZ(7, 2, 9)])
}

private extension Polygon where C == XYZ {
    static let testValueWithHole = Polygon(
        exterior: Polygon<XYZ>.LinearRing.testValueExterior2,
        holes: [Polygon<XYZ>.LinearRing.testValueHole1])

    static let testValueWithoutHole = Polygon(
        exterior: Polygon<XYZ>.LinearRing.testValueExterior7)
}

private extension MultiPoint where C == XYZ {
    static let testValue = MultiPoint(points: [.testValue1, .testValue3])
}

private extension MultiLineString where C == XYZ {
    static let testValue = MultiLineString(
        lineStrings: [.testValue1, .testValue5])
}

private extension MultiPolygon where C == XYZ {
    static let testValue = MultiPolygon(
        polygons: [.testValueWithHole, .testValueWithoutHole])
}

private extension GeometryCollection where C == XYZ {
    static let testValue = GeometryCollection(
        geometries: [
            Point<XYZ>.testValue1,
            MultiPoint<XYZ>.testValue,
            LineString<XYZ>.testValue1,
            MultiLineString<XYZ>.testValue,
            Polygon<XYZ>.testValueWithHole,
            MultiPolygon<XYZ>.testValue])

    static let testValueWithRecursion = GeometryCollection(
        geometries: [GeometryCollection<XYZ>.testValue])
}

// MARK: - Tests

final class UnionTests_XYZ: XCTestCase {
    let geometryConvertibles: [any GeometryConvertible<XYZ>] = [
        Point<XYZ>.testValue1,
        Geometry.point(Point<XYZ>.testValue1),
        MultiPoint<XYZ>.testValue,
        Geometry.multiPoint(MultiPoint<XYZ>.testValue),
        LineString<XYZ>.testValue1,
        Geometry.lineString(LineString<XYZ>.testValue1),
        MultiLineString<XYZ>.testValue,
        Geometry.multiLineString(MultiLineString<XYZ>.testValue),
        Polygon<XYZ>.LinearRing.testValueHole1,
        Polygon<XYZ>.testValueWithHole,
        Geometry.polygon(Polygon<XYZ>.testValueWithHole),
        MultiPolygon<XYZ>.testValue,
        Geometry.multiPolygon(MultiPolygon<XYZ>.testValue),
        GeometryCollection<XYZ>.testValue,
        GeometryCollection<XYZ>.testValueWithRecursion,
        Geometry.geometryCollection(GeometryCollection<XYZ>.testValue)]

    let lineString1 = try! LineString(coordinates: [
        XYZ(0, 0, 0),
        XYZ(1, 0, 0)])

    let unitPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
        XYZ(0, 0, 1),
        XYZ(1, 0, 2),
        XYZ(1, 1, 3),
        XYZ(0, 1, 4),
        XYZ(0, 0, 1)]))

    func testUnionPointAndLine() {
        let point = Point(x: 2, y: 0)
        let pointWithZ = Point(XYZ(2, 0, 7))

        // Topological operations only return XY geometries.
        let expected = Geometry.geometryCollection(GeometryCollection(geometries: [LineString<XY>(lineString1), point]))

        XCTAssertEqual(try? lineString1.union(with: pointWithZ), expected)
    }

    func testUnionTwoPolygons() {
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
