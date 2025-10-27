import GEOSwift

func makePoints(withCount count: UInt) -> [Point<XY>] {
    (0..<count)
        .map(Double.init)
        .map { Point(x: $0, y: $0) }
}

func makeCoordinates(withCount count: UInt) -> [XY] {
    (0..<count)
        .map(Double.init)
        .map { XY($0, $0) }
}

func makeLineStrings(withCount count: UInt) -> [LineString<XY>] {
    (0..<count).compactMap { (i) in
        let coordinates = makeCoordinates(withCount: 2 + i)
        return try? LineString(coordinates: coordinates)
    }
}

func makeLinearRings(withCount count: UInt) -> [Polygon<XY>.LinearRing] {
    (0..<count).compactMap { (i) in
        var coordinates = makeCoordinates(withCount: 3 + i)
        coordinates.append(coordinates[0])
        return try? Polygon.LinearRing(coordinates: coordinates)
    }
}

func makePolygons(withCount count: UInt) -> [Polygon<XY>] {
    (0..<count).map { (i) in
        let points = makeLinearRings(withCount: 1 + i)
        return Polygon(exterior: points[0], holes: Array(points[1..<points.count]))
    }
}

enum GeometryType: CaseIterable {
    case point
    case multiPoint
    case lineString
    case multiLineString
    case polygon
    case multiPolygon
    case geometryCollection
}

func makeGeometries(withTypes types: [GeometryType]) -> [Geometry<XY>] {
    types.enumerated().map { (idx, type) in
        switch type {
        case .point:
            return .point(Point(x: Double(idx), y: Double(idx)))
        case .multiPoint:
            return .multiPoint(MultiPoint(points: makePoints(withCount: UInt(idx))))
        case .lineString:
            return .lineString(try! LineString(coordinates: makeCoordinates(withCount: 2 + UInt(idx))))
        case .multiLineString:
            return .multiLineString(MultiLineString(lineStrings: makeLineStrings(withCount: UInt(idx))))
        case .polygon:
            let linearRings = makeLinearRings(withCount: 1 + UInt(idx))
            return .polygon(Polygon(exterior: linearRings[0], holes: Array(linearRings[1...])))
        case .multiPolygon:
            let polygons = makePolygons(withCount: UInt(idx))
            return .multiPolygon(MultiPolygon(polygons: polygons))
        case .geometryCollection:
            var allNonRecursiveTypes = GeometryType.allCases
            allNonRecursiveTypes.removeLast()
            let types = (0..<idx).compactMap { _ in allNonRecursiveTypes.randomElement() }
            let geometries = makeGeometries(withTypes: types)
            return .geometryCollection(GeometryCollection(geometries: geometries))
        }
    }
}

func makeFeatures(withCount count: UInt) -> [Feature<XY>] {
    (0..<count).map { (i) in
        let point = Point(x: Double(i), y: Double(i))
        return Feature(geometry: point, properties: nil, id: .number(Double(i)))
    }
}
