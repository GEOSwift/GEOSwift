public struct LineString<C: CoordinateType>: Hashable, Sendable {
    public let coordinates: [C]

    public var firstCoordinate: C {
        coordinates[0]
    }

    public var lastCoordinate: C {
        coordinates.last!
    }

    public init(coordinates: [C]) throws {
        guard coordinates.count >= 2 else {
            throw GEOSwiftError.tooFewCoordinates
        }
        
        self.coordinates = coordinates
    }

    public init(_ linearRing: Polygon<C>.LinearRing) {
        // No checks needed because LinearRing's invariants are more strict than LineString's
        self.coordinates = linearRing.coordinates
    }
}

// MARK: - Convenience Methods

/// Convenience initialization from ``Point``s.
public extension LineString {
    init(points: [Point<C>]) throws {
        try self.init(coordinates: points.map(\.coordinates))
    }
}

// swiftlint:disable force_try

public extension LineString where C == XY {
    init<D: CoordinateType>(_ linestring: LineString<D>) {
        // It's safe to force try here since we've already validated the number of points
        try! self.init(coordinates: linestring.coordinates.map(XY.init))
    }
}

public extension LineString where C == XYZ {
    init<D: CoordinateType & HasZ>(_ linestring: LineString<D>) {
        // It's safe to force try here since we've already validated the number of points
        try! self.init(coordinates: linestring.coordinates.map(XYZ.init))
    }
}

public extension LineString where C == XYZM {
    init<D: CoordinateType & HasZ & HasM>(_ linestring: LineString<D>) {
        // It's safe to force try here since we've already validated the number of points
        try! self.init(coordinates: linestring.coordinates.map(XYZM.init))
    }
}

public extension LineString where C == XYM {
    init<D: CoordinateType & HasM>(_ linestring: LineString<D>) {
        // It's safe to force try here since we've already validated the number of points
        try! self.init(coordinates: linestring.coordinates.map(XYM.init))
    }
}

// swiftlint:enable force_try
