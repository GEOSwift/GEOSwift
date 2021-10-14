extension LineStringZ: CodableGeometry {
    static let geoJSONType = GeoJSONType.lineString

    var coordinates: [[Double]] {
        points.map { $0.coordinates }
    }

    init(coordinates: [[Double]]) throws {
        try self.init(points: coordinates.map(PointZ.init))
    }
}
