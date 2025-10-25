import Foundation

// MARK: - General coordinates

public protocol CoordinateType: Hashable, Codable, Sendable {

    // MARK: Public API

    static var dimension: Int { get }
    static var hasZ: Bool { get }
    static var hasM: Bool { get }

    var x: Double { get set }
    var y: Double { get set }
    var values: [Double] { get }

    // MARK: Internal API

    // This is for internal use only, but it must be exposed to the API since the protocol is public. There
    // may be a way around this with more clever typing.
    static var bridge: GeosCoordinateBridge<Self> { get }
}

// MARK: - Z-containing coordinates

public protocol HasZ: CoordinateType {
    var z: Double { get set }
}

// MARK: - M-containing coordinates

public protocol HasM: CoordinateType {
    var m: Double { get set }
}
