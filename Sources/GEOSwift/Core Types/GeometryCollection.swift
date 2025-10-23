public struct GeometryCollection<C: CoordinateType>: Hashable, Sendable {
    public var geometries: [Geometry<C>]

    public init(geometries: [any GeometryConvertible<C>]) {
        self.geometries = geometries.map { $0.geometry }
    }
}

// MARK: Convenience Methods

public extension GeometryCollection where C == XY {
    init<D: CoordinateType>(_ geometryCollection: GeometryCollection<D>) {
        self.init(geometries: geometryCollection.geometries.map(Geometry<XY>.init))
    }
}

public extension GeometryCollection where C == XYZ {
    init<D: CoordinateType & HasZ>(_ geometryCollection: GeometryCollection<D>) {
        self.init(geometries: geometryCollection.geometries.map(Geometry<XYZ>.init))
    }
}

public extension GeometryCollection where C == XYZM {
    init<D: CoordinateType & HasZ & HasM>(_ geometryCollection: GeometryCollection<D>) {
        self.init(geometries: geometryCollection.geometries.map(Geometry<XYZM>.init))
    }
}

public extension GeometryCollection where C == XYM {
    init<D: CoordinateType & HasM>(_ geometryCollection: GeometryCollection<D>) {
        self.init(geometries: geometryCollection.geometries.map(Geometry<XYM>.init))
    }
}
