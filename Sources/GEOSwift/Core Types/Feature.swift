public struct Feature<C: CoordinateType>: Hashable, Sendable {
    public var geometry: Geometry<C>?
    public var properties: [String: JSON]?
    public var id: FeatureId?

    public init(
        geometry: (any GeometryConvertible<C>)? = nil,
        properties: [String: JSON]? = nil,
        id: FeatureId? = nil
    ) {
        self.geometry = geometry?.geometry
        self.properties = properties
        self.id = id
    }

    /// Returns properties as a type that can be bridged to NSDictionary for use with NSCoding,
    /// NSJSONSerialization, etc.
    public var untypedProperties: [String: Any]? {
        properties?.mapValues { $0.untypedValue }
    }
}

// Need to unnest FeatureId from Feature to avoid making it needlessly generic
public enum FeatureId: Hashable, Sendable {
    case string(String)
    case number(Double)
}

extension FeatureId: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension FeatureId: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .number(Double(value))
    }
}

extension FeatureId: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .number(value)
    }
}
