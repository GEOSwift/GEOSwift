import XCTest
import GEOSwift

final class LineMergeTestsXYZM: GEOSTestCase_XYZM {
    func testLineMerge() {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XYZM(0, 0, 1, 1), XYZM(1, 0, 4, 4)]),
            LineString(coordinates: [XYZM(1, 0, 2, 2), XYZM(0, 1, 5, 5)]),
            LineString(coordinates: [XYZM(0, 0, 3, 3), XYZM(2, 1, 6, 6)])])

        let expectedLineString = try! LineString(coordinates: [
            XYZ(2, 1, 6),
            XYZ(0, 0, 1),  // GEOS uses Z from first occurrence at (0,0)
            XYZ(1, 0, 2),
            XYZ(0, 1, 5)])

        let expected = Geometry.lineString(expectedLineString)

        // Line merge preserves Z coordinates but drops M for XYZM geometry
        XCTAssertEqual(try multiLineString.lineMerge(), expected)
    }

    func testLineMergeDirected() {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XYZM(0, 0, 1, 1), XYZM(1, 0, 4, 4)]),
            LineString(coordinates: [XYZM(1, 0, 2, 2), XYZM(0, 1, 5, 5)]),
            LineString(coordinates: [XYZM(0, 0, 3, 3), XYZM(2, 1, 6, 6)])])

        let expectedMultiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XYZ(0, 0, 1), XYZ(1, 0, 4), XYZ(0, 1, 5)]),
            LineString(coordinates: [XYZ(0, 0, 3), XYZ(2, 1, 6)])])

        let expected = Geometry.multiLineString(expectedMultiLineString)

        // Line merge preserves Z coordinates but drops M for XYZM geometry
        XCTAssertEqual(try multiLineString.lineMergeDirected(), expected)
    }

    func testLineMergePreservesZ() throws {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XYZM(0, 0, 10, 1), XYZM(1, 0, 20, 2)]),
            LineString(coordinates: [XYZM(1, 0, 20, 2), XYZM(2, 0, 30, 3)]),
            LineString(coordinates: [XYZM(2, 0, 30, 3), XYZM(3, 0, 40, 4)])])

        let result = try multiLineString.lineMerge()

        switch result {
        case let .lineString(lineString):
            for coord in lineString.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        case let .multiLineString(multiLineString):
            for lineString in multiLineString.lineStrings {
                for coord in lineString.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            }
        default:
            XCTFail("Expected LineString or MultiLineString result")
        }
    }

    func testLineMergeDirectedPreservesZ() throws {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XYZM(0, 0, 10, 1), XYZM(1, 0, 20, 2)]),
            LineString(coordinates: [XYZM(1, 0, 20, 2), XYZM(2, 0, 30, 3)]),
            LineString(coordinates: [XYZM(2, 0, 30, 3), XYZM(3, 0, 40, 4)])])

        let result = try multiLineString.lineMergeDirected()

        switch result {
        case let .lineString(lineString):
            for coord in lineString.coordinates {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        case let .multiLineString(multiLineString):
            for lineString in multiLineString.lineStrings {
                for coord in lineString.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            }
        default:
            XCTFail("Expected LineString or MultiLineString result")
        }
    }

    func testLineMergeZCoordinateValues() throws {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XYZM(0, 0, 10, 1), XYZM(1, 0, 20, 2)]),
            LineString(coordinates: [XYZM(1, 0, 20, 2), XYZM(2, 0, 30, 3)])])

        let result = try multiLineString.lineMerge()

        switch result {
        case let .lineString(lineString):
            // Verify Z coordinates are preserved correctly (M dropped)
            XCTAssertEqual(lineString.coordinates.count, 3)
            XCTAssertEqual(lineString.coordinates[0].z, 10, accuracy: 0.001)
            XCTAssertEqual(lineString.coordinates[1].z, 20, accuracy: 0.001)
            XCTAssertEqual(lineString.coordinates[2].z, 30, accuracy: 0.001)
        default:
            XCTFail("Expected LineString result")
        }
    }

    func testLineMergeDirectedZCoordinateValues() throws {
        let multiLineString = try! MultiLineString(lineStrings: [
            LineString(coordinates: [XYZM(0, 0, 10, 1), XYZM(1, 0, 20, 2)]),
            LineString(coordinates: [XYZM(1, 0, 20, 2), XYZM(2, 0, 30, 3)])])

        let result = try multiLineString.lineMergeDirected()

        switch result {
        case let .lineString(lineString):
            // Verify Z coordinates are preserved correctly (M dropped)
            XCTAssertEqual(lineString.coordinates.count, 3)
            XCTAssertEqual(lineString.coordinates[0].z, 10, accuracy: 0.001)
            XCTAssertEqual(lineString.coordinates[1].z, 20, accuracy: 0.001)
            XCTAssertEqual(lineString.coordinates[2].z, 30, accuracy: 0.001)
        default:
            XCTFail("Expected LineString result")
        }
    }
}
