/// A GeoJSON Feature representing a spatially bounded entity with optional properties and identifier.
///
/// The underlying ``CoordinateType`` (e.g. ``XY``, ``XYZ``) determines the dimensionality of the geometry.
public struct Feature<C: CoordinateType>: Hashable, Sendable {
    /// The optional ``Geometry`` of the feature
    public var geometry: Geometry<C>?

    /// The optional properties dictionary
    public var properties: [String: JSON]?

    /// The optional feature identifier
    public var id: FeatureId?

    /// Initialize a `Feature` with optional geometry, properties, and identifier.
    /// - parameters:
    ///   - geometry: An optional value conforming to ``GeometryConvertible``.
    ///   - properties: An optional dictionary of properties.
    ///   - id: An optional ``FeatureId``.
    public init(
        geometry: (any GeometryConvertible<C>)? = nil,
        properties: [String: JSON]? = nil,
        id: FeatureId? = nil
    ) {
        self.geometry = geometry?.geometry
        self.properties = properties
        self.id = id
    }

    /// The properties dictionary as untyped values that can be bridged to `NSDictionary` for use with
    /// `NSCoding`, `NSJSONSerialization`, etc.
    public var untypedProperties: [String: Any]? {
        properties?.mapValues { $0.untypedValue }
    }
}

/// A GeoJSON Feature identifier that can be either a string or a number.
public enum FeatureId: Hashable, Sendable {
    /// A string identifier
    case string(String)
    /// A numeric identifier
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
