import Foundation

/// This is for internal use only, though it must be public as part of the `CoordinateType` protocol. It hides
/// the bridge to the GEOS coordinate sequence.
public struct GeosCoordinateBridge<C: CoordinateType> {
    typealias Getter = (_ context: GEOSContext, _ cSequence: OpaquePointer, _ idx: Int32) throws -> C
    typealias Setter = (_ context: GEOSContext, _ cSequence: OpaquePointer, _ idx: Int32, _ newValue: C) throws -> Void
    
    internal let getter: Getter
    internal let setter: Setter
    
    internal init(getter: @escaping Getter, setter: @escaping Setter) {
        self.getter = getter
        self.setter = setter
    }
}
