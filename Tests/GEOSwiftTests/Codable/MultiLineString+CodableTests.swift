import XCTest
import GEOSwift

extension MultiLineString where C == XY {
    static let testValue = MultiLineString(
        lineStrings: [.testValue1, .testValue5])
    static let testJson = #"{"coordinates":[[[1,2],[3,4]],[[5,6],[7,8]]],"type"#
        + #"":"MultiLineString"}"#
}

fileprivate extension MultiLineString where C == XYZ {
    static let testValue = MultiLineString(
        lineStrings: [
            try! LineString(points: [Point(x: 1, y: 2, z: 3), Point(x: 4, y: 5, z: 6)]),
            try! LineString(points: [Point(x: 7, y: 8, z: 9), Point(x: 10, y: 11, z: 12)])
        ])
    static let testJson = #"{"coordinates":[[[1,2,3],[4,5,6]],[[7,8,9],[10,11,12]]],"type"#
        + #"":"MultiLineString"}"#
}

final class MultiLineString_CodableTestsXY: CodableTestCase {
    func testCodable() {
        verifyCodable(
            with: MultiLineString<XY>.testValue,
            json: MultiLineString<XY>.testJson)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: MultiLineString<XY>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: MultiLineString<XY>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}

final class MultiLineString_CodableTestsXYZ: CodableTestCase {
    func testCodable() {
        verifyCodable(
            with: MultiLineString<XYZ>.testValue,
            json: MultiLineString<XYZ>.testJson)
    }

    func testDecodableThrowsWithTypeMismatch() {
        let json = #"{"coordinates":[1],"type":"Point"}"#

        verifyDecodable(with: MultiLineString<XYZ>.self, json: json, expectedError: .mismatchedGeoJSONType)
    }

    func testDecodableThrowsWithInvalidType() {
        let json = #"{"coordinates":[1],"type":"p"}"#

        verifyDecodable(with: MultiLineString<XYZ>.self, json: json, expectedError: .invalidGeoJSONType)
    }
}
