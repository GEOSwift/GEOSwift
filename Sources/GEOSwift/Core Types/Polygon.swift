/// A polygon geometry consisting of an exterior ring and optional interior rings (holes).
///
/// The underlying ``CoordinateType`` (e.g. ``XY``, ``XYZ``) determines the dimensionality.
public struct Polygon<C: CoordinateType>: Hashable, Sendable {
    /// The exterior boundary of the `Polygon`
    public var exterior: LinearRing

    /// The interior holes of the `Polygon`
    public var holes: [LinearRing]

    /// Initialize a `Polygon` from the given exterior ring and optional holes.
    /// - parameters:
    ///   - exterior: The exterior boundary ring.
    ///   - holes: An array of interior holes. Defaults to an empty array.
    public init(exterior: LinearRing, holes: [LinearRing] = []) {
        self.exterior = exterior
        self.holes = holes
    }

    /// A closed linear ring consisting of at least 4 coordinates where the first and last coordinates are equal.
    ///
    /// Linear rings are used to define the boundaries of polygons.
    public struct LinearRing: Hashable, Sendable {
        /// The coordinates that make up the `LinearRing`
        public let coordinates: [C]

        /// Initialize a `LinearRing` from the given coordinates.
        /// - parameters:
        ///   - coordinates: An array of coordinates. Must contain at least 4 coordinates and the first
        ///                  and last must be equal.
        /// - throws: ``GEOSwiftError/tooFewCoordinates`` if fewer than 4 coordinates are provided, or
        ///           ``GEOSwiftError/ringNotClosed`` if the first and last ``XY`` coordinates are not equal.
        public init(coordinates: [C]) throws {
            guard coordinates.count >= 4 else {
                throw GEOSwiftError.tooFewCoordinates
            }

            guard LinearRing.ringClosed(coordinates: coordinates) else {
                throw GEOSwiftError.ringNotClosed
            }

            self.coordinates = coordinates
        }

        private static func ringClosed(coordinates: [C]) -> Bool {
            guard let start = coordinates.first, let end = coordinates.last else {
                return false
            }

            // Only XY coordinates need match for a valid ring closure.
            return XY(start) == XY(end)
        }
    }
}

// MARK: - Convenience methods

/// Convenience initialization from ``Point``s.
public extension Polygon.LinearRing {
    /// Initialize a `LinearRing` from an array of ``Point``s.
    /// - parameters:
    ///   - points: An array of points. Must contain at least 4 points and the first and last must be equal.
    /// - throws: ``GEOSwiftError/tooFewCoordinates`` if fewer than 4 points are provided, or
    ///           ``GEOSwiftError/ringNotClosed`` if the first and last points' ``XY`` coordinates are not equal.
    init(points: [Point<C>]) throws {
        try self.init(coordinates: points.map(\.coordinates))
    }
}

// swiftlint:disable force_try

public extension Polygon.LinearRing where C == XY {
    /// Initialize a `LinearRing<XY>` from another `LinearRing`.
    /// - parameters:
    ///   - ring: The linear ring to copy coordinates from.
    init<D: CoordinateType>(_ ring: Polygon<D>.LinearRing) {
        // It is safe to force try here since we've already validated number of points
        try! self.init(coordinates: ring.coordinates.map(XY.init))
    }

    /// Initialize a `LinearRing<XY>` from a sequence of (x, y) values.
    /// - parameters:
    ///   - coordinates: A sequence of (x, y) values. Must contain at least 4 coordinates and the first
    ///                  and last must be equal.
    /// - throws: ``GEOSwiftError/tooFewCoordinates`` if fewer than 4 coordinates are provided, or
    ///           ``GEOSwiftError/ringNotClosed`` if the first and last coordinates are not equal.
    init<S: Sequence>(coordinates: S) throws where S.Element == (Double, Double) {
        try self.init(coordinates: coordinates.map(XY.init))
    }
}

public extension Polygon where C == XY {
    /// Initialize a `Polygon<XY>` from another `Polygon`.
    /// - parameters:
    ///   - polygon: The polygon to copy from.
    init<D: CoordinateType>(_ polygon: Polygon<D>) {
        self.init(
            exterior: Polygon<XY>.LinearRing(polygon.exterior),
            holes: polygon.holes.map(Polygon<XY>.LinearRing.init)
        )
    }

