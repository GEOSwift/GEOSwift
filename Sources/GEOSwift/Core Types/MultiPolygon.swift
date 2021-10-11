public struct MultiPolygon: Hashable {
    public var polygons: [Polygon]

    public init(polygons: [Polygon]) {
        self.polygons = polygons
    }
}
