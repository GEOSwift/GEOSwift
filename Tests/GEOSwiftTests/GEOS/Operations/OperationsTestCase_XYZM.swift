import XCTest
import GEOSwift

/// Base test case for Operations tests using XYZM coordinates.
/// Provides all common fixtures directly from Fixtures (no conversion needed).
class OperationsTestCase_XYZM: XCTestCase {
    // MARK: - Points

    let point1 = Fixtures.point1
    let point3 = Fixtures.point3
    let point5 = Fixtures.point5
    let point7 = Fixtures.point7

    // MARK: - LineStrings

    let lineString5 = Fixtures.lineString5

    // MARK: - Length Test Fixtures

    let lineString0 = Fixtures.lineString0
    let lineStringLength1 = Fixtures.lineStringLength1
    let lineStringLength2 = Fixtures.lineStringLength2

    let multiLineString0 = Fixtures.multiLineString0
    let multiLineStringLength1 = Fixtures.multiLineStringLength1
    let multiLineStringLength3 = Fixtures.multiLineStringLength3

    let linearRing0 = Fixtures.linearRing0
    let linearRingLength4 = Fixtures.linearRingLength4

    // MARK: - Linear Rings

    let linearRingExterior2 = Fixtures.linearRingExterior2
    let linearRingHole1 = Fixtures.linearRingHole1
    let linearRingExterior7 = Fixtures.linearRingExterior7

    // MARK: - Polygons

    let polygonWithHole = Fixtures.polygonWithHole
    let polygonWithoutHole = Fixtures.polygonWithoutHole
    let unitPolygon = Fixtures.unitPolygon

    // MARK: - Multi Geometries

    let multiPoint = Fixtures.multiPoint
    let multiLineString = Fixtures.multiLineString
    let multiPolygon = Fixtures.multiPolygon

    // MARK: - Geometry Collections

    let geometryCollection = Fixtures.geometryCollection
    let recursiveGeometryCollection = Fixtures.recursiveGeometryCollection
    let collection = Fixtures.collection
    let recursiveCollection = Fixtures.recursiveCollection

    // MARK: - Common Aliases

    // Aliases for backward compatibility with existing test code
    var lineString1: LineString<XYZM> { lineStringLength1 }
    var lineString2: LineString<XYZM> { lineStringLength2 }
    var multiLineString1: MultiLineString<XYZM> { multiLineStringLength1 }
    var multiLineString2: MultiLineString<XYZM> { multiLineStringLength3 }
    var linearRing1: Polygon<XYZM>.LinearRing { linearRingLength4 }
    var unitPoly: Polygon<XYZM> { unitPolygon }

    // MARK: - Common Test Arrays

    lazy var geometryConvertibles: [any GeometryConvertible<XYZM>] = [
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
