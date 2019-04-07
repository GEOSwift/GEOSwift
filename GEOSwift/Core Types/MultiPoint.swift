public struct MultiPoint: Hashable {
    public var points: [Point]

    public init(points: [Point]) {
        self.points = points
    }
}
