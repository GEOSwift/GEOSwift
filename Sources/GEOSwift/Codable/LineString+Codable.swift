// for internal use only; GeoJSON encoding & decoding helpers
extension LineString: CodableGeometry, Codable where C: GeoJSONCoordinate {
    static var geoJSONType: GeoJSONType { .lineString }

    var coordinates: [C] {
        points.map { $0.coordinates }
    }

    init(coordinates: [C]) throws {
        try self.init(points: coordinates.map(Point.init(_:)))
    }
}
