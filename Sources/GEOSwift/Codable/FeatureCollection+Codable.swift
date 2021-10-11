extension FeatureCollection: Codable {
    enum CodingKeys: CodingKey {
        case type
        case features
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try container.geoJSONType(forKey: .type, expectedType: .featureCollection)
        try self.init(features: container.decode([Feature].self, forKey: .features))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(GeoJSONType.featureCollection, forKey: .type)
        try container.encode(features, forKey: .features)
    }
}
