public struct FeatureCollection: Hashable {
    public var features: [Feature]

    public init(features: [Feature]) {
        self.features = features
    }
}
