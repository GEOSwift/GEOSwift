/// A linestring geometry consisting of two or more coordinates.
///
/// The underlying ``CoordinateType`` (e.g. ``XY``, ``XYZ``) determines the dimensionality.
public struct LineString<C: CoordinateType>: Hashable, Sendable {
    /// The coordinates that make up the `LineString`
    public let coordinates: [C]

    /// The first coordinate of the `LineString`
    public var firstCoordinate: C {
        coordinates[0]
    }

    /// The last coordinate of the `LineString`
    public var lastCoordinate: C {
        coordinates.last!
    }

    /// Initialize a `LineString` from the given coordinates.
    /// - parameters:
    ///   - coordinates: An array of coordinates. Must contain at least 2 coordinates.
    /// - throws: ``GEOSwiftError/tooFewCoordinates`` if fewer than 2 coordinates are provided.
    public init(coordinates: [C]) throws {
        guard coordinates.count >= 2 else {
            throw GEOSwiftError.tooFewCoordinates
        }

        self.coordinates = coordinates
    }

    /// Initialize a `LineString` from a ``Polygon/LinearRing``.
    /// - parameters:
    ///   - linearRing: The linear ring to convert to a linestring.
    public init(_ linearRing: Polygon<C>.LinearRing) {
        // No checks needed because LinearRing's invariants are more strict than LineString's
        self.coordinates = linearRing.coordinates
    }
}

// MARK: - Convenience Methods

/// Convenience initialization from ``Point``s.
public extension LineString {
    /// Initialize a `LineString` from an array of ``Point``s.
    /// - parameters:
    ///   - points: An array of points. Must contain at least 2 points.
    /// - throws: ``GEOSwiftError/tooFewCoordinates`` if fewer than 2 points are provided.
    init(points: [Point<C>]) throws {
        try self.init(coordinates: points.map(\.coordinates))
    }
}

// swiftlint:disable force_try

public extension LineString where C == XY {
    /// Initialize a `LineString<XY>` from any ``LineStringConvertible``.
    /// - parameters:
    ///   - linestring: The linestring to copy coordinates from.
    init<D: CoordinateType>(_ linestring: any LineStringConvertible<D>) {
        // It's safe to force try here since we've already validated the number of points
        try! self.init(coordinates: linestring.lineString.coordinates.map(XY.init))
    }
}

public extension LineString where C == XYZ {
    /// Initialize a `LineString<XYZ>` from any ``LineStringConvertible`` with Z coordinates.
    /// - parameters:
    ///   - linestring: The linestring to copy coordinates from.
    init<D: CoordinateType & HasZ>(_ linestring: any LineStringConvertible<D>) {
        // It's safe to force try here since we've already validated the number of points
        try! self.init(coordinates: linestring.lineString.coordinates.map(XYZ.init))
    }
}

public extension LineString where C == XYZM {
    /// Initialize a `LineString<XYZM>` from any ``LineStringConvertible`` with Z and M coordinates.
    /// - parameters:
    ///   - linestring: The linestring to copy coordinates from.
    init<D: CoordinateType & HasZ & HasM>(_ linestring: any LineStringConvertible<D>) {
        // It's safe to force try here since we've already validated the number of points
        try! self.init(coordinates: linestring.lineString.coordinates.map(XYZM.init))
    }
}

public extension LineString where C == XYM {
    /// Initialize a `LineString<XYM>` from any ``LineStringConvertible`` with M coordinates.
    /// - parameters:
    ///   - linestring: The linestring to copy coordinates from.
    init<D: CoordinateType & HasM>(_ linestring: any LineStringConvertible<D>) {
        // It's safe to force try here since we've already validated the number of points
        try! self.init(coordinates: linestring.lineString.coordinates.map(XYM.init))
    }
}

// swiftlint:enable force_try
