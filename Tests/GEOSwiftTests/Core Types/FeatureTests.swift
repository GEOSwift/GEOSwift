import XCTest
import GEOSwift

final class Feature_FeatureIdTests: XCTestCase {
    func testInitWithStringLiteral() {
        let featureId: Feature.FeatureId = "test"

        XCTAssertEqual(featureId, .string("test"))
    }

    func testInitWithIntegerLiteral() {
        let featureId: Feature.FeatureId = 1

        XCTAssertEqual(featureId, .number(1))
    }

    func testInitWithFloatLiteral() {
        let featureId: Feature.FeatureId = 2.0

        XCTAssertEqual(featureId, .number(2))
    }
}

final class FeatureTests: XCTestCase {
    func testInitWithGeometryPropertiesId() {
        let geometry = Geometry.point(Point(x: 0, y: 0))
        let properties: [String: JSON] = ["a": "b"]
        let id: Feature.FeatureId = 2

        let feature = Feature(geometry: geometry, properties: properties, id: id)

        XCTAssertEqual(feature.geometry, geometry)
        XCTAssertEqual(feature.properties, properties)
        XCTAssertEqual(feature.id, id)
    }

    func testInitWithDefaultValues() {
        let feature = Feature()

        XCTAssertNil(feature.geometry)
        XCTAssertNil(feature.properties)
        XCTAssertNil(feature.id)
    }

    func testUntypedProperties() {
        let feature = Feature(properties: [
            "a": ["y"],
            "b": true,
            "n": 1,
            "null": nil,
            "s": "x",
            "o": ["x": 123, "y": false, "z": nil]])

        let untypedProperties = feature.untypedProperties! as NSDictionary

        let expected: NSDictionary = [
            "a": ["y"],
            "b": true,
            "n": 1,
            "null": NSNull(),
            "s": "x",
            "o": ["x": 123, "y": false, "z": NSNull()]]
        XCTAssertEqual(untypedProperties, expected)
    }
}
