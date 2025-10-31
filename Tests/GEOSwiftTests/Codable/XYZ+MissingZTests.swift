import XCTest
import GEOSwift

/// Tests for the geoJSONSetMissingZNan functionality that controls whether decoding
/// XYZ coordinates from GeoJSON without Z values throws an error or sets Z to NaN.
final class XYZ_MissingZTests: CodableTestCase {

    // MARK: - Point Tests

    func testPointXYZDecodingFromXYThrowsErrorByDefault() {
        let json = #"{"coordinates":[1,2],"type":"Point"}"#

        verifyDecodable(
            with: Point<XYZ>.self,
            json: json,
            expectedError: .invalidCoordinates)
    }

    func testPointXYZDecodingFromXYSetsNaNWhenFlagEnabled() {
        decoder.userInfo[.geoJSONSetMissingZNan] = true

        let json = #"{"coordinates":[1,2],"type":"Point"}"#
        let data = json.data(using: .utf8)!

        do {
            let point = try decoder.decode(Point<XYZ>.self, from: data)
            XCTAssertEqual(point.x, 1.0)
            XCTAssertEqual(point.y, 2.0)
            XCTAssertTrue(point.z.isNaN, "Z should be NaN when missing and flag is enabled")
        } catch {
            XCTFail("Decoding should succeed when geoJSONSetMissingZNan is true: \(error)")
        }
    }

    func testPointXYZDecodingFromXYZWorksWithoutFlag() {
        let json = #"{"coordinates":[1,2,3],"type":"Point"}"#
        let data = json.data(using: .utf8)!

        do {
            let point = try decoder.decode(Point<XYZ>.self, from: data)
            XCTAssertEqual(point.x, 1.0)
            XCTAssertEqual(point.y, 2.0)
            XCTAssertEqual(point.z, 3.0)
        } catch {
            XCTFail("Decoding XYZ coordinates should work without flag: \(error)")
        }
    }

    func testPointXYZDecodingFromXYZWorksWithFlag() {
        decoder.userInfo[.geoJSONSetMissingZNan] = true

        let json = #"{"coordinates":[1,2,3],"type":"Point"}"#
        let data = json.data(using: .utf8)!

        do {
            let point = try decoder.decode(Point<XYZ>.self, from: data)
            XCTAssertEqual(point.x, 1.0)
            XCTAssertEqual(point.y, 2.0)
            XCTAssertEqual(point.z, 3.0)
        } catch {
            XCTFail("Decoding XYZ coordinates should work with flag: \(error)")
        }
    }

    func testPointXYZDecodingFromXYZMWorksWithoutFlag() {
        let json = #"{"coordinates":[1,2,3,4],"type":"Point"}"#
        let data = json.data(using: .utf8)!

        do {
            let point = try decoder.decode(Point<XYZ>.self, from: data)
            XCTAssertEqual(point.x, 1.0)
            XCTAssertEqual(point.y, 2.0)
            XCTAssertEqual(point.z, 3.0)
        } catch {
            XCTFail("Decoding XYZ from XYZM coordinates should work: \(error)")
        }
    }

    func testPointXYZDecodingFromXYZMWorksWithFlag() {
        decoder.userInfo[.geoJSONSetMissingZNan] = true

        let json = #"{"coordinates":[1,2,3,4],"type":"Point"}"#
        let data = json.data(using: .utf8)!

        do {
            let point = try decoder.decode(Point<XYZ>.self, from: data)
            XCTAssertEqual(point.x, 1.0)
            XCTAssertEqual(point.y, 2.0)
            XCTAssertEqual(point.z, 3.0)
        } catch {
            XCTFail("Decoding XYZ from XYZM coordinates should work with flag: \(error)")
        }
    }

    // MARK: - LineString Tests

    func testLineStringXYZDecodingFromXYThrowsErrorByDefault() {
        let json = #"{"coordinates":[[1,2],[3,4]],"type":"LineString"}"#

        verifyDecodable(
            with: LineString<XYZ>.self,
            json: json,
            expectedError: .invalidCoordinates)
    }

    func testLineStringXYZDecodingFromXYSetsNaNWhenFlagEnabled() {
        decoder.userInfo[.geoJSONSetMissingZNan] = true

        let json = #"{"coordinates":[[1,2],[3,4]],"type":"LineString"}"#
        let data = json.data(using: .utf8)!

        do {
            let lineString = try decoder.decode(LineString<XYZ>.self, from: data)
            XCTAssertEqual(lineString.coordinates.count, 2)

            XCTAssertEqual(lineString.coordinates[0].x, 1.0)
            XCTAssertEqual(lineString.coordinates[0].y, 2.0)
            XCTAssertTrue(lineString.coordinates[0].z.isNaN, "Z should be NaN for first coordinate")

            XCTAssertEqual(lineString.coordinates[1].x, 3.0)
            XCTAssertEqual(lineString.coordinates[1].y, 4.0)
            XCTAssertTrue(lineString.coordinates[1].z.isNaN, "Z should be NaN for second coordinate")
        } catch {
            XCTFail("Decoding should succeed when geoJSONSetMissingZNan is true: \(error)")
        }
    }

    func testLineStringXYZDecodingFromXYZWorksWithoutFlag() {
        let json = #"{"coordinates":[[1,2,3],[4,5,6]],"type":"LineString"}"#
        let data = json.data(using: .utf8)!

        do {
            let lineString = try decoder.decode(LineString<XYZ>.self, from: data)
            XCTAssertEqual(lineString.coordinates.count, 2)
            XCTAssertEqual(lineString.coordinates[0].x, 1.0)
            XCTAssertEqual(lineString.coordinates[0].y, 2.0)
            XCTAssertEqual(lineString.coordinates[0].z, 3.0)
            XCTAssertEqual(lineString.coordinates[1].x, 4.0)
            XCTAssertEqual(lineString.coordinates[1].y, 5.0)
            XCTAssertEqual(lineString.coordinates[1].z, 6.0)
        } catch {
            XCTFail("Decoding XYZ coordinates should work without flag: \(error)")
        }
    }

