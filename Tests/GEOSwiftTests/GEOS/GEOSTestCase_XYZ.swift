import XCTest
import GEOSwift

/// Base test case for GEOS tests using XYZ coordinates.
/// Provides all common fixtures converted from XYZM to XYZ, plus GEOSContext management.
class GEOSTestCase_XYZ: GEOSContextTestCase {
    // MARK: - Points

    let point1 = Point<XYZ>(Fixtures.point1)
    let point3 = Point<XYZ>(Fixtures.point3)
    let point5 = Point<XYZ>(Fixtures.point5)
    let point7 = Point<XYZ>(Fixtures.point7)

    // MARK: - LineStrings

    let lineString5 = LineString<XYZ>(Fixtures.lineString5)

    // MARK: - Length Test Fixtures

    let lineString0 = LineString<XYZ>(Fixtures.lineString0)
    let lineStringLength1 = LineString<XYZ>(Fixtures.lineStringLength1)
    let lineStringLength2 = LineString<XYZ>(Fixtures.lineStringLength2)

    let multiLineString0 = MultiLineString<XYZ>(Fixtures.multiLineString0)
    let multiLineStringLength1 = MultiLineString<XYZ>(Fixtures.multiLineStringLength1)
    let multiLineStringLength3 = MultiLineString<XYZ>(Fixtures.multiLineStringLength3)

    let linearRing0 = Polygon<XYZ>.LinearRing(Fixtures.linearRing0)
    let linearRingLength4 = Polygon<XYZ>.LinearRing(Fixtures.linearRingLength4)

    // MARK: - Linear Rings

    let linearRingExterior2 = Polygon<XYZ>.LinearRing(Fixtures.linearRingExterior2)
    let linearRingHole1 = Polygon<XYZ>.LinearRing(Fixtures.linearRingHole1)
    let linearRingExterior7 = Polygon<XYZ>.LinearRing(Fixtures.linearRingExterior7)

    // MARK: - Polygons

    let polygonWithHole = Polygon<XYZ>(Fixtures.polygonWithHole)
    let polygonWithoutHole = Polygon<XYZ>(Fixtures.polygonWithoutHole)
    let unitPolygon = Polygon<XYZ>(Fixtures.unitPolygon)

    // MARK: - Multi Geometries

    let multiPoint = MultiPoint<XYZ>(Fixtures.multiPoint)
    let multiLineString = MultiLineString<XYZ>(Fixtures.multiLineString)
    let multiPolygon = MultiPolygon<XYZ>(Fixtures.multiPolygon)

    // MARK: - Geometry Collections

    let geometryCollection = GeometryCollection<XYZ>(Fixtures.geometryCollection)
    let recursiveGeometryCollection = GeometryCollection<XYZ>(Fixtures.recursiveGeometryCollection)
    let collection = GeometryCollection<XYZ>(Fixtures.collection)
    let recursiveCollection = GeometryCollection<XYZ>(Fixtures.recursiveCollection)

    // MARK: - Common Aliases

    // Aliases for backward compatibility with existing test code
    var lineString1: LineString<XYZ> { lineStringLength1 }
    var lineString2: LineString<XYZ> { lineStringLength2 }
    var multiLineString1: MultiLineString<XYZ> { multiLineStringLength1 }
    var multiLineString2: MultiLineString<XYZ> { multiLineStringLength3 }
    var linearRing1: Polygon<XYZ>.LinearRing { linearRingLength4 }
    var unitPoly: Polygon<XYZ> { unitPolygon }

    // MARK: - Common Test Arrays

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
        recursiveGeometryCollection,
        Geometry.geometryCollection(geometryCollection)
    ]
}
