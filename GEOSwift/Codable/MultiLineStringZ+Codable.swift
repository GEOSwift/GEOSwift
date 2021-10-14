extension MultiLineStringZ: CodableGeometry {
    static let geoJSONType = GeoJSONType.multiLineString

    var coordinates: [[[Double]]] {
        lineStrings.map { $0.coordinates }
    }

    init(coordinates: [[[Double]]]) throws {
        try self.init(lineStrings: coordinates.map(LineStringZ.init))
    }
}
