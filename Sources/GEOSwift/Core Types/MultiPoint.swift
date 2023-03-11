public struct MultiPoint: Hashable, Sendable {
    public var points: [Point]

    public init(points: [Point]) {
        self.points = points
    }
}
