public struct GeometryCollection: Hashable, Sendable {
    public var geometries: [Geometry]

    public init(geometries: [GeometryConvertible]) {
        self.geometries = geometries.map { $0.geometry }
    }
}
