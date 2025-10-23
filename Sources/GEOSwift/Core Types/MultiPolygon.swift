public struct MultiPolygon<C: CoordinateType>: Hashable, Sendable {
    public var polygons: [Polygon<C>]

    public init(polygons: [Polygon<C>]) {
        self.polygons = polygons
    }
}

// MARK: Convenience Methods

public extension MultiPolygon where C == XY {
    init<D: CoordinateType>(_ multiPolygon: MultiPolygon<D>) {
        self.init(polygons: multiPolygon.polygons.map(Polygon<XY>.init))
    }
}

public extension MultiPolygon where C == XYZ {
    init<D: CoordinateType & HasZ>(_ multiPolygon: MultiPolygon<D>) {
        self.init(polygons: multiPolygon.polygons.map(Polygon<XYZ>.init))
    }
}

public extension MultiPolygon where C == XYZM {
    init<D: CoordinateType & HasZ & HasM>(_ multiPolygon: MultiPolygon<D>) {
        self.init(polygons: multiPolygon.polygons.map(Polygon<XYZM>.init))
    }
}

public extension MultiPolygon where C == XYM {
    init<D: CoordinateType & HasM>(_ multiPolygon: MultiPolygon<D>) {
        self.init(polygons: multiPolygon.polygons.map(Polygon<XYM>.init))
    }
}
