import Foundation

/// This is a coordinate-type-erasing box for `Geometry`. The purpose is for code to handle
/// geometry types when they don't need to be aware of the underlying coordinate system at
/// compile-time, e.g. error reporting.
public struct AnyGeometry: Hashable, @unchecked(Sendable) {
    public let dimension: Int
    public let hasZ: Bool
    public let hasM: Bool
    
    // We can mark box as sendable in this case since its wrapping the known Sendable `Geometry` type
    private let box: AnyHashable
    
    public init<C>(_ geometry: Geometry<C>) {
        self.box = AnyHashable(geometry)
        self.dimension = geometry.dimension
        self.hasZ = geometry.hasZ
        self.hasM = geometry.hasM
    }
    
    /// Attempts to unbox the `Geometry` with the given `CoordinateType`.
    /// - returns: `nil` if the boxed geometry does not have the given `CoordinateType`.
    public func asGeometry<T>() -> Geometry<T>? {
        return box.base as? Geometry<T>
    }
}
