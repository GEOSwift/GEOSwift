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
