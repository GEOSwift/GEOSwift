import XCTest
import GEOSwift

public struct GEOSTestFixtures {
    public static let lineString0 = try! LineString(coordinates: Array(repeating: XY(0, 0), count: 2))
    public static let lineString1 = try! LineString(coordinates: [
        XY(0, 0),
        XY(1, 0)])
    public static let lineString2 = try! LineString(coordinates: [
        XY(0, 0),
        XY(1, 0),
        XY(1, 1)])
    public static let multiLineString0 = MultiLineString<XY>(lineStrings: [])
    public static let multiLineString1 = MultiLineString(lineStrings: [lineString1])
    public static let multiLineString2 = MultiLineString(lineStrings: [lineString1, lineString2])
    public static let linearRing0 = try! Polygon.LinearRing(coordinates: Array(repeating: XY(0, 0), count: 4))
    public static let linearRing1 = try! Polygon.LinearRing(coordinates: [
        XY(0, 0),
        XY(1, 0),
        XY(1, 1),
        XY(0, 1),
        XY(0, 0)])
    public static let collection = GeometryCollection(
        geometries: [
            Point.testValue1,
            MultiPoint.testValue,
            lineString1,
            multiLineString1,
            Polygon.testValueWithoutHole,
            MultiPolygon.testValue])
    public static let recursiveCollection = GeometryCollection(
        geometries: [collection])
    public static let geometryConvertibles: [any GeometryConvertible<XY>] = [
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
    public static let unitPoly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
        XY(0, 0),
        XY(1, 0),
        XY(1, 1),
        XY(0, 1),
        XY(0, 0)]))
}
