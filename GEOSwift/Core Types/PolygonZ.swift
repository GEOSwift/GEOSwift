public struct PolygonZ: Hashable {
    public var exterior: LinearRing
    public var holes: [LinearRing]

    public init(exterior: LinearRing, holes: [LinearRing] = []) {
        self.exterior = exterior
        self.holes = holes
    }

    public struct LinearRing: Hashable {
        public let points: [PointZ]

        public init(points: [PointZ]) throws {
            guard points.count >= 4 else {
                throw GEOSwiftError.tooFewPoints
            }
            guard points.first == points.last else {
                throw GEOSwiftError.ringNotClosed
            }
            self.points = points
        }
    }
}
