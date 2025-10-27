import Foundation
import geos

/// A 3-dimensional coordinate with x, y, and z (altitude/elevation) values.
public struct XYZ: CoordinateType, HasZ, GeoJSONCoordinate {

    // MARK: Public API

    public static let dimension = 3
    public static let hasZ = true
    public static let hasM = false

    /// The x coordinate
    public var x: Double

    /// The y coordinate
    public var y: Double

    /// The z coordinate (altitude/elevation)
    public var z: Double

    /// All coordinate values as an array
    public var values: [Double] { [x, y, z] }

    /// Initialize an `XYZ` coordinate from x, y, and z values.
    /// - parameters:
    ///   - x: The x coordinate.
    ///   - y: The y coordinate.
    ///   - z: The z coordinate (altitude/elevation).
    public init(_ x: Double, _ y: Double, _ z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    /// Initialize an `XYZ` coordinate from another coordinate with a z dimension.
    /// - parameters:
    ///   - coordinate: The coordinate to copy from.
    public init<C: CoordinateType>(_ coordinate: C) where C: HasZ {
        self.x = coordinate.x
        self.y = coordinate.y
        self.z = coordinate.z
    }

    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode([Double].self)

        // Allow decoding from XYZ and XYZM coordinates
        guard values.count == 3 || values.count == 4 else {
            throw GEOSwiftError.invalidCoordinates
        }

        self.x = values[0]
        self.y = values[1]
        self.z = values[2]
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
            var z: Double = 0

            guard GEOSCoordSeq_getXYZ_r(context.handle, seq, UInt32(idx), &x, &y, &z) != 0 else {
                throw GEOSError.libraryError(errorMessages: context.errors)
            }

            return XYZ(x, y, z)
        },
        setter: { (context, seq, idx, coord) in
            guard GEOSCoordSeq_setXYZ_r(context.handle, seq, UInt32(idx), coord.x, coord.y, coord.z) != 0 else {
                throw GEOSError.libraryError(errorMessages: context.errors)
            }
        }
    )
}