    /// Initialize a `Polygon<XY>` from an exterior ring and holes specified as sequences of (x, y) values.
    /// - parameters:
    ///   - exterior: A sequence of (x, y) values defining the exterior ring.
    ///   - holes: A sequence of sequences, each defining an interior hole.
    /// - throws: ``GEOSwiftError/tooFewCoordinates`` if any ring has fewer than 4 coordinates, or
    ///           ``GEOSwiftError/ringNotClosed`` if any ring is not closed.
    init<S: Sequence>(exterior: S, holes: any Sequence<S>) throws where S.Element == (Double, Double) {
        try self.init(exterior: LinearRing(coordinates: exterior), holes: holes.map(LinearRing.init))
    }

    /// Initialize a `Polygon<XY>` from a sequence of rings specified as sequences of (x, y) values.
    /// - parameters:
    ///   - coordinates: A sequence of sequences where the first is the exterior ring and the rest are holes.
    /// - throws: ``GEOSwiftError/tooFewRings`` if no rings are provided,
    ///           ``GEOSwiftError/tooFewCoordinates`` if any ring has fewer than 4 coordinates, or
    ///           ``GEOSwiftError/ringNotClosed`` if any ring is not closed.
    init<S: Sequence>(coordinates: any Sequence<S>) throws where S.Element == (Double, Double) {
        let coordinatesArray = Array(coordinates)
        guard let exterior = coordinatesArray.first else {
            throw GEOSwiftError.tooFewRings
        }

        try self.init(exterior: exterior, holes: coordinatesArray.dropFirst())
    }
}

public extension Polygon.LinearRing where C == XYZ {
    /// Initialize a `LinearRing<XYZ>` from another `LinearRing` with Z coordinates.
    /// - parameters:
    ///   - ring: The linear ring to copy coordinates from.
    init<D: CoordinateType & HasZ>(_ ring: Polygon<D>.LinearRing) {
        // It is safe to force try here since we've already validated number of points
        try! self.init(coordinates: ring.coordinates.map(XYZ.init))
    }

    /// Initialize a `LinearRing<XYZ>` from a sequence of (x, y, z) values.
    /// - parameters:
    ///   - coordinates: A sequence of (x, y, z) values. Must contain at least 4 coordinates and the first
    ///                  and last must be equal.
    /// - throws: ``GEOSwiftError/tooFewCoordinates`` if fewer than 4 coordinates are provided, or
    ///           ``GEOSwiftError/ringNotClosed`` if the first and last coordinates are not equal.
    init<S: Sequence>(coordinates: S) throws where S.Element == (Double, Double, Double) {
        try self.init(coordinates: coordinates.map(XYZ.init))
    }
}

public extension Polygon where C == XYZ {
    /// Initialize a `Polygon<XYZ>` from another `Polygon` with Z coordinates.
    /// - parameters:
    ///   - polygon: The polygon to copy from.
    init<D: CoordinateType & HasZ>(_ polygon: Polygon<D>) {
        self.init(
            exterior: Polygon<XYZ>.LinearRing(polygon.exterior),
            holes: polygon.holes.map(Polygon<XYZ>.LinearRing.init)
        )
    }

    /// Initialize a `Polygon<XYZ>` from an exterior ring and holes specified as sequences of (x, y, z) values.
    /// - parameters:
    ///   - exterior: A sequence of (x, y, z) values defining the exterior ring.
    ///   - holes: A sequence of sequences, each defining an interior hole.
    /// - throws: ``GEOSwiftError/tooFewCoordinates`` if any ring has fewer than 4 coordinates, or
    ///           ``GEOSwiftError/ringNotClosed`` if any ring is not closed.
    init<S: Sequence>(exterior: S, holes: any Sequence<S>) throws where S.Element == (Double, Double, Double) {
        try self.init(exterior: LinearRing(coordinates: exterior), holes: holes.map(LinearRing.init))
    }

    /// Initialize a `Polygon<XYZ>` from a sequence of rings specified as sequences of (x, y, z) values.
    /// - parameters:
    ///   - coordinates: A sequence of sequences where the first is the exterior ring and the rest are holes.
    /// - throws: ``GEOSwiftError/tooFewRings`` if no rings are provided,
    ///           ``GEOSwiftError/tooFewCoordinates`` if any ring has fewer than 4 coordinates, or
    ///           ``GEOSwiftError/ringNotClosed`` if any ring is not closed.
    init<S: Sequence>(coordinates: any Sequence<S>) throws where S.Element == (Double, Double, Double) {
        let coordinatesArray = Array(coordinates)
        guard let exterior = coordinatesArray.first else {
            throw GEOSwiftError.tooFewRings
        }

        try self.init(exterior: exterior, holes: coordinatesArray.dropFirst())
    }
}

