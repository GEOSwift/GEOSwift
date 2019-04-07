import geos

public extension GeometryConvertible {

    // MARK: - Misc Functions

    func length() throws -> Double {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        var length: Double = 0
        // returns 0 on exception
        guard GEOSLength_r(context.handle, geosObject.pointer, &length) != 0 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return length
    }

    func distance(to geometry: GeometryConvertible) throws -> Double {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)
        var dist: Double = 0
        // returns 0 on exception
        guard GEOSDistance_r(context.handle, geosObject.pointer, otherGeosObject.pointer, &dist) != 0 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return dist
    }

    func area() throws -> Double {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        var area: Double = 0
        // returns 0 on exception
        guard GEOSArea_r(context.handle, geosObject.pointer, &area) != 0 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return area
    }

    func nearestPoints(with geometry: GeometryConvertible) throws -> [Point] {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)
        guard let coordSeq = GEOSNearestPoints_r(
            context.handle, geosObject.pointer, otherGeosObject.pointer) else {
                throw GEOSError.libraryError(errorMessages: context.errors)
        }
        defer { GEOSCoordSeq_destroy_r(context.handle, coordSeq) }
        var point0 = Point(x: 0, y: 0)
        GEOSCoordSeq_getX_r(context.handle, coordSeq, 0, &point0.x)
        GEOSCoordSeq_getY_r(context.handle, coordSeq, 0, &point0.y)
        var point1 = Point(x: 0, y: 0)
        GEOSCoordSeq_getX_r(context.handle, coordSeq, 1, &point1.x)
        GEOSCoordSeq_getY_r(context.handle, coordSeq, 1, &point1.y)
        return [point0, point1]
    }

    // MARK: - Binary Predicates

    private func evaluateBinaryPredicate(
        _ predicate: (GEOSContextHandle_t, OpaquePointer, OpaquePointer) -> Int8,
        with geometry: GeometryConvertible) throws -> Bool {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)
        // returns 2 on exception, 1 on true, 0 on false
        let result = predicate(context.handle, geosObject.pointer, otherGeosObject.pointer)
        guard result != 2 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return result == 1
    }

    func isTopologicallyEquivalent(to geometry: GeometryConvertible) throws -> Bool {
        return try evaluateBinaryPredicate(GEOSEquals_r, with: geometry)
    }

    func isDisjoint(with geometry: GeometryConvertible) throws -> Bool {
        return try evaluateBinaryPredicate(GEOSDisjoint_r, with: geometry)
    }

    func touches(_ geometry: GeometryConvertible) throws -> Bool {
        return try evaluateBinaryPredicate(GEOSTouches_r, with: geometry)
    }

    func intersects(_ geometry: GeometryConvertible) throws -> Bool {
        return try evaluateBinaryPredicate(GEOSIntersects_r, with: geometry)
    }

    func crosses(_ geometry: GeometryConvertible) throws -> Bool {
        return try evaluateBinaryPredicate(GEOSCrosses_r, with: geometry)
    }

    func isWithin(_ geometry: GeometryConvertible) throws -> Bool {
        return try evaluateBinaryPredicate(GEOSWithin_r, with: geometry)
    }

    func contains(_ geometry: GeometryConvertible) throws -> Bool {
        return try evaluateBinaryPredicate(GEOSContains_r, with: geometry)
    }

    func overlaps(_ geometry: GeometryConvertible) throws -> Bool {
        return try evaluateBinaryPredicate(GEOSOverlaps_r, with: geometry)
    }

    func covers(_ geometry: GeometryConvertible) throws -> Bool {
        return try evaluateBinaryPredicate(GEOSCovers_r, with: geometry)
    }

    func isCovered(by geometry: GeometryConvertible) throws -> Bool {
        return try evaluateBinaryPredicate(GEOSCoveredBy_r, with: geometry)
    }

    // MARK: - Dimensionally Extended 9 Intersection Model Functions

    /// Parameter mask: A DE9-IM mask pattern
    func relate(_ geometry: GeometryConvertible, mask: String) throws -> Bool {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)
        // returns 2 on exception, 1 on true, 0 on false
        let result = mask.withCString {
            GEOSRelatePattern_r(context.handle, geosObject.pointer, otherGeosObject.pointer, $0)
        }
        guard result != 2 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return result == 1
    }

    func relate(_ geometry: GeometryConvertible) throws -> String {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)
        guard let cString = GEOSRelate_r(context.handle, geosObject.pointer, otherGeosObject.pointer) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        defer { GEOSFree_r(context.handle, cString) }
        return String(cString: cString)
    }

    // MARK: - Topology Operations

    internal func performUnaryTopologyOperation<T>(
        _ operation: (GEOSContextHandle_t, OpaquePointer) -> OpaquePointer?) throws -> T
        where T: GEOSObjectInitializable {
            let context = try GEOSContext()
            let geosObject = try geometry.geosObject(with: context)
            guard let pointer = operation(context.handle, geosObject.pointer) else {
                throw GEOSError.libraryError(errorMessages: context.errors)
            }
            return try T(geosObject: GEOSObject(context: context, pointer: pointer))
    }

    private func performBinaryTopologyOperation(
        _ operation: (GEOSContextHandle_t, OpaquePointer, OpaquePointer) -> OpaquePointer?,
        geometry: GeometryConvertible) throws -> Geometry {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)
        guard let pointer = operation(context.handle, geosObject.pointer, otherGeosObject.pointer) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return try Geometry(geosObject: GEOSObject(context: context, pointer: pointer))
    }

    func envelope() throws -> Envelope {
        let geometry: Geometry = try performUnaryTopologyOperation(GEOSEnvelope_r)
        switch geometry {
        case let .point(point):
            return Envelope(minX: point.x, maxX: point.x, minY: point.y, maxY: point.y)
        case let .polygon(polygon):
            var minX = Double.nan
            var maxX = Double.nan
            var minY = Double.nan
            var maxY = Double.nan
            for point in polygon.exterior.points {
                minX = .minimum(minX, point.x)
                maxX = .maximum(maxX, point.x)
                minY = .minimum(minY, point.y)
                maxY = .maximum(maxY, point.y)
            }
            return Envelope(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
        default:
            throw GEOSwiftError.unexpectedEnvelopeResult(geometry)
        }
    }

    func intersection(with geometry: GeometryConvertible) throws -> Geometry {
        return try performBinaryTopologyOperation(GEOSIntersection_r, geometry: geometry)
    }

    func convexHull() throws -> Geometry {
        return try performUnaryTopologyOperation(GEOSConvexHull_r)
    }

    func minimumRotatedRectangle() throws -> Geometry {
        return try performUnaryTopologyOperation(GEOSMinimumRotatedRectangle_r)
    }

    func minimumWidth() throws -> LineString {
        return try performUnaryTopologyOperation(GEOSMinimumWidth_r)
    }

    func difference(with geometry: GeometryConvertible) throws -> Geometry {
        return try performBinaryTopologyOperation(GEOSDifference_r, geometry: geometry)
    }

    func union(with geometry: GeometryConvertible) throws -> Geometry {
        return try performBinaryTopologyOperation(GEOSUnion_r, geometry: geometry)
    }

    func unaryUnion() throws -> Geometry {
        return try performUnaryTopologyOperation(GEOSUnaryUnion_r)
    }

    func pointOnSurface() throws -> Point {
        return try performUnaryTopologyOperation(GEOSPointOnSurface_r)
    }

    func centroid() throws -> Point {
        return try performUnaryTopologyOperation(GEOSGetCentroid_r)
    }

    // MARK: - Buffer Functions

    func buffer(by width: Double) throws -> Geometry {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        // returns nil on exception
        guard let resultPointer = GEOSBuffer_r(context.handle, geosObject.pointer, width, 0) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return try Geometry(geosObject: GEOSObject(context: context, pointer: resultPointer))
    }
}
