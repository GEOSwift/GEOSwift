import geos

public struct Circle<C: CoordinateType>: Hashable, Sendable {
    public var center: Point<C>
    public var radius: Double

    public init(center: Point<C>, radius: Double) {
        self.center = center
        self.radius = radius
    }
}
