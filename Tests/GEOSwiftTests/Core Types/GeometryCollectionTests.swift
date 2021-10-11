import XCTest
import GEOSwift

final class GeometryCollectionTests: XCTestCase {
    func testInitWithGeometries() {
        let geometries = makeGeometries(withTypes: [.point, .geometryCollection, .multiLineString])

        let collection = GeometryCollection(geometries: geometries)

        XCTAssertEqual(collection.geometries, geometries)
    }
}
