/// A collection of zero or more ``LineString``s.
///
/// The underlying ``CoordinateType`` (e.g. ``XY``, ``XYZ``) determines the dimensionality.
public struct MultiLineString<C: CoordinateType>: Hashable, Sendable {
    /// The linestrings in the `MultiLineString`
    public var lineStrings: [LineString<C>]

    /// Initialize a `MultiLineString` from the given linestrings.
    /// - parameters:
    ///   - lineStrings: An array of linestrings.
    public init(lineStrings: [LineString<C>]) {
        self.lineStrings = lineStrings
    }
}

// MARK: Convenience Methods

public extension MultiLineString where C == XY {
    /// Initialize a `MultiLineString<XY>` from another `MultiLineString`.
    /// - parameters:
    ///   - multiLineString: The multilinestring to copy linestrings from.
    init<D: CoordinateType>(_ multiLineString: MultiLineString<D>) {
        self.init(lineStrings: multiLineString.lineStrings.map(LineString<XY>.init))
    }
}

public extension MultiLineString where C == XYZ {
    /// Initialize a `MultiLineString<XYZ>` from another `MultiLineString` with Z coordinates.
    /// - parameters:
    ///   - multiLineString: The multilinestring to copy linestrings from.
    init<D: CoordinateType & HasZ>(_ multiLineString: MultiLineString<D>) {
        self.init(lineStrings: multiLineString.lineStrings.map(LineString<XYZ>.init))
    }
}

public extension MultiLineString where C == XYZM {
    /// Initialize a `MultiLineString<XYZM>` from another `MultiLineString` with Z and M coordinates.
    /// - parameters:
    ///   - multiLineString: The multilinestring to copy linestrings from.
    init<D: CoordinateType & HasZ & HasM>(_ multiLineString: MultiLineString<D>) {
        self.init(lineStrings: multiLineString.lineStrings.map(LineString<XYZM>.init))
    }
}

public extension MultiLineString where C == XYM {
    /// Initialize a `MultiLineString<XYM>` from another `MultiLineString` with M coordinates.
    /// - parameters:
    ///   - multiLineString: The multilinestring to copy linestrings from.
    init<D: CoordinateType & HasM>(_ multiLineString: MultiLineString<D>) {
        self.init(lineStrings: multiLineString.lineStrings.map(LineString<XYM>.init))
    }
}
