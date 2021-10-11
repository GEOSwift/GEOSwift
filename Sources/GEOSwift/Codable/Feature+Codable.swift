extension Feature.FeatureId: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let number = try? container.decode(Double.self) {
            self = .number(number)
        } else {
            throw GEOSwiftError.invalidFeatureId
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .string(string):
            try container.encode(string)
        case let .number(number):
            try container.encode(number)
        }
    }
}

extension Feature: Codable {
    enum CodingKeys: CodingKey {
        case type
        case geometry
        case properties
        case id
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try container.geoJSONType(forKey: .type, expectedType: .feature)
        try self.init(
            geometry: container.decode(Geometry?.self, forKey: .geometry),
            properties: container.decode([String: JSON]?.self, forKey: .properties),
            id: container.decodeIfPresent(FeatureId.self, forKey: .id))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(GeoJSONType.feature, forKey: .type)
        try container.encode(geometry, forKey: .geometry)
        try container.encode(properties, forKey: .properties)
        try container.encodeIfPresent(id, forKey: .id)
    }
}
