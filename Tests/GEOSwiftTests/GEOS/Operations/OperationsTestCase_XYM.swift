import XCTest
import GEOSwift

/// Base test case for Operations tests using XYM coordinates.
/// Provides all common fixtures converted from XYZM to XYM.
class OperationsTestCase_XYM: XCTestCase {
    // MARK: - Points

    let point1 = Point<XYM>(Fixtures.point1)
    let point3 = Point<XYM>(Fixtures.point3)
    let point5 = Point<XYM>(Fixtures.point5)
    let point7 = Point<XYM>(Fixtures.point7)

    // MARK: - LineStrings

    let lineString5 = LineString<XYM>(Fixtures.lineString5)

    // MARK: - Length Test Fixtures

    let lineString0 = LineString<XYM>(Fixtures.lineString0)
    let lineStringLength1 = LineString<XYM>(Fixtures.lineStringLength1)
    let lineStringLength2 = LineString<XYM>(Fixtures.lineStringLength2)

    let multiLineString0 = MultiLineString<XYM>(Fixtures.multiLineString0)
    let multiLineStringLength1 = MultiLineString<XYM>(Fixtures.multiLineStringLength1)
    let multiLineStringLength3 = MultiLineString<XYM>(Fixtures.multiLineStringLength3)

    let linearRing0 = Polygon<XYM>.LinearRing(Fixtures.linearRing0)
    let linearRingLength4 = Polygon<XYM>.LinearRing(Fixtures.linearRingLength4)

    // MARK: - Linear Rings

    let linearRingExterior2 = Polygon<XYM>.LinearRing(Fixtures.linearRingExterior2)
    let linearRingHole1 = Polygon<XYM>.LinearRing(Fixtures.linearRingHole1)
    let linearRingExterior7 = Polygon<XYM>.LinearRing(Fixtures.linearRingExterior7)

    // MARK: - Polygons

    let polygonWithHole = Polygon<XYM>(Fixtures.polygonWithHole)
    let polygonWithoutHole = Polygon<XYM>(Fixtures.polygonWithoutHole)
    let unitPolygon = Polygon<XYM>(Fixtures.unitPolygon)

    // MARK: - Multi Geometries

    let multiPoint = MultiPoint<XYM>(Fixtures.multiPoint)
    let multiLineString = MultiLineString<XYM>(Fixtures.multiLineString)
    let multiPolygon = MultiPolygon<XYM>(Fixtures.multiPolygon)

    // MARK: - Geometry Collections

    let geometryCollection = GeometryCollection<XYM>(Fixtures.geometryCollection)
    let recursiveGeometryCollection = GeometryCollection<XYM>(Fixtures.recursiveGeometryCollection)
    let collection = GeometryCollection<XYM>(Fixtures.collection)
    let recursiveCollection = GeometryCollection<XYM>(Fixtures.recursiveCollection)

    // MARK: - Common Aliases

    // Aliases for backward compatibility with existing test code
    var lineString1: LineString<XYM> { lineStringLength1 }
    var lineString2: LineString<XYM> { lineStringLength2 }
    var multiLineString1: MultiLineString<XYM> { multiLineStringLength1 }
    var multiLineString2: MultiLineString<XYM> { multiLineStringLength3 }
    var linearRing1: Polygon<XYM>.LinearRing { linearRingLength4 }
    var unitPoly: Polygon<XYM> { unitPolygon }

    // MARK: - Common Test Arrays

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
        recursiveGeometryCollection,
        Geometry.geometryCollection(geometryCollection)
    ]
}
