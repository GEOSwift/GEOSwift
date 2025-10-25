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

    func distance<D: CoordinateType>(to geometry: any GeometryConvertible<D>) throws -> Double {
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

    func hausdorffDistance<D: CoordinateType>(to geometry: any GeometryConvertible<D>) throws -> Double {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)

        var distance: Double = 0
        // returns 0 on exception
        guard GEOSHausdorffDistance_r(
            context.handle,
            geosObject.pointer,
            otherGeosObject.pointer,
            &distance
        ) == 1 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return distance
    }

    func hausdorffDistanceDensify<D: CoordinateType>(
        to geometry: any GeometryConvertible<D>,
        densifyFraction: Double
    ) throws -> Double {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)

        var distance: Double = 0
        // returns 0 on exception
        guard GEOSHausdorffDistanceDensify_r(
            context.handle,
            geosObject.pointer,
            otherGeosObject.pointer,
            densifyFraction,
            &distance
        ) == 1 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return distance
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

    // Always returns XY
    func nearestPoints<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> [Point<XY>] {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)
        guard let coordSeq = GEOSNearestPoints_r(
            context.handle, geosObject.pointer, otherGeosObject.pointer) else {
                throw GEOSError.libraryError(errorMessages: context.errors)
        }
        defer { GEOSCoordSeq_destroy_r(context.handle, coordSeq) }

        let point0 = try Point(coordinates: XY.bridge.getter(context, coordSeq, 0))
        let point1 = try Point(coordinates: XY.bridge.getter(context, coordSeq, 1))
        return [point0, point1]
    }

    // MARK: - Unary Predicates

    internal typealias UnaryPredicate = (GEOSContextHandle_t, OpaquePointer) -> Int8

    internal func evaluateUnaryPredicate(_ predicate: UnaryPredicate) throws -> Bool {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        // returns 2 on exception, 1 on true, 0 on false
        let result = predicate(context.handle, geosObject.pointer)
        guard result != 2 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return result == 1
    }

    func isEmpty() throws -> Bool {
        try evaluateUnaryPredicate(GEOSisEmpty_r)
    }

    func isRing() throws -> Bool {
        try evaluateUnaryPredicate(GEOSisRing_r)
    }

    func isValid() throws -> Bool {
        try evaluateUnaryPredicate(GEOSisValid_r)
    }

    func isValidReason() throws -> String {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        guard let cString = GEOSisValidReason_r(context.handle, geosObject.pointer) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        defer { GEOSFree_r(context.handle, cString) }
        return String(cString: cString)
    }

    func isValidDetail(allowSelfTouchingRingFormingHole: Bool = false) throws -> IsValidDetailResult<C> {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let flags: Int32 = allowSelfTouchingRingFormingHole
            ? Int32(GEOSVALID_ALLOW_SELFTOUCHING_RING_FORMING_HOLE.rawValue)
            : 0
        var optionalReason: UnsafeMutablePointer<Int8>?
        var optionalLocation: OpaquePointer?
        switch GEOSisValidDetail_r(
            context.handle, geosObject.pointer, flags, &optionalReason, &optionalLocation) {
        case 1: // Valid
            if let reason = optionalReason {
                GEOSFree_r(context.handle, reason)
            }
            if let location = optionalLocation {
                GEOSGeom_destroy_r(context.handle, location)
            }
            return .valid
        case 0: // Invalid
            let reason = optionalReason.map { (reason) -> String in
                defer { GEOSFree_r(context.handle, reason) }
                return String(cString: reason)
            }
            let location = try optionalLocation.map { (location) -> Geometry<C> in
                let locationGEOSObject = GEOSObject(context: context, pointer: location)
                return try Geometry(geosObject: locationGEOSObject)
            }
            return .invalid(reason: reason, location: location)
        default: // Error
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
    }

    // MARK: - Binary Predicates

    private typealias BinaryPredicate = (GEOSContextHandle_t, OpaquePointer, OpaquePointer) -> Int8

    private func evaluateBinaryPredicate<D: CoordinateType>(
        _ predicate: BinaryPredicate,
        with geometry: any GeometryConvertible<D>
    ) throws -> Bool {
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

    func isTopologicallyEquivalent<D: CoordinateType>(to geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSEquals_r, with: geometry)
    }

    func isDisjoint<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSDisjoint_r, with: geometry)
    }

    func touches<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSTouches_r, with: geometry)
    }

    func intersects<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSIntersects_r, with: geometry)
    }

    func crosses<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSCrosses_r, with: geometry)
    }

    func isWithin<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSWithin_r, with: geometry)
    }

    func contains<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSContains_r, with: geometry)
    }

    func overlaps<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSOverlaps_r, with: geometry)
    }

    func covers<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSCovers_r, with: geometry)
    }

    func isCovered<D: CoordinateType>(by geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSCoveredBy_r, with: geometry)
    }

    // MARK: - Prepared Geometry

    func makePrepared() throws -> PreparedGeometry<C> {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        return try PreparedGeometry(context: context, base: geosObject)
    }

    // MARK: - Dimensionally Extended 9 Intersection Model Functions

    /// Parameter mask: A DE9-IM mask pattern
    func relate<D: CoordinateType>(_ geometry: any GeometryConvertible<D>, mask: String) throws -> Bool {
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

    func relate<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> String {
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

    private func nilIfTooFewPoints<D: CoordinateType>(op: () throws -> Geometry<D>) throws -> Geometry<D>? {
        do {
            return try op()
        } catch GEOSwiftError.tooFewPoints {
            return nil
        } catch {
            throw error
        }
    }

    internal typealias UnaryOperation = (GEOSContextHandle_t, OpaquePointer) -> OpaquePointer?

    // TODO: Look into this more deeply. Likely need to define seperate extensions on HasZ since M is dropped
    internal func performUnaryTopologyOperation<T>(_ operation: UnaryOperation) throws -> T
        where T: GEOSObjectInitializable {
            let context = try GEOSContext()
            let geosObject = try geometry.geosObject(with: context)
            guard let pointer = operation(context.handle, geosObject.pointer) else {
                throw GEOSError.libraryError(errorMessages: context.errors)
            }
            return try T(geosObject: GEOSObject(context: context, pointer: pointer))
    }

    private typealias BinaryOperation = (GEOSContextHandle_t, OpaquePointer, OpaquePointer) -> OpaquePointer?

    // TODO: Need to refine this since the output dimensions are the minimum of the input dimensions
    private func performBinaryTopologyOperation<D: CoordinateType, E: CoordinateType>(
        _ operation: BinaryOperation,
        geometry: any GeometryConvertible<D>
    ) throws -> Geometry<E> {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)
        guard let pointer = operation(context.handle, geosObject.pointer, otherGeosObject.pointer) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return try Geometry(geosObject: GEOSObject(context: context, pointer: pointer))
    }

    func envelope() throws -> Envelope {
        let geometry: Geometry<XY> = try performUnaryTopologyOperation(GEOSEnvelope_r)
        switch geometry {
        case let .point(point):
            return Envelope(
                minX: point.coordinates.x,
                maxX: point.coordinates.x,
                minY: point.coordinates.y,
                maxY: point.coordinates.y
            )
        case let .polygon(polygon):
            var minX = Double.nan
            var maxX = Double.nan
            var minY = Double.nan
            var maxY = Double.nan
            for point in polygon.exterior.points {
                minX = .minimum(minX, point.coordinates.x)
                maxX = .maximum(maxX, point.coordinates.x)
                minY = .minimum(minY, point.coordinates.y)
                maxY = .maximum(maxY, point.coordinates.y)
            }
            return Envelope(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
        default:
            throw GEOSwiftError.unexpectedEnvelopeResult(AnyGeometry(geometry))
        }
    }

    // TODO: Provide higher dimensionality output where possible. Dimension Union.
    func intersection(with geometry: any GeometryConvertible<C>) throws -> Geometry<XY>? {
        return try nilIfTooFewPoints {
            try performBinaryTopologyOperation(GEOSIntersection_r, geometry: geometry)
        }
    }

    // TODO: Provide higher dimensionality output where possible. Preserves Z, drops M.
    func makeValid() throws -> Geometry<XY> {
        try performUnaryTopologyOperation(GEOSMakeValid_r)
    }

    // TODO: Provide higher dimensionality output where possible. Preserves Z, drops M.
    func makeValid(method: MakeValidMethod) throws -> Geometry<XY> {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        let params = MakeValidParams(context: context, method: method)
        guard let pointer = GEOSMakeValidWithParams_r(
            context.handle,
            geosObject.pointer,
            params.pointer
        ) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return try Geometry(geosObject: GEOSObject(context: context, pointer: pointer))
    }

    // Preserves input dimensions
    func normalized() throws -> Geometry<C> {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        // GEOSNormalize_r returns -1 on exception
        guard GEOSNormalize_r(context.handle, geosObject.pointer) != -1 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return try Geometry(geosObject: geosObject)
    }

    // TODO: Provide higher dimensionality output where possible. Preserves Z, drops M.
    func convexHull() throws -> Geometry<XY> {
        try performUnaryTopologyOperation(GEOSConvexHull_r)
    }

    // TODO: Provide higher dimensionality output where possible. Preserves Z, drops M.
    func concaveHull(withRatio ratio: Double, allowHoles: Bool) throws -> Geometry<XY> {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        guard let resultPointer = GEOSConcaveHull_r(
            context.handle,
            geosObject.pointer,
            ratio,
            allowHoles ? 1 : 0
        ) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return try Geometry(geosObject: GEOSObject(context: context, pointer: resultPointer))
    }

    // Always drops Z/M
    func minimumRotatedRectangle() throws -> Geometry<XY> {
        try performUnaryTopologyOperation(GEOSMinimumRotatedRectangle_r)
    }

    // Always drops Z/M
    func minimumWidth() throws -> LineString<XY> {
        try performUnaryTopologyOperation(GEOSMinimumWidth_r)
    }

    // TODO: Provide higher dimensionality output where possible. Preserves Z, drops M.
    func difference(with geometry: any GeometryConvertible<C>) throws -> Geometry<XY>? {
        return try nilIfTooFewPoints {
            try performBinaryTopologyOperation(GEOSDifference_r, geometry: geometry)
        }
    }

    // TODO: Provide higher dimensionality output where possible. Preserves Z, drops M.
    func symmetricDifference(with geometry: any GeometryConvertible<C>) throws -> Geometry<XY>? {
        return try nilIfTooFewPoints {
            try performBinaryTopologyOperation(GEOSSymDifference_r, geometry: geometry)
        }
    }

    // TODO: Provide higher dimensionality output where possible. Dimension Union.
    func union(with geometry: any GeometryConvertible<C>) throws -> Geometry<XY> {
        try performBinaryTopologyOperation(GEOSUnion_r, geometry: geometry)
    }

    // verified preserves Z/M
    func unaryUnion() throws -> Geometry<C> {
        try performUnaryTopologyOperation(GEOSUnaryUnion_r)
    }

    // gives XY
    func pointOnSurface() throws -> Point<XY> {
        try performUnaryTopologyOperation(GEOSPointOnSurface_r)
    }

    // gives XY
    func centroid() throws -> Point<XY> {
        try performUnaryTopologyOperation(GEOSGetCentroid_r)
    }

    // gives XY
    func minimumBoundingCircle() throws -> Circle<XY> {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        var radius: Double = 0
        var optionalCenterPointer: OpaquePointer?
        guard let geometryPointer = GEOSMinimumBoundingCircle_r(
            context.handle, geosObject.pointer, &radius, &optionalCenterPointer) else {
                // if we somehow end up with a non-null center and a null geometry,
                // we must still destroy the center before throwing an error
                if let centerPointer = optionalCenterPointer {
                    GEOSGeom_destroy_r(context.handle, centerPointer)
                }
                throw GEOSError.libraryError(errorMessages: context.errors)
        }
        // For our purposes, we only care about the center and radius.
        GEOSGeom_destroy_r(context.handle, geometryPointer)
        guard let centerPointer = optionalCenterPointer else {
            throw GEOSError.noMinimumBoundingCircle
        }
        let center = try Point<XY>(geosObject: GEOSObject(context: context, pointer: centerPointer))
        return Circle(center: center, radius: radius)
    }

    // TODO: Provide higher dimensionality output where possible. Preserves Z, drops M.
    func polygonize() throws -> GeometryCollection<XY> {
        try [self].polygonize()
    }

    // TODO: Provide higher dimensionality output where possible. Preserves Z, drops M.
    func lineMerge() throws -> Geometry<XY> {
        try performUnaryTopologyOperation(GEOSLineMerge_r)
    }

    // TODO: Provide higher dimensionality output where possible. Preserves Z, drops M.
    func lineMergeDirected() throws -> Geometry<XY> {
        try performUnaryTopologyOperation(GEOSLineMergeDirected_r)
    }

    // MARK: - Buffer Functions

    // XY only
    func buffer(by width: Double) throws -> Geometry<XY>? {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        // the last parameter in GEOSBuffer_r is called `quadsegs` and in other places in GEOS, it defaults to
        // 8, which seems to produce an "expected" result. See https://github.com/GEOSwift/GEOSwift/issues/216
        //
        // returns nil on exception
        guard let resultPointer = GEOSBuffer_r(context.handle, geosObject.pointer, width, 8) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return try nilIfTooFewPoints {
            try Geometry(geosObject: GEOSObject(context: context, pointer: resultPointer))
        }
    }

    // XY only
    func bufferWithStyle(
        width: Double,
        quadsegs: Int32 = 8,
        endCapStyle: BufferEndCapStyle = .round,
        joinStyle: BufferJoinStyle = .round,
        mitreLimit: Double = 5.0
    ) throws -> Geometry<XY>? {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)

        guard let resultPointer = GEOSBufferWithStyle_r(
            context.handle,
            geosObject.pointer,
            width,
            quadsegs,
            Int32(endCapStyle.geosValue.rawValue),
            Int32(joinStyle.geosValue.rawValue),
            mitreLimit
        ) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return try nilIfTooFewPoints {
            try Geometry(geosObject: GEOSObject(context: context, pointer: resultPointer))
        }
    }

    // XY only
    func offsetCurve(
        width: Double,
        quadsegs: Int32 = 8,
        joinStyle: BufferJoinStyle = .bevel,
        mitreLimit: Double = 5.0
    ) throws -> Geometry<XY>? {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)

        guard let resultPointer = GEOSOffsetCurve_r(
            context.handle,
            geosObject.pointer,
            width,
            quadsegs,
            Int32(joinStyle.geosValue.rawValue),
            mitreLimit
        ) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return try nilIfTooFewPoints {
            try Geometry(geosObject: GEOSObject(context: context, pointer: resultPointer))
        }
    }

    // MARK: - Simplify Functions

    // TODO: Provide higher dimensionality output where possible. Preserves Z, drops M.
    func simplify(withTolerance tolerance: Double) throws -> Geometry<XY> {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        guard let resultPointer = GEOSSimplify_r(context.handle, geosObject.pointer, tolerance) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return try Geometry(geosObject: GEOSObject(context: context, pointer: resultPointer))
    }

    // MARK: - Snapping

    // TODO: Provide higher dimensionality output where possible. Preserves Z, drops M.
    func snap(to geometry: any GeometryConvertible<C>, tolerance: Double) throws -> Geometry<XY> {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)
        guard let pointer = GEOSSnap_r(
            context.handle,
            geosObject.pointer,
            otherGeosObject.pointer,
            tolerance
        ) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return try Geometry(geosObject: GEOSObject(context: context, pointer: pointer))
    }
}

