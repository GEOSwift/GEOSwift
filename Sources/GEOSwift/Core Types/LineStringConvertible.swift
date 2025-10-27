/// Types that can be converted to a ``LineString`` (e.g. `Polygon.LinearRing`)
public protocol LineStringConvertible<C> {
    associatedtype C: CoordinateType

    /// The equivalent ``LineString`` for the type.
    var lineString: LineString<C> { get }
}

extension LineString: LineStringConvertible {
    public var lineString: LineString {
        self
    }
}

extension Polygon.LinearRing: LineStringConvertible {
    // converts LinearRing to LineString
    public var lineString: LineString<C> {
        LineString(self)
    }
}
