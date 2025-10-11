public struct GeometryCollection<C: CoordinateType>: Hashable, Sendable {
    public var geometries: [Geometry<C>]

    public init(geometries: [any GeometryConvertible<C>]) {
        self.geometries = geometries.map { $0.geometry }
    }
}