    // MARK: - Polygon Tests

    func testPolygonXYZDecodingFromXYThrowsErrorByDefault() {
        let json = #"{"coordinates":[[[0,0],[4,0],[4,4],[0,4],[0,0]]],"type":"Polygon"}"#

        verifyDecodable(
            with: Polygon<XYZ>.self,
            json: json,
            expectedError: .invalidCoordinates)
    }

    func testPolygonXYZDecodingFromXYSetsNaNWhenFlagEnabled() {
        decoder.userInfo[.geoJSONSetMissingZNan] = true

        let json = #"{"coordinates":[[[0,0],[4,0],[4,4],[0,4],[0,0]]],"type":"Polygon"}"#
        let data = json.data(using: .utf8)!

        do {
            let polygon = try decoder.decode(Polygon<XYZ>.self, from: data)
            XCTAssertEqual(polygon.exterior.coordinates.count, 5)

            for (index, coord) in polygon.exterior.coordinates.enumerated() {
                XCTAssertTrue(coord.z.isNaN, "Z should be NaN for coordinate at index \(index)")
            }
        } catch {
            XCTFail("Decoding should succeed when geoJSONSetMissingZNan is true: \(error)")
        }
    }

    func testPolygonXYZDecodingFromXYZWorksWithoutFlag() {
        let json = #"{"coordinates":[[[0,0,1],[4,0,1],[4,4,1],[0,4,1],[0,0,1]]],"type":"Polygon"}"#
        let data = json.data(using: .utf8)!

        do {
            let polygon = try decoder.decode(Polygon<XYZ>.self, from: data)
            XCTAssertEqual(polygon.exterior.coordinates.count, 5)

            for coord in polygon.exterior.coordinates {
                XCTAssertEqual(coord.z, 1.0)
            }
        } catch {
            XCTFail("Decoding XYZ coordinates should work without flag: \(error)")
        }
    }

    // MARK: - MultiPoint Tests

    func testMultiPointXYZDecodingFromXYThrowsErrorByDefault() {
        let json = #"{"coordinates":[[1,2],[3,4]],"type":"MultiPoint"}"#

        verifyDecodable(
            with: MultiPoint<XYZ>.self,
            json: json,
            expectedError: .invalidCoordinates)
    }

    func testMultiPointXYZDecodingFromXYSetsNaNWhenFlagEnabled() {
        decoder.userInfo[.geoJSONSetMissingZNan] = true

        let json = #"{"coordinates":[[1,2],[3,4]],"type":"MultiPoint"}"#
        let data = json.data(using: .utf8)!

        do {
            let multiPoint = try decoder.decode(MultiPoint<XYZ>.self, from: data)
            XCTAssertEqual(multiPoint.points.count, 2)

            XCTAssertEqual(multiPoint.points[0].x, 1.0)
            XCTAssertEqual(multiPoint.points[0].y, 2.0)
            XCTAssertTrue(multiPoint.points[0].z.isNaN)

            XCTAssertEqual(multiPoint.points[1].x, 3.0)
            XCTAssertEqual(multiPoint.points[1].y, 4.0)
            XCTAssertTrue(multiPoint.points[1].z.isNaN)
        } catch {
            XCTFail("Decoding should succeed when geoJSONSetMissingZNan is true: \(error)")
        }
    }

    // MARK: - Flag Value Tests

    func testFlagSetToFalseThrowsError() {
        decoder.userInfo[.geoJSONSetMissingZNan] = false

        let json = #"{"coordinates":[1,2],"type":"Point"}"#

        verifyDecodable(
            with: Point<XYZ>.self,
            json: json,
            expectedError: .invalidCoordinates)
    }

    func testFlagWithNonBoolValueUsesDefaultBehavior() {
        decoder.userInfo[.geoJSONSetMissingZNan] = "true" // String instead of Bool

        let json = #"{"coordinates":[1,2],"type":"Point"}"#

        verifyDecodable(
            with: Point<XYZ>.self,
            json: json,
            expectedError: .invalidCoordinates)
    }

    // MARK: - Mixed Coordinates Test

    func testLineStringWithMixedXYAndXYZCoordinatesWhenFlagEnabled() {
        decoder.userInfo[.geoJSONSetMissingZNan] = true

        // This tests that we can handle a linestring where some points have Z and others don't
        // when the flag is enabled
        let json = #"{"coordinates":[[1,2],[3,4,5]],"type":"LineString"}"#
        let data = json.data(using: .utf8)!

        do {
            let lineString = try decoder.decode(LineString<XYZ>.self, from: data)
            XCTAssertEqual(lineString.coordinates.count, 2)

            // First point should have NaN for Z
            XCTAssertEqual(lineString.coordinates[0].x, 1.0)
            XCTAssertEqual(lineString.coordinates[0].y, 2.0)
            XCTAssertTrue(lineString.coordinates[0].z.isNaN)

            // Second point should have actual Z value
            XCTAssertEqual(lineString.coordinates[1].x, 3.0)
            XCTAssertEqual(lineString.coordinates[1].y, 4.0)
            XCTAssertEqual(lineString.coordinates[1].z, 5.0)
        } catch {
            XCTFail("Decoding mixed coordinates should work with flag: \(error)")
        }
    }
}
