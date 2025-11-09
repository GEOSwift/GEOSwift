import XCTest
import GEOSwift

final class ClipTests: GEOSTestCase_XY {

    func testClipAllTypes() {
        let envelope = Envelope(minX: 0, maxX: 5, minY: 0, maxY: 5)
        for geometry in geometryConvertibles {
            do {
                _ = try geometry.clip(by: envelope)
            } catch {
                XCTFail("Unexpected error for \(geometry) clip(by: envelope) \(error)")
            }
        }
    }

    func testClipPolygonCompletelyInside() throws {
        let polygon = try Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(1, 1),
            XY(3, 1),
            XY(3, 3),
            XY(1, 3),
            XY(1, 1)
        ]))

        let envelope = Envelope(minX: 0, maxX: 5, minY: 0, maxY: 5)
        let clipped = try polygon.clip(by: envelope)

        // Polygon is completely inside, should be unchanged
        try XCTAssertTrue(clipped?.isTopologicallyEquivalent(to: polygon) ?? false)
    }

    func testClipPolygonPartiallyInside() throws {
        let polygon = try Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 0),
            XY(10, 0),
            XY(10, 10),
            XY(0, 10),
            XY(0, 0)
        ]))

        let envelope = Envelope(minX: 2, maxX: 8, minY: 2, maxY: 8)
        let clipped = try polygon.clip(by: envelope)

        let expectedPolygon = try Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(2, 2),
            XY(8, 2),
            XY(8, 8),
            XY(2, 8),
            XY(2, 2)
        ]))

        try XCTAssertTrue(clipped?.isTopologicallyEquivalent(to: expectedPolygon) ?? false)
    }

    func testClipPolygonCompletelyOutside() throws {
        let polygon = try Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(20, 20),
            XY(30, 20),
            XY(30, 30),
            XY(20, 30),
            XY(20, 20)
        ]))

        let envelope = Envelope(minX: 0, maxX: 10, minY: 0, maxY: 10)
        let clipped = try polygon.clip(by: envelope)

        // Polygon is completely outside, GEOS returns an empty geometry collection
        if case .geometryCollection(let collection) = clipped {
            XCTAssertTrue(collection.geometries.isEmpty)
        } else {
            XCTAssertNil(clipped)
        }
    }

    func testClipLineStringPartiallyInside() throws {
        let lineString = try LineString(coordinates: [
            XY(0, 5),
            XY(10, 5)
        ])

        let envelope = Envelope(minX: 2, maxX: 8, minY: 0, maxY: 10)
        let clipped = try lineString.clip(by: envelope)

        let expectedLineString = try LineString(coordinates: [
            XY(2, 5),
            XY(8, 5)
        ])

        XCTAssertEqual(clipped, .lineString(expectedLineString))
    }

    func testClipPointInside() throws {
        let point = Point(XY(5, 5))
        let envelope = Envelope(minX: 0, maxX: 10, minY: 0, maxY: 10)
        let clipped = try point.clip(by: envelope)

        XCTAssertEqual(clipped, .point(point))
    }

    func testClipPointOutside() throws {
        let point = Point(XY(15, 15))
        let envelope = Envelope(minX: 0, maxX: 10, minY: 0, maxY: 10)
        let clipped = try point.clip(by: envelope)

        // Point outside returns an empty geometry collection
        if case .geometryCollection(let collection) = clipped {
            XCTAssertTrue(collection.geometries.isEmpty)
        } else {
            XCTAssertNil(clipped)
        }
    }

    func testClipWithZeroAreaEnvelope() throws {
        let polygon = try Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 0),
            XY(10, 0),
            XY(10, 10),
            XY(0, 10),
            XY(0, 0)
        ]))

        // Envelope is a line (zero width) - GEOS throws an error
        let envelope = Envelope(minX: 5, maxX: 5, minY: 0, maxY: 10)

        XCTAssertThrowsError(try polygon.clip(by: envelope)) { error in
            // Verify it's the expected error from GEOS
            if case GEOSError.libraryError = error {
                // Expected error
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        }
    }

    func testClipMultiPolygon() throws {
        let poly1 = try Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(0, 0),
            XY(5, 0),
            XY(5, 5),
            XY(0, 5),
            XY(0, 0)
        ]))

        let poly2 = try Polygon(exterior: Polygon.LinearRing(coordinates: [
            XY(6, 6),
            XY(12, 6),
            XY(12, 12),
            XY(6, 12),
            XY(6, 6)
        ]))

        let multiPolygon = MultiPolygon(polygons: [poly1, poly2])
        let envelope = Envelope(minX: 2, maxX: 10, minY: 2, maxY: 10)
        let clipped = try multiPolygon.clip(by: envelope)

        // Should clip both polygons
        XCTAssertNotNil(clipped)
    }
}
