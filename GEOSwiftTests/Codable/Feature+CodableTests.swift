import XCTest
import GEOSwift

extension Feature {
    static let testValueWithNumberId = Feature(
        geometry: Point.testValue1,
        properties: ["a": .string("b")],
        id: .number(0))
    static let testJsonWithNumberId = #"{"geometry":\#(Point.testJson1),"id":0,"properties"#
        + #"":{"a":"b"},"type":"Feature"}"#
    static let testValueWithStringId = Feature(
        geometry: Point.testValue1,
        properties: ["a": .string("b")],
        id: .string("a"))
    static let testJsonWithStringId = #"{"geometry":\#(Point.testJson1),"id":"a","properties"#
        + #"":{"a":"b"},"type":"Feature"}"#
    static let testValueWithNils = Feature(
        geometry: nil,
        properties: nil,
        id: nil)
    static let testJsonWithNils = #"{"geometry":null,"properties":null,"type":"#
        + #""Feature"}"#
}

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
final class Feature_CodableTests: CodableTestCase {
    func testCodableWithNumberId() {
        verifyCodable(
            with: Feature.testValueWithNumberId,
            json: Feature.testJsonWithNumberId)
    }

    func testCodableWithStringId() {
        verifyCodable(
            with: Feature.testValueWithStringId,
            json: Feature.testJsonWithStringId)
    }

    func testCodableWithNils() {
        verifyCodable(
            with: Feature.testValueWithNils,
            json: Feature.testJsonWithNils)
    }

    func testDecodableThrowsWithInvalidFeatureId() {
        let json = #"{"id":[],"geometry":null,"properties":null,"type":"Feature"}"#

        verifyDecodable(with: Feature.self, json: json, expectedError: .invalidFeatureId)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: Feature.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: Feature.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
