import geos

/// A geometric circle defined by a center point and radius.
///
/// - Note: The radius is always measured in the same units as the coordinate system.
public struct Circle<C: CoordinateType>: Hashable, Sendable {
    /// The center point of the circle.
    public var center: Point<C>

    /// The radius of the circle, measured in the same units as the coordinate system.
    public var radius: Double

    /// Creates a new circle with the specified center point and radius.
    ///
    /// - Parameters:
    ///   - center: The center point of the circle.
    ///   - radius: The radius of the circle.
    public init(center: Point<C>, radius: Double) {
        self.center = center
        self.radius = radius
    }
}
