public struct Feature: Hashable {
    public var geometry: Geometry?
    public var properties: [String: JSON]?
    public var id: FeatureId?

    public init(geometry: Geometry?, properties: [String: JSON]?, id: FeatureId?) {
        self.geometry = geometry
        self.properties = properties
        self.id = id
    }

    // MARK: - Id

    public enum FeatureId: Hashable {
        case string(String)
        case number(Double)
    }
}
