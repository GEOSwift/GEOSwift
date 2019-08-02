public protocol LineStringConvertible {
    var lineString: LineString { get }
}

extension LineString: LineStringConvertible {
    public var lineString: LineString {
        return self
    }
}

extension Polygon.LinearRing: LineStringConvertible {
    // converts LinearRing to LineString
    public var lineString: LineString {
        return LineString(self)
    }
}
