// TODO: Decide if multi-coordinate geometries should take `Point`s or coordinates
public struct LineString<C: CoordinateType>: Hashable, Sendable {
    public let points: [Point<C>]

    public var firstPoint: Point<C> {
        points[0]
    }

    public var lastPoint: Point<C> {
        points.last!
    }

    public init(points: [Point<C>]) throws {
        guard points.count >= 2 else {
            throw GEOSwiftError.tooFewPoints
        }
        self.points = points
    }

    public init(_ linearRing: Polygon<C>.LinearRing) {
        // No checks needed because LinearRing's invariants are more strict than LineString's
        self.points = linearRing.points
    }
}

// MARK: - Convenience Methods

public extension LineString where C == XY {
    init<D: CoordinateType>(_ linestring: LineString<D>) {
        // It's safe to force try here since we've already validated the number of points
        try! self.init(points: linestring.points.map(Point<XY>.init))
    }
}

public extension LineString where C == XYZ {
    init<D: CoordinateType & HasZ>(_ linestring: LineString<D>) {
        // It's safe to force try here since we've already validated the number of points
        try! self.init(points: linestring.points.map(Point<XYZ>.init))
    }
}

public extension LineString where C == XYZM {
    init<D: CoordinateType & HasZ & HasM>(_ linestring: LineString<D>) {
        // It's safe to force try here since we've already validated the number of points
        try! self.init(points: linestring.points.map(Point<XYZM>.init))
    }
}

public extension LineString where C == XYM {
    init<D: CoordinateType & HasM>(_ linestring: LineString<D>) {
        // It's safe to force try here since we've already validated the number of points
        try! self.init(points: linestring.points.map(Point<XYM>.init))
    }
}
