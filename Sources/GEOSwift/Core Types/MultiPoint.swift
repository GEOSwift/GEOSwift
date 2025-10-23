public struct MultiPoint<C: CoordinateType>: Hashable, Sendable {
    public var points: [Point<C>]

    public init(points: [Point<C>]) {
        self.points = points
    }
}

// MARK: Convenience Methods

public extension MultiPoint where C == XY {
    init<D: CoordinateType>(_ multiPoint: MultiPoint<D>) {
        self.init(points: multiPoint.points.map(Point<XY>.init))
    }
}

public extension MultiPoint where C == XYZ {
    init<D: CoordinateType & HasZ>(_ multiPoint: MultiPoint<D>) {
        self.init(points: multiPoint.points.map(Point<XYZ>.init))
    }
}

public extension MultiPoint where C == XYZM {
    init<D: CoordinateType & HasZ & HasM>(_ multiPoint: MultiPoint<D>) {
        self.init(points: multiPoint.points.map(Point<XYZM>.init))
    }
}

public extension MultiPoint where C == XYM {
    init<D: CoordinateType & HasM>(_ multiPoint: MultiPoint<D>) {
        self.init(points: multiPoint.points.map(Point<XYM>.init))
    }
}
