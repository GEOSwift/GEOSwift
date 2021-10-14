extension PointZ: CodableGeometry {
    static let geoJSONType = GeoJSONType.point

    var coordinates: [Double] {
        [x, y, z]
    }

    init(coordinates: [Double]) throws {
        guard coordinates.count >= 3 else {
            throw GEOSwiftError.invalidCoordinates
        }
        self.init(x: coordinates[0], y: coordinates[1], z: coordinates[2])
    }
}
