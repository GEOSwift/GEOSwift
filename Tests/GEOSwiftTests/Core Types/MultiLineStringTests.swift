import XCTest
import GEOSwift

final class MultiLineStringTests: XCTestCase {
    func testInitWithLineStrings() {
        let lineStrings = makeLineStrings(withCount: 3)

        let multiLineString = MultiLineString(lineStrings: lineStrings)

        XCTAssertEqual(multiLineString.lineStrings, lineStrings)
    }
}
