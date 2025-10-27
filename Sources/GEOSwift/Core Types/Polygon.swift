public struct Polygon<C: CoordinateType>: Hashable, Sendable {
    public var exterior: LinearRing
    public var holes: [LinearRing]

    public init(exterior: LinearRing, holes: [LinearRing] = []) {
        self.exterior = exterior
        self.holes = holes
    }

    public struct LinearRing: Hashable, Sendable {
        public let coordinates: [C]

        public init(coordinates: [C]) throws {
            guard coordinates.count >= 4 else {
                throw GEOSwiftError.tooFewPoints
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
    init(points: [Point<C>]) throws {
        try self.init(coordinates: points.map(\.coordinates))
    }
}

// swiftlint:disable force_try

public extension Polygon.LinearRing where C == XY {
    init<D: CoordinateType>(_ ring: Polygon<D>.LinearRing) {
        // It is safe to force try here since we've already validated number of points
        try! self.init(coordinates: ring.coordinates.map(XY.init))
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
        try! self.init(coordinates: ring.coordinates.map(XYZ.init))
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
        try! self.init(coordinates: ring.coordinates.map(XYZM.init))
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
        try! self.init(coordinates: ring.coordinates.map(XYM.init))
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
