// for internal use only; GeoJSON encoding & decoding helpers
extension Polygon: CodableGeometry, Codable where C: GeoJSONCoordinate {
    static var geoJSONType: GeoJSONType { .polygon }

    var coordinates: [[C]] {
        let allRings = [exterior] + holes
        return allRings.map { $0.coordinates }
    }

    init(coordinates: [[C]]) throws {
        let rings = try coordinates.map(LinearRing.init)
        guard rings.count >= 1 else {
            throw GEOSwiftError.tooFewRings
        }
        self.init(exterior: rings[0], holes: Array(rings[1..<rings.count]))
    }
}
