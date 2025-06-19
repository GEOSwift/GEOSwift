public struct Point: Hashable, Sendable {
    public var x: Double
    public var y: Double
    public var z: Double?

    public init(x: Double, y: Double, z: Double? = nil) {
        self.x = x
        self.y = y
        self.z = z
    }
}
