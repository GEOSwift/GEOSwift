public struct MultiLineStringZ: Hashable {
    public var lineStrings: [LineStringZ]

    public init(lineStrings: [LineStringZ]) {
        self.lineStrings = lineStrings
    }
}
