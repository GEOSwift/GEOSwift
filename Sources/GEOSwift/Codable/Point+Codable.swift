// for internal use only; GeoJSON encoding & decoding helpers
extension Point: CodableGeometry, Codable where C: GeoJSONCoordinate {
    static var geoJSONType: GeoJSONType { .point }

    public init(coordinates: C) {
        self.coordinates = coordinates
    }
}
