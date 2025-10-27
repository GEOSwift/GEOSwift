/// A collection of zero or more ``Geometry`` values.
///
/// The underlying ``CoordinateType`` (e.g. ``XY``, ``XYZ``) determines the dimensionality.
public struct GeometryCollection<C: CoordinateType>: Hashable, Sendable {
    /// The geometries in the `GeometryCollection`
    public var geometries: [Geometry<C>]

    /// Initialize a `GeometryCollection` from the given geometries.
    /// - parameters:
    ///   - geometries: An array of values conforming to ``GeometryConvertible``.
    public init(geometries: [any GeometryConvertible<C>]) {
        self.geometries = geometries.map { $0.geometry }
    }
}

// MARK: Convenience Methods

public extension GeometryCollection where C == XY {
    /// Initialize a `GeometryCollection<XY>` from another `GeometryCollection`.
    /// - parameters:
    ///   - geometryCollection: The geometry collection to copy geometries from.
    init<D: CoordinateType>(_ geometryCollection: GeometryCollection<D>) {
        self.init(geometries: geometryCollection.geometries.map(Geometry<XY>.init))
    }
}

public extension GeometryCollection where C == XYZ {
    /// Initialize a `GeometryCollection<XYZ>` from another `GeometryCollection` with Z coordinates.
    /// - parameters:
    ///   - geometryCollection: The geometry collection to copy geometries from.
    init<D: CoordinateType & HasZ>(_ geometryCollection: GeometryCollection<D>) {
        self.init(geometries: geometryCollection.geometries.map(Geometry<XYZ>.init))
    }
}

public extension GeometryCollection where C == XYZM {
    /// Initialize a `GeometryCollection<XYZM>` from another `GeometryCollection` with Z and M coordinates.
    /// - parameters:
    ///   - geometryCollection: The geometry collection to copy geometries from.
    init<D: CoordinateType & HasZ & HasM>(_ geometryCollection: GeometryCollection<D>) {
        self.init(geometries: geometryCollection.geometries.map(Geometry<XYZM>.init))
    }
}

public extension GeometryCollection where C == XYM {
    /// Initialize a `GeometryCollection<XYM>` from another `GeometryCollection` with M coordinates.
    /// - parameters:
    ///   - geometryCollection: The geometry collection to copy geometries from.
    init<D: CoordinateType & HasM>(_ geometryCollection: GeometryCollection<D>) {
        self.init(geometries: geometryCollection.geometries.map(Geometry<XYM>.init))
    }
}
