import XCTest
import GEOSwift

/// Central test fixtures defined using XYZM coordinates (the most complete coordinate type).
/// Tests can convert these to other coordinate types as needed using geometry copy constructors:
/// - `Point<XYZ>(Fixtures.point1)` - drops M dimension
/// - `Point<XYM>(Fixtures.point1)` - drops Z dimension
/// - `Point<XY>(Fixtures.point1)` - drops both Z and M dimensions
public struct Fixtures {

    // MARK: - Points

    public static let point1 = Point(XYZM(1, 2, 0, 0))
    public static let point3 = Point(XYZM(3, 4, 1, 1))
    public static let point5 = Point(XYZM(5, 6, 2, 2))
    public static let point7 = Point(XYZM(7, 8, 3, 3))

    // MARK: - LineStrings

    public static let lineString1 = try! LineString(coordinates: [
        point1.coordinates,
        point3.coordinates
    ])

    public static let lineString5 = try! LineString(coordinates: [
        point5.coordinates,
        point7.coordinates
    ])

    // MARK: - Linear Rings

    // counterclockwise
    public static let linearRingExterior2 = try! Polygon.LinearRing(coordinates: [
        XYZM(2, 2, 0, 0),
        XYZM(-2, 2, 0, 0),
        XYZM(-2, -2, 0, 0),
        XYZM(2, -2, 0, 0),
        XYZM(2, 2, 1, 1)
    ])

    // clockwise
    public static let linearRingHole1 = try! Polygon.LinearRing(coordinates: [
        XYZM(1, 1, 0, 0),
        XYZM(1, -1, 0, 0),
        XYZM(-1, -1, 0, 0),
        XYZM(-1, 1, 0, 0),
        XYZM(1, 1, 1, 1)
    ])

    // counterclockwise
    public static let linearRingExterior7 = try! Polygon.LinearRing(coordinates: [
        XYZM(7, 2, 0, 0),
        XYZM(3, 2, 0, 0),
        XYZM(3, -2, 0, 0),
        XYZM(7, -2, 0, 0),
        XYZM(7, 2, 1, 1)
    ])

    // MARK: - Polygons

    public static let polygonWithHole = Polygon(
        exterior: linearRingExterior2,
        holes: [linearRingHole1]
    )

    public static let polygonWithoutHole = Polygon(
        exterior: linearRingExterior7
    )

    // MARK: - Multi Geometries

    public static let multiPoint = MultiPoint(points: [point1, point3])

    public static let multiLineString = MultiLineString(
        lineStrings: [lineString1, lineString5]
    )

    public static let multiPolygon = MultiPolygon(
        polygons: [polygonWithHole, polygonWithoutHole]
    )

    // MARK: - Geometry Collections

    public static let geometryCollection = GeometryCollection(
        geometries: [
            point1,
            multiPoint,
            lineString1,
            multiLineString,
            polygonWithHole,
            multiPolygon
        ]
    )

    public static let recursiveGeometryCollection = GeometryCollection(
        geometries: [geometryCollection]
    )

    // MARK: - Length Test Fixtures

    public static let lineString0 = try! LineString(coordinates: Array(repeating: XYZM(0, 0, 0, 0), count: 2))
    public static let lineStringLength1 = try! LineString(coordinates: [
        XYZM(0, 0, 0, 0),
        XYZM(1, 0, 0, 1)
    ])
    public static let lineStringLength2 = try! LineString(coordinates: [
        XYZM(0, 0, 0, 0),
        XYZM(1, 0, 1, 1),
        XYZM(1, 1, 1, 2)
    ])

    public static let multiLineString0 = MultiLineString<XYZM>(lineStrings: [])
    public static let multiLineStringLength1 = MultiLineString(lineStrings: [lineStringLength1])
    public static let multiLineStringLength3 = MultiLineString(lineStrings: [lineStringLength1, lineStringLength2])

    public static let linearRing0 = try! Polygon.LinearRing(coordinates: Array(repeating: XYZM(0, 0, 0, 0), count: 4))
    public static let linearRingLength4 = try! Polygon.LinearRing(coordinates: [
        XYZM(0, 0, 0, 0),
        XYZM(1, 0, 0, 1),
        XYZM(1, 1, 0, 2),
        XYZM(0, 1, 0, 3),
        XYZM(0, 0, 1, 4)
    ])

    // MARK: - Composite Fixtures

    public static let collection = GeometryCollection(
        geometries: [
            point1,
            multiPoint,
            lineStringLength1,
            multiLineStringLength1,
            polygonWithoutHole,
            multiPolygon
        ]
    )

    public static let recursiveCollection = GeometryCollection(
        geometries: [collection]
    )

    // MARK: - All Geometry Types (for testing all types)

    public static let allGeometryConvertibles: [any GeometryConvertible<XYZM>] = [
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

    // MARK: - Special Test Fixtures

    /// A 1x1 unit polygon for area tests
    public static let unitPolygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
        XYZM(0, 0, 1, 0),
        XYZM(1, 0, 2, 1),
        XYZM(1, 1, 3, 2),
        XYZM(0, 1, 4, 3),
        XYZM(0, 0, 5, 4)
    ]))
}
