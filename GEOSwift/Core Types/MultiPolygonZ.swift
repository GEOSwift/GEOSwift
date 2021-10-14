public struct MultiPolygonZ: Hashable {
    public var polygons: [PolygonZ]

    public init(polygons: [PolygonZ]) {
        self.polygons = polygons
    }
}
