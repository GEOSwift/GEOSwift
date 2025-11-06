/// A rectangular bounding box defined by minimum and maximum X and Y coordinates.
///
/// An envelope represents the minimum bounding rectangle that contains a geometry.
public struct Envelope: Hashable, Sendable {
    /// The minimum X coordinate of the envelope.
    public internal(set) var minX: Double

    /// The maximum X coordinate of the envelope.
    public internal(set) var maxX: Double

    /// The minimum Y coordinate of the envelope.
    public internal(set) var minY: Double

    /// The maximum Y coordinate of the envelope.
    public internal(set) var maxY: Double

    /// Creates a new envelope with the specified bounds.
    ///
    /// - Parameters:
    ///   - minX: The minimum X coordinate.
    ///   - maxX: The maximum X coordinate.
    ///   - minY: The minimum Y coordinate.
    ///   - maxY: The maximum Y coordinate.
    ///
    /// - Precondition: `minX` must be less than or equal to `maxX`.
    /// - Precondition: `minY` must be less than or equal to `maxY`.
    public init(minX: Double, maxX: Double, minY: Double, maxY: Double) {
        precondition(minX <= maxX, "Envelope: minX must not be greater than maxX")
        precondition(minY <= maxY, "Envelope: minY must not be greater than maxY")
        self.minX = minX
        self.maxX = maxX
        self.minY = minY
        self.maxY = maxY
    }

    /// The top-left corner point (minX, maxY).
    public var minXMaxY: Point<XY> {
        Point(x: minX, y: maxY)
    }

    /// The top-right corner point (maxX, maxY).
    public var maxXMaxY: Point<XY> {
        Point(x: maxX, y: maxY)
    }

    /// The bottom-left corner point (minX, minY).
    public var minXMinY: Point<XY> {
        Point(x: minX, y: minY)
    }

    /// The bottom-right corner point (maxX, minY).
    public var maxXMinY: Point<XY> {
        Point(x: maxX, y: minY)
    }
}

extension Envelope: GeometryConvertible {
    /// Converts the envelope to a ``Geometry``.
    ///
    /// Returns a ``Point`` if the envelope represents a single point, or a ``Polygon``
    /// representing the rectangular bounding box otherwise.
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
