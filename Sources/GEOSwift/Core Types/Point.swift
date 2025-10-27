public struct Point<C: CoordinateType>: Hashable, Sendable {
    /// The underlying ``CoordinateType`` (e.g. ``XY``)
    public var coordinates: C

    /// The x coordinate of the `Point`
    public var x: Double { get { coordinates.x } set { coordinates.x = newValue } }

    /// The y coordinate of the `Point`
    public var y: Double { get { coordinates.y } set { coordinates.y = newValue } }

    /// Initialize a `Point` from the given ``CoordinateType``.
    public init(_ coordinates: C) {
        self.coordinates = coordinates
    }
}

// MARK: Convenience Methods

public extension Point where C: HasZ {
    /// The z coordinate of the `Point`
    var z: Double { get { coordinates.z } set { coordinates.z = newValue } }
}

public extension Point where C: HasM {
    /// The m coordinate of the `Point`
    var m: Double { get { coordinates.m } set { coordinates.m = newValue } }
}

public extension Point where C == XY {
    /// Initialize a `Point<XY>` from the given x and y coordinates.
    /// - parameters:
    ///   - x: The *x* coordinate
    ///   - y: The *y* coordinate
    init(x: Double, y: Double) {
        self.init(XY(x, y))
    }

    /// Initialize a `Point<XY>` from another `Point`
    /// - parameters:
    ///   - point: The `Point` to copy coordinates from.
    init<D: CoordinateType>(_ point: Point<D>) {
        self.init(XY(point.coordinates))
    }
}

public extension Point where C == XYZ {
    /// Initialize a `Point<XYZ>` from the given x, y, and z coordinates.
    /// - parameters:
    ///   - x: The *x* coordinate
    ///   - y: The *y* coordinate
    ///   - z: The *z* coordinate
    init(x: Double, y: Double, z: Double) {
        self.init(XYZ(x, y, z))
    }

    /// Initialize a `Point<XYZ>` from another `Point`
    /// - parameters:
    ///   - point: The `Point` to copy coordinates from.
    init<D: CoordinateType & HasZ>(_ point: Point<D>) {
        self.init(XYZ(point.coordinates))
    }
}

public extension Point where C == XYZM {
    /// Initialize a `Point<XYZM>` from the given x, y, z, and m coordinates.
    /// - parameters:
    ///   - x: The *x* coordinate
    ///   - y: The *y* coordinate
    ///   - z: The *z* coordinate
    ///   - m: The *m* coordinate
    init(x: Double, y: Double, z: Double, m: Double) {
        self.init(XYZM(x, y, z, m))
    }

    /// Initialize a `Point<XYZM>` from another `Point`
    /// - parameters:
    ///   - point: The `Point` to copy coordinates from.
    init<D: CoordinateType & HasZ & HasM>(_ point: Point<D>) {
        self.init(XYZM(point.coordinates))
    }
}

public extension Point where C == XYM {
    /// Initialize a `Point<XYM>` from the given x, y, and m coordinates.
    /// - parameters:
    ///   - x: The *x* coordinate
    ///   - y: The *y* coordinate
    ///   - m: The *m* coordinate
    init(x: Double, y: Double, m: Double) {
        self.init(XYM(x, y, m))
    }

    /// Initialize a `Point<XYM>` from another `Point`
    /// - parameters:
    ///   - point: The `Point` to copy coordinates from.
    init<D: CoordinateType & HasM>(_ point: Point<D>) {
        self.init(XYM(point.coordinates))
    }
}
