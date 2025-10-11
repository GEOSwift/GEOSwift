public struct FeatureCollection<C: CoordinateType>: Hashable, Sendable {
    public var features: [Feature<C>]

    public init(features: [Feature<C>]) {
        self.features = features
    }
}
