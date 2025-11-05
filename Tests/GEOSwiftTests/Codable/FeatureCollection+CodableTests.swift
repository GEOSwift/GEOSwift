import XCTest
import GEOSwift

fileprivate extension FeatureCollection where C == XY {
    static let testPoint = Point(x: 1, y: 2)
    static let testPointJson = #"{"coordinates":[1,2],"type":"Point"}"#

    static let testFeatureWithNumberId = Feature(
        geometry: testPoint,
        properties: ["a": .string("b")],
        id: .number(0))
    static let testFeatureJsonWithNumberId = #"{"geometry":\#(testPointJson),"id":0,"properties"#
        + #"":{"a":"b"},"type":"Feature"}"#

    static let testFeatureWithNils = Feature<XY>(
        geometry: nil,
        properties: nil,
        id: nil)
    static let testFeatureJsonWithNils = #"{"geometry":null,"properties":null,"type":"#
        + #""Feature"}"#

    static let testValue = FeatureCollection(
        features: [testFeatureWithNumberId, testFeatureWithNils])
    static let testJson = #"{"features":[\#(testFeatureJsonWithNumberId),"#
        + #"\#(testFeatureJsonWithNils)],"type":"FeatureCollection"}"#
}

final class FeatureCollection_CodableTests: CodableTestCase {
    func testCodable() {
        verifyCodable(
            with: FeatureCollection.testValue,
            json: FeatureCollection.testJson)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: FeatureCollection<XY>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: FeatureCollection<XY>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
