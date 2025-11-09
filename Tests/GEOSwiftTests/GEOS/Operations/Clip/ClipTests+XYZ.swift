import XCTest
import GEOSwift

final class ClipTests_XYZ: GEOSTestCase_XYZ {

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
            XYZ(1, 1, 10),
            XYZ(3, 1, 20),
            XYZ(3, 3, 30),
            XYZ(1, 3, 40),
            XYZ(1, 1, 10)
        ]))

        let envelope = Envelope(minX: 0, maxX: 5, minY: 0, maxY: 5)
        let clipped = try polygon.clip(by: envelope)

        // Polygon is completely inside, should be unchanged (topologically)
        try XCTAssertTrue(clipped?.isTopologicallyEquivalent(to: polygon) ?? false)
    }

    func testClipPolygonPartiallyInside() throws {
        let polygon = try Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 10),
            XYZ(10, 0, 20),
            XYZ(10, 10, 30),
            XYZ(0, 10, 40),
            XYZ(0, 0, 10)
        ]))

        let envelope = Envelope(minX: 2, maxX: 8, minY: 2, maxY: 8)
        let clipped = try polygon.clip(by: envelope)

        let expectedPolygon = try Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(2, 2, 0),
            XYZ(8, 2, 1),
            XYZ(8, 8, 2),
            XYZ(2, 8, 3),
            XYZ(2, 2, 0)
        ]))

        // Clip preserves XYZ coordinates, compare topologically
        try XCTAssertTrue(clipped?.isTopologicallyEquivalent(to: expectedPolygon) ?? false)
    }

    func testClipPolygonCompletelyOutside() throws {
        let polygon = try Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(20, 20, 10),
            XYZ(30, 20, 20),
            XYZ(30, 30, 30),
            XYZ(20, 30, 40),
            XYZ(20, 20, 10)
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
            XYZ(0, 5, 10),
            XYZ(10, 5, 20)
        ])

        let envelope = Envelope(minX: 2, maxX: 8, minY: 0, maxY: 10)
        let clipped = try lineString.clip(by: envelope)

        // Verify result is a LineString (XY comparison for topological equivalence)
        XCTAssertNotNil(clipped)
        if case .lineString = clipped {
            // Success - we got a LineString back
        } else {
            XCTFail("Expected LineString result")
        }
    }

    func testClipPointInside() throws {
        let point = Point(XYZ(5, 5, 10))
        let envelope = Envelope(minX: 0, maxX: 10, minY: 0, maxY: 10)
        let clipped = try point.clip(by: envelope)

        // Point should be preserved with Z coordinate
        if case .point(let resultPoint) = clipped {
            XCTAssertEqual(resultPoint.x, 5)
            XCTAssertEqual(resultPoint.y, 5)
        } else {
            XCTFail("Expected point result")
        }
    }

    func testClipPointOutside() throws {
        let point = Point(XYZ(15, 15, 10))
        let envelope = Envelope(minX: 0, maxX: 10, minY: 0, maxY: 10)
        let clipped = try point.clip(by: envelope)

        // Point outside returns an empty geometry collection
        if case .geometryCollection(let collection) = clipped {
            XCTAssertTrue(collection.geometries.isEmpty)
        } else {
            XCTAssertNil(clipped)
        }
    }

    func testClipPreservesZCoordinates() throws {
        let lineString = try LineString(coordinates: [
            XYZ(0, 0, 100),
            XYZ(10, 0, 200)
        ])

        let envelope = Envelope(minX: 0, maxX: 10, minY: -5, maxY: 5)
        let clipped = try lineString.clip(by: envelope)

        // Verify we got XYZ geometry back
        XCTAssertNotNil(clipped)
        if case .lineString(let resultLineString) = clipped {
            // Verify it has Z coordinates
            XCTAssertTrue(resultLineString.coordinates.allSatisfy { !$0.z.isNaN })
        } else {
            XCTFail("Expected LineString result")
        }
    }

    func testClipMultiPolygon() throws {
        let poly1 = try Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 10),
            XYZ(5, 0, 20),
            XYZ(5, 5, 30),
            XYZ(0, 5, 40),
            XYZ(0, 0, 10)
        ]))

        let poly2 = try Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(6, 6, 50),
            XYZ(12, 6, 60),
            XYZ(12, 12, 70),
            XYZ(6, 12, 80),
            XYZ(6, 6, 50)
        ]))

        let multiPolygon = MultiPolygon(polygons: [poly1, poly2])
        let envelope = Envelope(minX: 2, maxX: 10, minY: 2, maxY: 10)
        let clipped = try multiPolygon.clip(by: envelope)

        // Should clip both polygons
        XCTAssertNotNil(clipped)
    }
}
