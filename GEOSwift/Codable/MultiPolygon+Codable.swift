// for internal use only; GeoJSON encoding & decoding helpers
extension MultiPolygon: CodableGeometry {
    static let geoJSONType = GeoJSONType.multiPolygon

    var coordinates: [[[[Double]]]] {
        return polygons.map { $0.coordinates }
    }

    init(coordinates: [[[[Double]]]]) throws {
        try self.init(polygons: coordinates.map(Polygon.init))
    }
}
