public enum Geometry: Hashable {
    case point(Point)
    case multiPoint(MultiPoint)
    case lineString(LineString)
    case multiLineString(MultiLineString)
    case polygon(Polygon)
    case multiPolygon(MultiPolygon)
    case geometryCollection(GeometryCollection)
}
