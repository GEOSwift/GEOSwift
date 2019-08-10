public struct Feature: Hashable {
    public var geometry: Geometry?
    public var properties: [String: JSON]?
    public var id: FeatureId?

    public init(geometry: Geometry? = nil, properties: [String: JSON]? = nil, id: FeatureId? = nil) {
        self.geometry = geometry
        self.properties = properties
        self.id = id
    }

    /// Returns properties as a type that can be bridged to NSDictionary for use with NSCoding,
    /// NSJSONSerialization, etc.
    public var untypedProperties: [String: Any]? {
        return properties?.mapValues { $0.untypedValue }
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