public extension Collection where Element: GeometryConvertible {
    // TODO: Provide higher dimensionality output where possible. Preserves Z, drops M.
    func polygonize() throws -> GeometryCollection<XY> {
        let context = try GEOSContext()
        let geosObjects = try map { try $0.geometry.geosObject(with: context) }
        let pointer = withExtendedLifetime(geosObjects) { geosObjects in
            GEOSPolygonize_r(context.handle, geosObjects.map { $0.pointer }, UInt32(geosObjects.count))
        }
        guard let pointer else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return try GeometryCollection(geosObject: GEOSObject(context: context, pointer: pointer))
    }
}

public enum BufferEndCapStyle: Hashable, Sendable {
    case round
    case flat
    case square

    var geosValue: GEOSBufCapStyles {
        switch self {
        case .round:
            return GEOSBUF_CAP_ROUND
        case .flat:
            return GEOSBUF_CAP_FLAT
        case .square:
            return GEOSBUF_CAP_SQUARE
        }
    }
}

public enum BufferJoinStyle: Hashable, Sendable {
    case round
    case mitre
    case bevel

    var geosValue: GEOSBufJoinStyles {
        switch self {
        case .round:
            return GEOSBUF_JOIN_ROUND
        case .mitre:
            return GEOSBUF_JOIN_MITRE
        case .bevel:
            return GEOSBUF_JOIN_BEVEL
        }
    }
}

