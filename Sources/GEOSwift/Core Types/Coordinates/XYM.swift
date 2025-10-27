import Foundation
import geos

/// A 3-dimensional coordinate with x, y, and m (measure) values.
public struct XYM: CoordinateType, HasM {

    // MARK: Public API

    public static let dimension = 3
    public static let hasZ = false
    public static let hasM = true

    /// The x coordinate
    public var x: Double

    /// The y coordinate
    public var y: Double

    /// The m coordinate (measure)
    public var m: Double

    /// All coordinate values as an array
    public var values: [Double] { [x, y, m] }

    /// Initialize an `XYM` coordinate from x, y, and m values.
    /// - parameters:
    ///   - x: The x coordinate.
    ///   - y: The y coordinate.
    ///   - m: The m coordinate (measure).
    public init(_ x: Double, _ y: Double, _ m: Double) {
        self.x = x
        self.y = y
        self.m = m
    }

    /// Initialize an `XYM` coordinate from another coordinate with an m dimension.
    /// - parameters:
    ///   - coordinate: The coordinate to copy from.
    public init<C: CoordinateType>(_ coordinate: C) where C: HasM {
        self.x = coordinate.x
        self.y = coordinate.y
        self.m = coordinate.m
    }

    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode([Double].self)

        // Allow decoding from XYZM coordinates. XYM is not allowed in the GeoJSON spec.
        guard values.count == 4 else {
            throw GEOSwiftError.invalidCoordinates
        }

        self.x = values[0]
        self.y = values[1]
        self.m = values[3]
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([x, y, .nan, m])
    }

    // MARK: Internal API

    public static let bridge = GeosCoordinateBridge(
        getter: { (context, seq, idx) in
            var x: Double = 0
            var y: Double = 0
            var m: Double = 0

            guard GEOSCoordSeq_getXY_r(context.handle, seq, UInt32(idx), &x, &y) != 0 else {
                throw GEOSError.libraryError(errorMessages: context.errors)
            }

            guard GEOSCoordSeq_getM_r(context.handle, seq, UInt32(idx), &m) != 0 else {
                throw GEOSError.libraryError(errorMessages: context.errors)
            }

            return XYM(x, y, m)
        },
        setter: { (context, seq, idx, coord) in
            guard GEOSCoordSeq_setXY_r(context.handle, seq, UInt32(idx), coord.x, coord.y) != 0 else {
                throw GEOSError.libraryError(errorMessages: context.errors)
            }

            guard GEOSCoordSeq_setM_r(context.handle, seq, UInt32(idx), coord.m) != 0 else {
                throw GEOSError.libraryError(errorMessages: context.errors)
            }
        }
    )
}
