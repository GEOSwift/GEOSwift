import XCTest
import GEOSwift

/// Base test case for Operations tests using XY coordinates.
/// Provides all common fixtures converted from XYZM to XY.
class OperationsTestCase_XY: XCTestCase {
    // MARK: - Points

    let point1 = Point<XY>(Fixtures.point1)
    let point3 = Point<XY>(Fixtures.point3)
    let point5 = Point<XY>(Fixtures.point5)
    let point7 = Point<XY>(Fixtures.point7)

    // MARK: - LineStrings

    let lineString5 = LineString<XY>(Fixtures.lineString5)

    // MARK: - Length Test Fixtures

    let lineString0 = LineString<XY>(Fixtures.lineString0)
    let lineStringLength1 = LineString<XY>(Fixtures.lineStringLength1)
    let lineStringLength2 = LineString<XY>(Fixtures.lineStringLength2)

    let multiLineString0 = MultiLineString<XY>(Fixtures.multiLineString0)
    let multiLineStringLength1 = MultiLineString<XY>(Fixtures.multiLineStringLength1)
    let multiLineStringLength3 = MultiLineString<XY>(Fixtures.multiLineStringLength3)

    let linearRing0 = Polygon<XY>.LinearRing(Fixtures.linearRing0)
    let linearRingLength4 = Polygon<XY>.LinearRing(Fixtures.linearRingLength4)

    // MARK: - Linear Rings

    let linearRingExterior2 = Polygon<XY>.LinearRing(Fixtures.linearRingExterior2)
    let linearRingHole1 = Polygon<XY>.LinearRing(Fixtures.linearRingHole1)
    let linearRingExterior7 = Polygon<XY>.LinearRing(Fixtures.linearRingExterior7)

    // MARK: - Polygons

    let polygonWithHole = Polygon<XY>(Fixtures.polygonWithHole)
    let polygonWithoutHole = Polygon<XY>(Fixtures.polygonWithoutHole)
    let unitPolygon = Polygon<XY>(Fixtures.unitPolygon)

    // MARK: - Multi Geometries

    let multiPoint = MultiPoint<XY>(Fixtures.multiPoint)
    let multiLineString = MultiLineString<XY>(Fixtures.multiLineString)
    let multiPolygon = MultiPolygon<XY>(Fixtures.multiPolygon)

    // MARK: - Geometry Collections

    let geometryCollection = GeometryCollection<XY>(Fixtures.geometryCollection)
    let recursiveGeometryCollection = GeometryCollection<XY>(Fixtures.recursiveGeometryCollection)
    let collection = GeometryCollection<XY>(Fixtures.collection)
    let recursiveCollection = GeometryCollection<XY>(Fixtures.recursiveCollection)

    // MARK: - Common Aliases

    // Aliases for backward compatibility with existing test code
    var lineString1: LineString<XY> { lineStringLength1 }
    var lineString2: LineString<XY> { lineStringLength2 }
    var multiLineString1: MultiLineString<XY> { multiLineStringLength1 }
    var multiLineString2: MultiLineString<XY> { multiLineStringLength3 }
    var linearRing1: Polygon<XY>.LinearRing { linearRingLength4 }
    var unitPoly: Polygon<XY> { unitPolygon }

    // MARK: - Common Test Arrays

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
        Geometry.geometryCollection(geometryCollection)
    ]
}
