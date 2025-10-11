// for internal use only; GeoJSON encoding & decoding helpers
extension MultiPolygon: CodableGeometry {
    static var geoJSONType: GeoJSONType { .multiPolygon }

    var coordinates: [[[C]]] {
        polygons.map { $0.coordinates }
    }

    init(coordinates: [[[C]]]) throws {
        try self.init(polygons: coordinates.map(Polygon.init))
    }
}
