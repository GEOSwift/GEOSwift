/// A collection of zero or more ``Polygon``s.
///
/// The underlying ``CoordinateType`` (e.g. ``XY``, ``XYZ``) determines the dimensionality.
public struct MultiPolygon<C: CoordinateType>: Hashable, Sendable {
    /// The polygons in the `MultiPolygon`
    public var polygons: [Polygon<C>]

    /// Initialize a `MultiPolygon` from the given polygons.
    /// - parameters:
    ///   - polygons: An array of polygons.
    public init(polygons: [Polygon<C>]) {
        self.polygons = polygons
    }
}

// MARK: Convenience Methods

public extension MultiPolygon where C == XY {
    /// Initialize a `MultiPolygon<XY>` from another `MultiPolygon`.
    /// - parameters:
    ///   - multiPolygon: The multipolygon to copy polygons from.
    init<D: CoordinateType>(_ multiPolygon: MultiPolygon<D>) {
        self.init(polygons: multiPolygon.polygons.map(Polygon<XY>.init))
    }
}

public extension MultiPolygon where C == XYZ {
    /// Initialize a `MultiPolygon<XYZ>` from another `MultiPolygon` with Z coordinates.
    /// - parameters:
    ///   - multiPolygon: The multipolygon to copy polygons from.
    init<D: CoordinateType & HasZ>(_ multiPolygon: MultiPolygon<D>) {
        self.init(polygons: multiPolygon.polygons.map(Polygon<XYZ>.init))
    }
}

public extension MultiPolygon where C == XYZM {
    /// Initialize a `MultiPolygon<XYZM>` from another `MultiPolygon` with Z and M coordinates.
    /// - parameters:
    ///   - multiPolygon: The multipolygon to copy polygons from.
    init<D: CoordinateType & HasZ & HasM>(_ multiPolygon: MultiPolygon<D>) {
        self.init(polygons: multiPolygon.polygons.map(Polygon<XYZM>.init))
    }
}

public extension MultiPolygon where C == XYM {
    /// Initialize a `MultiPolygon<XYM>` from another `MultiPolygon` with M coordinates.
    /// - parameters:
    ///   - multiPolygon: The multipolygon to copy polygons from.
    init<D: CoordinateType & HasM>(_ multiPolygon: MultiPolygon<D>) {
        self.init(polygons: multiPolygon.polygons.map(Polygon<XYM>.init))
    }
}
