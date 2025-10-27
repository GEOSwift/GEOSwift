// for internal use only; GeoJSON encoding & decoding helpers
extension LineString: CodableGeometry, Codable where C: GeoJSONCoordinate {
    static var geoJSONType: GeoJSONType { .lineString }
}
