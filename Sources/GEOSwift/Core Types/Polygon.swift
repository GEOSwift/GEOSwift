public struct Polygon<C: CoordinateType>: Hashable, Sendable {
    public var exterior: LinearRing
    public var holes: [LinearRing]

    public init(exterior: LinearRing, holes: [LinearRing] = []) {
        self.exterior = exterior
        self.holes = holes
    }

    public struct LinearRing: Hashable, Sendable {
        public let points: [Point<C>]

        public init(points: [Point<C>]) throws {
            guard points.count >= 4 else {
                throw GEOSwiftError.tooFewPoints
            }
            guard LinearRing.ringClosed(points: points) else {
                throw GEOSwiftError.ringNotClosed
            }
            self.points = points
        }

        private static func ringClosed(points: [Point<C>]) -> Bool {
            guard let start = points.first, let end = points.last else {
                return false
            }

            // Only XY coordinates need match for a valid ring closure.
            return Point<XY>(start) == Point<XY>(end)
        }
    }
}

// MARK: - Convenience methods

// swiftlint:disable force_try

public extension Polygon.LinearRing where C == XY {
    init<D: CoordinateType>(_ ring: Polygon<D>.LinearRing) {
        // It is safe to force try here since we've already validated number of points
        try! self.init(points: ring.points.map(Point<XY>.init))
    }
}

public extension Polygon where C == XY {
    init<D: CoordinateType>(_ polygon: Polygon<D>) {
        self.init(
            exterior: Polygon<XY>.LinearRing(polygon.exterior),
            holes: polygon.holes.map(Polygon<XY>.LinearRing.init)
        )
    }
}

public extension Polygon.LinearRing where C == XYZ {
    init<D: CoordinateType & HasZ>(_ ring: Polygon<D>.LinearRing) {
        // It is safe to force try here since we've already validated number of points
        try! self.init(points: ring.points.map(Point<XYZ>.init))
    }
}

public extension Polygon where C == XYZ {
    init<D: CoordinateType & HasZ>(_ polygon: Polygon<D>) {
        self.init(
            exterior: Polygon<XYZ>.LinearRing(polygon.exterior),
            holes: polygon.holes.map(Polygon<XYZ>.LinearRing.init)
        )
    }
}

public extension Polygon.LinearRing where C == XYZM {
    init<D: CoordinateType & HasZ & HasM>(_ ring: Polygon<D>.LinearRing) {
        // It is safe to force try here since we've already validated number of points
        try! self.init(points: ring.points.map(Point<XYZM>.init))
    }
}

public extension Polygon where C == XYZM {
    init<D: CoordinateType & HasZ & HasM>(_ polygon: Polygon<D>) {
        self.init(
            exterior: Polygon<XYZM>.LinearRing(polygon.exterior),
            holes: polygon.holes.map(Polygon<XYZM>.LinearRing.init)
        )
    }
}

public extension Polygon.LinearRing where C == XYM {
    init<D: CoordinateType & HasM>(_ ring: Polygon<D>.LinearRing) {
        // It is safe to force try here since we've already validated number of points
        try! self.init(points: ring.points.map(Point<XYM>.init))
    }
}

public extension Polygon where C == XYM {
    init<D: CoordinateType & HasM>(_ polygon: Polygon<D>) {
        self.init(
            exterior: Polygon<XYM>.LinearRing(polygon.exterior),
            holes: polygon.holes.map(Polygon<XYM>.LinearRing.init)
        )
    }
}

// swiftlint:enable force_try
