import Foundation
import geos

public extension GeometryConvertible {
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
            for coordinate in polygon.exterior.coordinates {
                minX = .minimum(minX, coordinate.x)
                maxX = .maximum(maxX, coordinate.x)
                minY = .minimum(minY, coordinate.y)
                maxY = .maximum(maxY, coordinate.y)
            }
            return Envelope(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
        default:
            throw GEOSwiftError.unexpectedEnvelopeResult(AnyGeometry(geometry))
        }
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

    // Always drops Z/M
    func minimumRotatedRectangle() throws -> Geometry<XY> {
        try performUnaryTopologyOperation(GEOSMinimumRotatedRectangle_r)
    }

    // Always drops Z/M
    func minimumWidth() throws -> LineString<XY> {
        try performUnaryTopologyOperation(GEOSMinimumWidth_r)
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
}
