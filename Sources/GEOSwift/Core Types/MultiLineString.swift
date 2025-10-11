public struct MultiLineString<C: CoordinateType>: Hashable, Sendable {
    public var lineStrings: [LineString<C>]

    public init(lineStrings: [LineString<C>]) {
        self.lineStrings = lineStrings
    }
}
