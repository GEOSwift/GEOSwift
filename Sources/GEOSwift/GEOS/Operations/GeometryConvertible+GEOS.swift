import geos

public extension GeometryConvertible {
    
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
