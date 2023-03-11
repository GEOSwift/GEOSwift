import geos

public struct Circle: Hashable, Sendable {
    public var center: Point
    public var radius: Double

    public init(center: Point, radius: Double) {
        self.center = center
        self.radius = radius
    }
}
