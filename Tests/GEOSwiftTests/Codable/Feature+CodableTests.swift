import XCTest
import GEOSwift

fileprivate extension Feature where C == XY {
    static let testPoint = Point(x: 1, y: 2)
    static let testPointJson = #"{"coordinates":[1,2],"type":"Point"}"#

    static let testValueWithNumberId = Feature(
        geometry: testPoint,
        properties: ["a": .string("b")],
        id: .number(0))
    static let testJsonWithNumberId = #"{"geometry":\#(testPointJson),"id":0,"properties"#
        + #"":{"a":"b"},"type":"Feature"}"#
    static let testValueWithStringId = Feature(
        geometry: testPoint,
        properties: ["a": .string("b")],
        id: .string("a"))
    static let testJsonWithStringId = #"{"geometry":\#(testPointJson),"id":"a","properties"#
        + #"":{"a":"b"},"type":"Feature"}"#
    static let testValueWithNils = Feature(
        geometry: nil,
        properties: nil,
        id: nil)
    static let testJsonWithNils = #"{"geometry":null,"properties":null,"type":"#
        + #""Feature"}"#
}

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

        verifyDecodable(with: Feature<XY>.self, json: json, expectedError: .invalidFeatureId)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: Feature<XY>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: Feature<XY>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
