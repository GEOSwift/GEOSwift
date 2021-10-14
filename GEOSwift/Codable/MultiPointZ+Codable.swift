extension MultiPointZ: CodableGeometry {
    static let geoJSONType = GeoJSONType.multiPoint

    var coordinates: [[Double]] {
        points.map { $0.coordinates }
    }

    init(coordinates: [[Double]]) throws {
        try self.init(points: coordinates.map(PointZ.init))
    }
}
