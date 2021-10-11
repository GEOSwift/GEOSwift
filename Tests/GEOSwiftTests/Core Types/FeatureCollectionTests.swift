import XCTest
import GEOSwift

final class FeatureCollectionTests: XCTestCase {
    func testInitWithFeatures() {
        let features = makeFeatures(withCount: 3)

        let featureCollection = FeatureCollection(features: features)

        XCTAssertEqual(featureCollection.features, features)
    }
}
