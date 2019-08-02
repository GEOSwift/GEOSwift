// for internal use only; GeoJSON encoding & decoding helpers
extension MultiPoint: CodableGeometry {
    static let geoJSONType = GeoJSONType.multiPoint

    var coordinates: [[Double]] {
        return points.map { $0.coordinates }
    }

    init(coordinates: [[Double]]) throws {
        try self.init(points: coordinates.map(Point.init))
    }
}
