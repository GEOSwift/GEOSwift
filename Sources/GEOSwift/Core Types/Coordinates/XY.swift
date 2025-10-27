import Foundation
import geos

/// A 2-dimensional coordinate with x and y values.
public struct XY: CoordinateType, GeoJSONCoordinate {

    // MARK: Public API

    public static let dimension = 2
    public static let hasZ = false
    public static let hasM = false

    /// The x coordinate
    public var x: Double

    /// The y coordinate
    public var y: Double

    /// All coordinate values as an array
    public var values: [Double] { [x, y] }

    /// Initialize an `XY` coordinate from x and y values.
    /// - parameters:
    ///   - x: The x coordinate.
    ///   - y: The y coordinate.
    public init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }

    /// Initialize an `XY` coordinate from another coordinate, copying only the x and y values.
    /// - parameters:
    ///   - coordinate: The coordinate to copy from.
    public init<C: CoordinateType>(_ coordinate: C) {
        self.x = coordinate.x
        self.y = coordinate.y
    }

    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode([Double].self)

        // Allow decoding from XY, XYZ, XYM, and XYZM coordinates
        guard values.count >= 2 && values.count <= 4 else {
            throw GEOSwiftError.invalidCoordinates
        }

        self.x = values[0]
        self.y = values[1]
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(values)
    }

    // MARK: Internal API

    public static let bridge = GeosCoordinateBridge(
        getter: { (context, seq, idx) in
            var x: Double = 0
            var y: Double = 0
            guard GEOSCoordSeq_getXY_r(context.handle, seq, UInt32(idx), &x, &y) != 0 else {
                throw GEOSError.libraryError(errorMessages: context.errors)
            }
            return XY(x, y)
        },
        setter: { (context, seq, idx, coord) in
            guard GEOSCoordSeq_setXY_r(context.handle, seq, UInt32(idx), coord.x, coord.y) != 0 else {
                throw GEOSError.libraryError(errorMessages: context.errors)
            }
        }
    )
}
