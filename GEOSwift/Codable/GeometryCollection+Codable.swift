extension GeometryCollection: Codable {
    enum CodingKeys: CodingKey {
        case type
        case geometries
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try container.geoJSONType(forKey: .type, expectedType: .geometryCollection)
        try self.init(geometries: container.decode([Geometry].self, forKey: .geometries))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(GeoJSONType.geometryCollection, forKey: .type)
        try container.encode(geometries, forKey: .geometries)
    }
}
