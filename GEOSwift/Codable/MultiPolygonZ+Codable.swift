extension MultiPolygonZ: CodableGeometry {
    static let geoJSONType = GeoJSONType.multiPolygon

    var coordinates: [[[[Double]]]] {
        polygons.map { $0.coordinates }
    }

    init(coordinates: [[[[Double]]]]) throws {
        try self.init(polygons: coordinates.map(PolygonZ.init))
    }
}
