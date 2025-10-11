public struct Point<C: CoordinateType>: Hashable, Sendable {
    public var coordinates: C

    public var x: Double { get { coordinates.x } set { coordinates.x = newValue } }
    public var y: Double { get { coordinates.y } set { coordinates.y = newValue } }

    // TODO: Decide if this initializer is needed. There already exist similar for `CodableGeometry` support but the `coordinates:` label is a bit unwieldy for a point
    public init(_ coordinates: C) {
        self.coordinates = coordinates
    }
}

// MARK: Convenience Methods

public extension Point where C == XY {
    init(x: Double, y: Double) {
        self.init(XY(x, y))
    }
}

public extension Point where C == XYZ {
    var z: Double { get { coordinates.z } set { coordinates.z = newValue } }
    
    init(x: Double, y: Double, z: Double) {
        self.init(XYZ(x, y, z))
    }
}

public extension Point where C == XYZM {
    var z: Double { get { coordinates.z } set { coordinates.z = newValue } }
    var m: Double { get { coordinates.m } set { coordinates.m = newValue } }

    init(x: Double, y: Double, z: Double, m: Double) {
        self.init(XYZM(x, y, z, m))
    }
}

public extension Point where C == XYM {
    var m: Double { get { coordinates.m } set { coordinates.m = newValue } }

    init(x: Double, y: Double, m: Double) {
        self.init(XYM(x, y, m))
    }
}
