// for internal use only; GeoJSON encoding & decoding helpers
extension MultiLineString: CodableGeometry {
    static var geoJSONType: GeoJSONType { .multiLineString }

    var coordinates: [[C]] {
        lineStrings.map { $0.coordinates }
    }

    init(coordinates: [[C]]) throws {
        try self.init(lineStrings: coordinates.map(LineString.init))
    }
}
