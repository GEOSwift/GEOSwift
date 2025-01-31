import geos

public extension LineStringConvertible {

    // MARK: - Linear Referencing Functions

    /// - returns: The distance of a point projected on the calling line
    func distanceFromStart(toProjectionOf point: Point) throws -> Double {
        let context = try GEOSContext()
        let lineStringGeosObject = try lineString.geosObject(with: context)
        let pointGeosObject = try point.geosObject(with: context)
        // returns -1 on exception
        let result = GEOSProject_r(context.handle, lineStringGeosObject.pointer, pointGeosObject.pointer)
        guard result != -1 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return result
    }

    func normalizedDistanceFromStart(toProjectionOf point: Point) throws -> Double {
        let context = try GEOSContext()
        let lineStringGeosObject = try lineString.geosObject(with: context)
        let pointGeosObject = try point.geosObject(with: context)
        // returns -1 on exception
        let result = GEOSProjectNormalized_r(
            context.handle,
            lineStringGeosObject.pointer,
            pointGeosObject.pointer
        )
        guard result != -1 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return result
    }

    /// If distance is negative, the interpolation starts from the end and works backwards
    func interpolatedPoint(withDistance distance: Double) throws -> Point {
        let context = try GEOSContext()
        let lineStringGeosObject = try lineString.geosObject(with: context)
        guard let pointer = GEOSInterpolate_r(context.handle, lineStringGeosObject.pointer, distance) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return try Point(geosObject: GEOSObject(context: context, pointer: pointer))
    }

    /// If fraction is negative, the interpolation starts from the end and works backwards
    func interpolatedPoint(withFraction fraction: Double) throws -> Point {
        let context = try GEOSContext()
        let lineStringGeosObject = try lineString.geosObject(with: context)
        guard let pointer = GEOSInterpolateNormalized_r(
            context.handle,
            lineStringGeosObject.pointer,
            fraction
        ) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return try Point(geosObject: GEOSObject(context: context, pointer: pointer))
    }

    /// - returns: A substring of the LineString defined by the start and end fractions
    func substring(fromFraction: Double, toFraction: Double) throws -> LineString {
        let context = try GEOSContext()
        let lineStringGeosObject = try lineString.geosObject(with: context)
        guard let pointer = GEOSLineSubstring_r(
            context.handle,
            lineStringGeosObject.pointer,
            fromFraction,
            toFraction
        ) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return try LineString(geosObject: GEOSObject(context: context, pointer: pointer))
    }
}
