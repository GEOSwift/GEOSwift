import Foundation

// MARK: - General coordinates

/// A protocol representing a coordinate with x and y values and optional z and m dimensions.
///
/// The four concrete types conforming to this protocol are ``XY``, ``XYZ``, ``XYM``, and ``XYZM``.
public protocol CoordinateType: Hashable, Codable, Sendable {

    // MARK: Public API

    /// The number of dimensions (2, 3, or 4)
    static var dimension: Int { get }

    /// Whether the coordinate type includes a z (altitude/elevation) dimension
    static var hasZ: Bool { get }

    /// Whether the coordinate type includes an m (measure) dimension
    static var hasM: Bool { get }

    /// The x coordinate
    var x: Double { get set }

    /// The y coordinate
    var y: Double { get set }

    /// All coordinate values as an array
    var values: [Double] { get }

    // MARK: Internal API

    // This is for internal use only, but it must be exposed to the API since the protocol is public. There
    // may be a way around this with more clever typing.
    static var bridge: GeosCoordinateBridge<Self> { get }
}

// MARK: - Z-containing coordinates

/// A protocol for coordinate types that include a z (altitude/elevation) dimension.
///
/// Conforming types: ``XYZ``, ``XYZM``
public protocol HasZ: CoordinateType {
    /// The z coordinate (altitude/elevation)
    var z: Double { get set }
}

// MARK: - M-containing coordinates

/// A protocol for coordinate types that include an m (measure) dimension.
///
/// Conforming types: ``XYM``, ``XYZM``
public protocol HasM: CoordinateType {
    /// The m coordinate (measure)
    var m: Double { get set }
}
