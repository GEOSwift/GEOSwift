// for internal use only; GeoJSON encoding & decoding helpers
extension MultiPoint: CodableGeometry, Codable where C: GeoJSONCoordinate {
    static var geoJSONType: GeoJSONType { .multiPoint }

    var coordinates: [C] {
        points.map { $0.coordinates }
    }
}
