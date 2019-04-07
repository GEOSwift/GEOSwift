extension Geometry: Codable {
    enum CodingKeys: CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        let singleValueContainer = try decoder.singleValueContainer()
        switch try keyedContainer.geoJSONType(forKey: .type) {
        case .point:
            self = try singleValueContainer.decode(Point.self).geometry
        case .multiPoint:
            self = try singleValueContainer.decode(MultiPoint.self).geometry
        case .lineString:
            self = try singleValueContainer.decode(LineString.self).geometry
        case .multiLineString:
            self = try singleValueContainer.decode(MultiLineString.self).geometry
        case .polygon:
            self = try singleValueContainer.decode(Polygon.self).geometry
        case .multiPolygon:
            self = try singleValueContainer.decode(MultiPolygon.self).geometry
        case .geometryCollection:
            self = try singleValueContainer.decode(GeometryCollection.self).geometry
        case .feature, .featureCollection:
            throw GEOSwiftError.mismatchedGeoJSONType
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .point(point):
            try container.encode(point)
        case let .multiPoint(multiPoint):
            try container.encode(multiPoint)
        case let .lineString(lineString):
            try container.encode(lineString)
        case let .multiLineString(multiLineString):
            try container.encode(multiLineString)
        case let .polygon(polygon):
            try container.encode(polygon)
        case let .multiPolygon(multiPolygon):
            try container.encode(multiPolygon)
        case let .geometryCollection(geometryCollection):
            try container.encode(geometryCollection)
        }
    }
}
