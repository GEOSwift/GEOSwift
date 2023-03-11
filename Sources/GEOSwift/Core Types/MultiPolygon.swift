public struct MultiPolygon: Hashable, Sendable {
    public var polygons: [Polygon]

    public init(polygons: [Polygon]) {
        self.polygons = polygons
    }
}
