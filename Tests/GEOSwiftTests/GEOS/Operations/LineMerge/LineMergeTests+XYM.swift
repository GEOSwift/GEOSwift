import XCTest
import GEOSwift

final class LineMergeTestsXYM: GEOSTestCase_XYM {
    func testLineMerge() {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XYM(0, 0, 1), XYM(1, 0, 4)]),
            LineString(coordinates: [XYM(1, 0, 2), XYM(0, 1, 5)]),
            LineString(coordinates: [XYM(0, 0, 3), XYM(2, 1, 6)])])

        let expectedLineString = try! LineString(coordinates: [
            XY(2, 1),
            XY(0, 0),
            XY(1, 0),
            XY(0, 1)])

        let expected = Geometry.lineString(expectedLineString)

        // Line merge drops M coordinates and produces XY geometry
        XCTAssertEqual(try multiLineString.lineMerge(), expected)
    }

    func testLineMergeDirected() {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XYM(0, 0, 1), XYM(1, 0, 4)]),
            LineString(coordinates: [XYM(1, 0, 2), XYM(0, 1, 5)]),
            LineString(coordinates: [XYM(0, 0, 3), XYM(2, 1, 6)])])

        let expectedMultiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XY(0, 0), XY(1, 0), XY(0, 1)]),
            LineString(coordinates: [XY(0, 0), XY(2, 1)])])

        let expected = Geometry.multiLineString(expectedMultiLineString)

        // Line merge drops M coordinates and produces XY geometry
        XCTAssertEqual(try multiLineString.lineMergeDirected(), expected)
    }
}
