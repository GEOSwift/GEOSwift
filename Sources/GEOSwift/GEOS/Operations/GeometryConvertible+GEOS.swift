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

    internal func nilIfTooFewPoints<D: CoordinateType>(op: () throws -> Geometry<D>) throws -> Geometry<D>? {
        do {
            return try op()
        } catch GEOSwiftError.tooFewCoordinates {
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

    internal typealias BinaryOperation = (GEOSContextHandle_t, OpaquePointer, OpaquePointer) -> OpaquePointer?

    // TODO: Need to refine this since the output dimensions are the minimum of the input dimensions
    internal func performBinaryTopologyOperation<D: CoordinateType, E: CoordinateType>(
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
}
