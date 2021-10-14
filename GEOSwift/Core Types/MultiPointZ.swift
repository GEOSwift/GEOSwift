public struct MultiPointZ: Hashable {
    public var points: [PointZ]

    public init(points: [PointZ]) {
        self.points = points
    }
}
