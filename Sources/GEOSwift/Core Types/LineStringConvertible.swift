public protocol LineStringConvertible {
    var lineString: LineString { get }
}

extension LineString: LineStringConvertible {
    public var lineString: LineString {
        self
    }
}

extension Polygon.LinearRing: LineStringConvertible {
    // converts LinearRing to LineString
    public var lineString: LineString {
        LineString(self)
    }
}
