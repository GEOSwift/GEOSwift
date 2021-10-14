public struct LineStringZ: Hashable {
    public let points: [PointZ]

    public var firstPoint: PointZ {
        points[0]
    }

    public var lastPoint: PointZ {
        points.last!
    }

    public init(points: [PointZ]) throws {
        guard points.count >= 2 else {
            throw GEOSwiftError.tooFewPoints
        }
        self.points = points
    }

    public init(_ linearRing: PolygonZ.LinearRing) {
        // No checks needed because LinearRing's invariants are more strict than LineString's
        self.points = linearRing.points
    }
}
