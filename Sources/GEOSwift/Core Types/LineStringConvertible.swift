public protocol LineStringConvertible<C> {
    associatedtype C: CoordinateType
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
