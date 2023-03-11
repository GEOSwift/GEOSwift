public struct FeatureCollection: Hashable, Sendable {
    public var features: [Feature]

    public init(features: [Feature]) {
        self.features = features
    }
}
