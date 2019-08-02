// for internal use only; GeoJSON encoding & decoding helpers
extension LineString: CodableGeometry {
    static let geoJSONType = GeoJSONType.lineString

    var coordinates: [[Double]] {
        return points.map { $0.coordinates }
    }

    init(coordinates: [[Double]]) throws {
        try self.init(points: coordinates.map(Point.init))
    }
}
