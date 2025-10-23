public struct MultiLineString<C: CoordinateType>: Hashable, Sendable {
    public var lineStrings: [LineString<C>]

    public init(lineStrings: [LineString<C>]) {
        self.lineStrings = lineStrings
    }
}

// MARK: Convenience Methods

public extension MultiLineString where C == XY {
    init<D: CoordinateType>(_ multiLineString: MultiLineString<D>) {
        self.init(lineStrings: multiLineString.lineStrings.map(LineString<XY>.init))
    }
}

public extension MultiLineString where C == XYZ {
    init<D: CoordinateType & HasZ>(_ multiLineString: MultiLineString<D>) {
        self.init(lineStrings: multiLineString.lineStrings.map(LineString<XYZ>.init))
    }
}

public extension MultiLineString where C == XYZM {
    init<D: CoordinateType & HasZ & HasM>(_ multiLineString: MultiLineString<D>) {
        self.init(lineStrings: multiLineString.lineStrings.map(LineString<XYZM>.init))
    }
}

public extension MultiLineString where C == XYM {
    init<D: CoordinateType & HasM>(_ multiLineString: MultiLineString<D>) {
        self.init(lineStrings: multiLineString.lineStrings.map(LineString<XYM>.init))
    }
}
