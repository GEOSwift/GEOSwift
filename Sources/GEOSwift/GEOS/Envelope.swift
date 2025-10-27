public struct Envelope: Hashable, Sendable {
    public internal(set) var minX: Double
    public internal(set) var maxX: Double
    public internal(set) var minY: Double
    public internal(set) var maxY: Double

    public init(minX: Double, maxX: Double, minY: Double, maxY: Double) {
        precondition(minX <= maxX, "Envelope: minX must not be greater than maxX")
        precondition(minY <= maxY, "Envelope: minY must not be greater than maxY")
        self.minX = minX
        self.maxX = maxX
        self.minY = minY
        self.maxY = maxY
    }

    public var minXMaxY: Point<XY> {
        Point(x: minX, y: maxY)
    }

    public var maxXMaxY: Point<XY> {
        Point(x: maxX, y: maxY)
    }

    public var minXMinY: Point<XY> {
        Point(x: minX, y: minY)
    }

    public var maxXMinY: Point<XY> {
        Point(x: maxX, y: minY)
    }
}

extension Envelope: GeometryConvertible {
    public var geometry: Geometry<XY> {
        if minX == maxX, minY == maxY {
            return .point(Point(x: minX, y: minY))
        } else {
            // swiftlint:disable:next force_try
            return try! .polygon(Polygon(exterior: Polygon.LinearRing(
                coordinates: [
                    XY(minX, minY),
                    XY(maxX, minY),
                    XY(maxX, maxY),
                    XY(minX, maxY),
                    XY(minX, minY)
                ])))
        }
    }
}
