import XCTest
import GEOSwift

final class LineMergeTests: GEOSTestCase_XY {
    func testLineMerge() {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XY(0, 0), XY(1, 0)]),
            LineString(coordinates: [XY(1, 0), XY(0, 1)]),
            LineString(coordinates: [XY(0, 0), XY(2, 1)])])

        let expectedLineString = try! LineString(coordinates: [
            XY(2, 1),
            XY(0, 0),
            XY(1, 0),
            XY(0, 1)])

        XCTAssertEqual(try multiLineString.lineMerge(), .lineString(expectedLineString))
    }

    func testLineMergeDirected() {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XY(0, 0), XY(1, 0)]),
            LineString(coordinates: [XY(1, 0), XY(0, 1)]),
            LineString(coordinates: [XY(0, 0), XY(2, 1)])])

        let expectedMultiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XY(0, 0), XY(1, 0), XY(0, 1)]),
            LineString(coordinates: [XY(0, 0), XY(2, 1)])])

        XCTAssertEqual(try multiLineString.lineMergeDirected(), .multiLineString(expectedMultiLineString))
    }
}
