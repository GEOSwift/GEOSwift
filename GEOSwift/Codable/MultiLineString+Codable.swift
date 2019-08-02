// for internal use only; GeoJSON encoding & decoding helpers
extension MultiLineString: CodableGeometry {
    static let geoJSONType = GeoJSONType.multiLineString

    var coordinates: [[[Double]]] {
        return lineStrings.map { $0.coordinates }
    }

    init(coordinates: [[[Double]]]) throws {
        try self.init(lineStrings: coordinates.map(LineString.init))
    }
}
