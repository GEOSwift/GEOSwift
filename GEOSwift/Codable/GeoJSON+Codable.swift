extension GeoJSON: Codable {
    enum CodingKeys: CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        let singleValueContainer = try decoder.singleValueContainer()
        switch try keyedContainer.geoJSONType(forKey: .type) {
        case .featureCollection:
            self = try .featureCollection(singleValueContainer.decode(FeatureCollection.self))
        case .feature:
            self = try .feature(singleValueContainer.decode(Feature.self))
        default:
            self = try .geometry(singleValueContainer.decode(Geometry.self))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .featureCollection(featureCollection):
            try container.encode(featureCollection)
        case let .feature(feature):
            try container.encode(feature)
        case let .geometry(geometry):
            try container.encode(geometry)
        }
    }
}
