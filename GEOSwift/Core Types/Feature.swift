public struct Feature: Hashable {
    public var geometry: Geometry?
    public var properties: [String: JSON]?
    public var id: FeatureId?

    public init(geometry: Geometry?, properties: [String: JSON]?, id: FeatureId?) {
        self.geometry = geometry
        self.properties = properties
        self.id = id
    }

    // MARK: - Id

    public enum FeatureId: Hashable {
        case string(String)
        case number(Double)
    }
}

extension Feature.FeatureId: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension Feature.FeatureId: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .number(Double(value))
    }
}

extension Feature.FeatureId: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .number(value)
    }
}
