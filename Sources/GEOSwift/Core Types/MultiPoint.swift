public struct MultiPoint<C: CoordinateType>: Hashable, Sendable {
    public var points: [Point<C>]

    public init(points: [Point<C>]) {
        self.points = points
    }
}
