// for internal use only; GeoJSON encoding & decoding helpers
extension Polygon.LinearRing {
    var coordinates: [[Double]] {
        return points.map { $0.coordinates }
    }

    init(coordinates: [[Double]]) throws {
        try self.init(points: coordinates.map(Point.init))
    }
}

// for internal use only; GeoJSON encoding & decoding helpers
extension Polygon: CodableGeometry {
    static let geoJSONType = GeoJSONType.polygon

    var coordinates: [[[Double]]] {
        let allRings = [exterior] + holes
        return allRings.map { $0.coordinates }
    }

    init(coordinates: [[[Double]]]) throws {
        let rings = try coordinates.map(LinearRing.init)
        guard rings.count >= 1 else {
            throw GEOSwiftError.tooFewRings
        }
        self.init(exterior: rings[0], holes: Array(rings[1..<rings.count]))
    }
}
