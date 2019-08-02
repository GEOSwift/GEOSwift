public struct GeometryCollection: Hashable {
    public var geometries: [Geometry]

    public init(geometries: [GeometryConvertible]) {
        self.geometries = geometries.map { $0.geometry }
    }
}
