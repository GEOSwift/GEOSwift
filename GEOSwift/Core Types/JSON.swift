import Foundation

public enum JSON: Hashable {
    case string(String)
    case number(Double)
    case boolean(Bool)
    case array([JSON])
    case object([String: JSON])
    case null

    /// Recursively unwraps and returns the associated value
    public var untypedValue: Any {
        switch self {
        case let .string(string):
            return string
        case let .number(number):
            return number
        case let .boolean(boolean):
            return boolean
        case let .array(array):
            return array.map { $0.untypedValue }
        case let .object(object):
            return object.mapValues { $0.untypedValue }
        case .null:
            return NSNull()
        }
    }
}

extension JSON: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension JSON: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .number(Double(value))
    }
}

extension JSON: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .number(value)
    }
}

extension JSON: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .boolean(value)
    }
}

extension JSON: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: JSON...) {
        self = .array(elements)
    }
}

extension JSON: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, JSON)...) {
        let object = elements.reduce(into: [:]) { (result, element) in
            result[element.0] = element.1
        }
        self = .object(object)
    }
}

extension JSON: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .null
    }
}
