import XCTest
import GEOSwift

final class FeatureTests: XCTestCase {
    func testInitWithGeometryPropertiesId() {
        let geometry = Geometry.point(Point(x: 0, y: 0))
        let properties = ["a": JSON.string("b")]
        let id = Feature.FeatureId.number(2)

        let feature = Feature(geometry: geometry, properties: properties, id: id)

        XCTAssertEqual(feature.geometry, geometry)
        XCTAssertEqual(feature.properties, properties)
        XCTAssertEqual(feature.id, id)
    }
}
