public struct MultiPolygon<C: CoordinateType>: Hashable, Sendable {
    public var polygons: [Polygon<C>]

    public init(polygons: [Polygon<C>]) {
        self.polygons = polygons
    }
}
