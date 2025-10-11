// for internal use only; GeoJSON encoding & decoding helpers
extension Point: CodableGeometry where C: Codable {
    static var geoJSONType: GeoJSONType { .point }

    public init(coordinates: C) {
        self.coordinates = coordinates
    }
}