public extension Polygon.LinearRing where C == XYZM {
    /// Initialize a `LinearRing<XYZM>` from another `LinearRing` with Z and M coordinates.
    /// - parameters:
    ///   - ring: The linear ring to copy coordinates from.
    init<D: CoordinateType & HasZ & HasM>(_ ring: Polygon<D>.LinearRing) {
        // It is safe to force try here since we've already validated number of points
        try! self.init(coordinates: ring.coordinates.map(XYZM.init))
    }

    /// Initialize a `LinearRing<XYZM>` from a sequence of (x, y, z, m) values.
    /// - parameters:
    ///   - coordinates: A sequence of (x, y, z, m) values. Must contain at least 4 coordinates and the first
    ///                  and last must be equal.
    /// - throws: ``GEOSwiftError/tooFewCoordinates`` if fewer than 4 coordinates are provided, or
    ///           ``GEOSwiftError/ringNotClosed`` if the first and last coordinates are not equal.
    init<S: Sequence>(coordinates: S) throws where S.Element == (Double, Double, Double, Double) {
        try self.init(coordinates: coordinates.map(XYZM.init))
    }
}

public extension Polygon where C == XYZM {
    /// Initialize a `Polygon<XYZM>` from another `Polygon` with Z and M coordinates.
    /// - parameters:
    ///   - polygon: The polygon to copy from.
    init<D: CoordinateType & HasZ & HasM>(_ polygon: Polygon<D>) {
        self.init(
            exterior: Polygon<XYZM>.LinearRing(polygon.exterior),
            holes: polygon.holes.map(Polygon<XYZM>.LinearRing.init)
        )
    }

    /// Initialize a `Polygon<XYZM>` from an exterior ring and holes specified as sequences of (x, y, z, m) values.
    /// - parameters:
    ///   - exterior: A sequence of (x, y, z, m) values defining the exterior ring.
    ///   - holes: A sequence of sequences, each defining an interior hole.
    /// - throws: ``GEOSwiftError/tooFewCoordinates`` if any ring has fewer than 4 coordinates, or
    ///           ``GEOSwiftError/ringNotClosed`` if any ring is not closed.
    init<S: Sequence>(exterior: S, holes: any Sequence<S>) throws where S.Element == (Double, Double, Double, Double) {
        try self.init(exterior: LinearRing(coordinates: exterior), holes: holes.map(LinearRing.init))
    }

    /// Initialize a `Polygon<XYZM>` from a sequence of rings specified as sequences of (x, y, z, m) values.
    /// - parameters:
    ///   - coordinates: A sequence of sequences where the first is the exterior ring and the rest are holes.
    /// - throws: ``GEOSwiftError/tooFewRings`` if no rings are provided,
    ///           ``GEOSwiftError/tooFewCoordinates`` if any ring has fewer than 4 coordinates, or
    ///           ``GEOSwiftError/ringNotClosed`` if any ring is not closed.
    init<S: Sequence>(coordinates: any Sequence<S>) throws where S.Element == (Double, Double, Double, Double) {
        let coordinatesArray = Array(coordinates)
        guard let exterior = coordinatesArray.first else {
            throw GEOSwiftError.tooFewRings
        }

        try self.init(exterior: exterior, holes: coordinatesArray.dropFirst())
    }
}

public extension Polygon.LinearRing where C == XYM {
    /// Initialize a `LinearRing<XYM>` from another `LinearRing` with M coordinates.
    /// - parameters:
    ///   - ring: The linear ring to copy coordinates from.
    init<D: CoordinateType & HasM>(_ ring: Polygon<D>.LinearRing) {
        // It is safe to force try here since we've already validated number of points
        try! self.init(coordinates: ring.coordinates.map(XYM.init))
    }
}

public extension Polygon where C == XYM {
    /// Initialize a `Polygon<XYM>` from another `Polygon` with M coordinates.
    /// - parameters:
    ///   - polygon: The polygon to copy from.
    init<D: CoordinateType & HasM>(_ polygon: Polygon<D>) {
        self.init(
            exterior: Polygon<XYM>.LinearRing(polygon.exterior),
            holes: polygon.holes.map(Polygon<XYM>.LinearRing.init)
        )
    }
}

// swiftlint:enable force_try
