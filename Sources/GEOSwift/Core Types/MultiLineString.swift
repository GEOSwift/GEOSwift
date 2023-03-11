public struct MultiLineString: Hashable, Sendable {
    public var lineStrings: [LineString]

    public init(lineStrings: [LineString]) {
        self.lineStrings = lineStrings
    }
}
