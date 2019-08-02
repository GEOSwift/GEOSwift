public struct MultiLineString: Hashable {
    public var lineStrings: [LineString]

    public init(lineStrings: [LineString]) {
        self.lineStrings = lineStrings
    }
}
