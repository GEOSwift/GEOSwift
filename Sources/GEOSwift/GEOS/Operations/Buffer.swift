import Foundation
import geos

// MARK: - Buffer Operations

// Creates buffer geometries around input geometries by expanding them outward (positive width)
// or inward (negative width) by a specified distance.
//
// Note: These operations only return XY geometries. Z and M coordinates are not preserved.

/// Specifies the style of buffered geometry end caps.
public enum BufferEndCapStyle: Hashable, Sendable {
    /// Round end cap style. Creates semicircular end caps.
    case round

    /// Flat (butt) end cap style. Terminates at the line endpoint.
    case flat

    /// Square end cap style. Creates square end caps extending beyond the line endpoint.
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

/// Specifies the style for joining offset curves at vertices.
public enum BufferJoinStyle: Hashable, Sendable {
    /// Round join style. Creates rounded corners.
    case round

    /// Mitre join style. Creates sharp, pointed corners that extend based on the mitre limit.
    case mitre

    /// Bevel join style. Creates beveled (cut-off) corners.
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

public extension GeometryConvertible {
    /// Computes a buffer area around this geometry.
    ///
    /// The buffer is expanded outward by the specified width for positive values, or contracted
    /// inward for negative values. The default quality uses 8 quadrant segments to approximate
    /// curves (quadsegs = 8).
    ///
    /// See `GEOSBuffer_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a76de1c16409b8b230baea5af27090c4a).
    ///
    /// - Parameter width: The buffer distance. Positive values expand the geometry, negative values
    ///   contract it.
    /// - Returns: A buffered ``Geometry``, or `nil` if the result has too few points to form a
    ///   valid geometry.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let point = Point(XY(0, 0))
    /// let buffered = try point.buffer(by: 10.0)
    /// // Returns a circular polygon with radius 10 centered at the point
    /// ```
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

    /// Computes a buffer area around this geometry with fine-grained control over style parameters.
    ///
    /// This method provides detailed control over buffer characteristics including curve quality,
    /// end cap style, join style, and mitre limit.
    ///
    /// See `GEOSBufferWithStyle_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#ab4b3539f1094a9df73a77c4d872b0d78).
    ///
    /// - Parameters:
    ///   - width: The buffer distance. Positive values expand the geometry, negative values
    ///     contract it.
    ///   - quadsegs: Number of segments used to approximate a quarter circle. Higher values create
    ///     smoother curves but increase computation time. Default is 8.
    ///   - endCapStyle: Style for geometry end caps. See ``BufferEndCapStyle``. Default is `.round`.
    ///   - joinStyle: Style for offset curve joins at vertices. See ``BufferJoinStyle``.
    ///     Default is `.round`.
    ///   - mitreLimit: Mitre ratio limit for mitre join style. Limits the length of sharp corners.
    ///     Default is 5.0.
    /// - Returns: A buffered ``Geometry``, or `nil` if the result has too few points to form a
    ///   valid geometry.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let line = try! LineString(coordinates: [XY(0, 0), XY(10, 0)])
    /// let buffered = try line.bufferWithStyle(
    ///     width: 2.0,
    ///     quadsegs: 16,
    ///     endCapStyle: .square,
    ///     joinStyle: .mitre,
    ///     mitreLimit: 3.0
    /// )
    /// // Returns a rectangle with square end caps
    /// ```
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

    /// Computes an offset curve (single-sided buffer) from this linear geometry.
    ///
    /// Creates a line parallel to the input at the specified distance. This is useful for generating
    /// single-sided buffers of linear geometries like roads or rivers. The offset can be on either
    /// side depending on the sign of the width parameter.
    ///
    /// See `GEOSOffsetCurve_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a4251c9bb0e6212df16193fd33dba5423).
    ///
    /// - Parameters:
    ///   - width: The offset distance. Positive values offset to the left, negative values offset to
    ///     the right (relative to the direction of the line).
    ///   - quadsegs: Number of segments used to approximate a quarter circle. Higher values create
    ///     smoother curves. Default is 8.
    ///   - joinStyle: Style for offset curve joins at vertices. See ``BufferJoinStyle``.
    ///     Default is `.bevel`.
    ///   - mitreLimit: Mitre ratio limit for mitre join style. Limits the length of sharp corners.
    ///     Default is 5.0.
    /// - Returns: An offset curve ``Geometry``, or `nil` if the result has too few points to form a
    ///   valid geometry.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let centerline = try! LineString(coordinates: [XY(0, 0), XY(10, 0), XY(10, 10)])
    /// let leftEdge = try centerline.offsetCurve(
    ///     width: 2.0,
    ///     quadsegs: 8,
    ///     joinStyle: .bevel,
    ///     mitreLimit: 5.0
    /// )
    /// // Returns a line offset 2 units to the left of the centerline
    /// ```
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
}
