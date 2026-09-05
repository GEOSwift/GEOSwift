/// A collection of zero or more ``Point``s.
///
/// The underlying ``CoordinateType`` (e.g. ``XY``, ``XYZ``) determines the dimensionality.
public struct MultiPoint<C: CoordinateType>: Hashable, Sendable {
    /// The points in the `MultiPoint`
    public var points: [Point<C>]

    /// Initialize a `MultiPoint` from the given points.
    /// - parameters:
    ///   - points: An array of points.
    public init(points: [Point<C>]) {
        self.points = points
    }

    /// Initialize a `MultiPoint` from the given coordinates.
    /// - parameters:
    ///   - coordinates: An array of coordinates.
    public init(coordinates: [C]) {
        self.init(points: coordinates.map(Point.init))
    }
}

// MARK: Convenience Methods

public extension MultiPoint where C == XY {
    /// Initialize a `MultiPoint<XY>` from a sequence of (x, y) values.
    /// - parameters:
    ///   - coordinates: A sequence of (x, y) values.
    init<S: Sequence>(coordinates: S) where S.Element == (Double, Double) {
        self.init(coordinates: coordinates.map(XY.init))
    }

    /// Initialize a `MultiPoint<XY>` from another `MultiPoint`.
    /// - parameters:
    ///   - multiPoint: The multipoint to copy points from.
    init<D: CoordinateType>(_ multiPoint: MultiPoint<D>) {
        self.init(points: multiPoint.points.map(Point<XY>.init))
    }
}

public extension MultiPoint where C == XYZ {
    /// Initialize a `MultiPoint<XYZ>` from a sequence of (x, y, z) values.
    /// - parameters:
    ///   - coordinates: A sequence of (x, y, z) values.
    init<S: Sequence>(coordinates: S) where S.Element == (Double, Double, Double) {
        self.init(coordinates: coordinates.map(XYZ.init))
    }

    /// Initialize a `MultiPoint<XYZ>` from another `MultiPoint` with Z coordinates.
    /// - parameters:
    ///   - multiPoint: The multipoint to copy points from.
    init<D: CoordinateType & HasZ>(_ multiPoint: MultiPoint<D>) {
        self.init(points: multiPoint.points.map(Point<XYZ>.init))
    }
}

public extension MultiPoint where C == XYZM {
    /// Initialize a `MultiPoint<XYZM>` from a sequence of (x, y, z, m) values.
    /// - parameters:
    ///   - coordinates: A sequence of (x, y, z, m) values.
    init<S: Sequence>(coordinates: S) where S.Element == (Double, Double, Double, Double) {
        self.init(coordinates: coordinates.map(XYZM.init))
    }

    /// Initialize a `MultiPoint<XYZM>` from another `MultiPoint` with Z and M coordinates.
    /// - parameters:
    ///   - multiPoint: The multipoint to copy points from.
    init<D: CoordinateType & HasZ & HasM>(_ multiPoint: MultiPoint<D>) {
        self.init(points: multiPoint.points.map(Point<XYZM>.init))
    }
}

public extension MultiPoint where C == XYM {
    /// Initialize a `MultiPoint<XYM>` from another `MultiPoint` with M coordinates.
    /// - parameters:
    ///   - multiPoint: The multipoint to copy points from.
    init<D: CoordinateType & HasM>(_ multiPoint: MultiPoint<D>) {
        self.init(points: multiPoint.points.map(Point<XYM>.init))
    }
}
