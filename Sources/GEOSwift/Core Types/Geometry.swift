public enum Geometry<C: CoordinateType>: Hashable, Sendable {
    case point(Point<C>)
    case multiPoint(MultiPoint<C>)
    case lineString(LineString<C>)
    case multiLineString(MultiLineString<C>)
    case polygon(Polygon<C>)
    case multiPolygon(MultiPolygon<C>)
    case geometryCollection(GeometryCollection<C>)
}