public enum IsValidDetailResult<C: CoordinateType>: Hashable, Sendable {
    case valid
    case invalid(reason: String?, location: Geometry<C>?)
}

public enum MakeValidMethod {
    case linework
    case structure(keepCollapsed: Bool)

    var geosMethod: GEOSMakeValidMethods {
        switch self {
        case .linework:
            return GEOS_MAKE_VALID_LINEWORK
        case .structure:
            return GEOS_MAKE_VALID_STRUCTURE
        }
    }

    var keepCollapsed: Int32? {
        switch self {
        case .linework:
            return nil
        case .structure(let keepCollapsed):
            return keepCollapsed ? 1 : 0
        }
    }
}

private class MakeValidParams {
    let context: GEOSContext
    let pointer: OpaquePointer

    init(context: GEOSContext, method: MakeValidMethod) {
        self.context = context
        self.pointer = GEOSMakeValidParams_create_r(context.handle)
        assert(GEOSMakeValidParams_setMethod_r(context.handle, pointer, method.geosMethod) == 1)
        if let keepCollapsed = method.keepCollapsed {
            assert(GEOSMakeValidParams_setKeepCollapsed_r(context.handle, pointer, keepCollapsed) == 1)
        }
    }

    deinit {
        GEOSMakeValidParams_destroy_r(context.handle, pointer)
    }
}
