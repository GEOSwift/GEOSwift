// for internal use only; GeoJSON encoding & decoding helpers
extension Point: CodableGeometry {
    static let geoJSONType = GeoJSONType.point

    var coordinates: [Double] {
        return [x, y]
    }

    init(coordinates: [Double]) throws {
        guard coordinates.count >= 2 else {
            throw GEOSwiftError.invalidCoordinates
        }
        self.init(x: coordinates[0], y: coordinates[1])
    }
}
