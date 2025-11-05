import XCTest
import GEOSwift

// MARK: - Tests

final class ValidityTests_XYZ: XCTestCase {
    // Convert XYZM fixtures to XYZ using copy constructors
    let point1 = Point<XYZ>(Fixtures.point1)
    let lineString1 = LineString<XYZ>(Fixtures.lineString1)
    let linearRingHole1 = Polygon<XYZ>.LinearRing(Fixtures.linearRingHole1)
    let polygonWithHole = Polygon<XYZ>(Fixtures.polygonWithHole)
    let multiPoint = MultiPoint<XYZ>(Fixtures.multiPoint)
    let multiLineString = MultiLineString<XYZ>(Fixtures.multiLineString)
    let multiPolygon = MultiPolygon<XYZ>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XYZ>(Fixtures.geometryCollection)
    let recursiveGeometryCollection = GeometryCollection<XYZ>(Fixtures.recursiveGeometryCollection)

    // Geometry convertibles array needs to be converted element-by-element
    lazy var geometryConvertibles: [any GeometryConvertible<XYZ>] = [
        point1,
        Geometry.point(point1),
        multiPoint,
        Geometry.multiPoint(multiPoint),
        lineString1,
        Geometry.lineString(lineString1),
        multiLineString,
        Geometry.multiLineString(multiLineString),
        linearRingHole1,
        polygonWithHole,
        Geometry.polygon(polygonWithHole),
        multiPolygon,
        Geometry.multiPolygon(multiPolygon),
        geometryCollection,
        recursiveGeometryCollection,
        Geometry.geometryCollection(geometryCollection)
    ]

    // MARK: - IsValid Tests

    func testIsValid() {
        let validPoint = Point(XYZ(0, 0, 0))

        XCTAssertTrue(try validPoint.isValid())

        let invalidPoint = Point(XYZ(.nan, 0, 0))

        XCTAssertFalse(try invalidPoint.isValid())
    }

    func testIsValidAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.isValid()
            } catch {
                XCTFail("Unexpected error for \(g) isValid() \(error)")
            }
        }
    }

    func testIsValidReason() throws {
        let validPoint = Point(XYZ(0, 0, 0))

        XCTAssertEqual(try validPoint.isValidReason(), "Valid Geometry")

        let invalidPoint = Point(XYZ(.nan, 0, 0))

        // NOTE: Currently geos 3.14.0 only returns XY coordinates in the reason.
        XCTAssertEqual(try invalidPoint.isValidReason(), "Invalid Coordinate[nan 0]")
    }

    func testIsValidReasonAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.isValidReason()
            } catch {
                XCTFail("Unexpected error for \(g) isValidReason() \(error)")
            }
        }
    }

    func testIsValidDetail() throws {
        let validPoint = Point(XYZ(0, 0, 0))

        XCTAssertEqual(try validPoint.isValidDetail(), .valid)

        let invalidPoint = Point(XYZ(.nan, 0, 0))

        let result = try invalidPoint.isValidDetail()
        guard case let .invalid(.some(reason), .some(.point(location))) = result else {
            XCTFail("Received unexpected isValidDetail result: \(result)")
            return
        }
        XCTAssertEqual(reason, "Invalid Coordinate")
        XCTAssertTrue(location.x.isNaN) // A naïve comparison of location and result fails because NaN != NaN
        XCTAssertEqual(location.y, invalidPoint.y)
    }

    // swiftlint:disable line_length

    func testIsValidDetail_AllowSelfTouchingRingFormingHole() {
        let polyWithSelfTouchingRingFormingHole = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 0),
            XYZ(0, 4, 0),
            XYZ(4, 0, 0),
            XYZ(0, 0, 0),
            XYZ(2, 1, 0),
            XYZ(1, 2, 0),
            XYZ(0, 0, 0)]))
        XCTAssertEqual(
            try polyWithSelfTouchingRingFormingHole.isValidDetail(allowSelfTouchingRingFormingHole: true),
            .valid
        )

        guard
            let result = try? polyWithSelfTouchingRingFormingHole.isValidDetail(allowSelfTouchingRingFormingHole: false),
            case let .invalid(reason, .some(.point(location))) = result,
            reason == "Ring Self-intersection",
            XY(location.coordinates) == XY(0, 0) && location.coordinates.z.isNaN // A naïve comparison of location and result fails because NaN != NaN
        else {
            XCTFail("Did not receive expected validation error.")
            return
        }
    }

    // swiftlint:enable line_length

    func testIsValidDetailAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.isValidDetail()
            } catch {
                XCTFail("Unexpected error for \(g) isValidDetail() \(error)")
            }
        }
    }

    // MARK: - MakeValid Tests

    func testMakeValidWhenItIsAPolygon() {
        let poly = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 0),
            XYZ(2, 0, 0),
            XYZ(1, 1, 0),
            XYZ(0, 2, 0),
            XYZ(2, 2, 0),
            XYZ(1, 1, 0),
            XYZ(0, 0, 0)]))

        let expectedPoly1 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(1, 1, 0),
            XYZ(2, 0, 0),
            XYZ(0, 0, 0),
            XYZ(1, 1, 0)]))

        let expectedPoly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(1, 1, 0),
            XYZ(0, 2, 0),
            XYZ(2, 2, 0),
            XYZ(1, 1, 0)]))

        do {
            switch try poly.makeValid() {
            case let .multiPolygon(multiPolygon):
                XCTAssertTrue(try multiPolygon.polygons
                                .contains(where: expectedPoly1.isTopologicallyEquivalent))
                XCTAssertTrue(try multiPolygon.polygons
                                .contains(where: expectedPoly2.isTopologicallyEquivalent))
            default:
                XCTFail("Unexpected geometry for \(poly) makeValid()")
            }
        } catch {
            XCTFail("Unexpected error for \(poly) makeValid() \(error)")
        }
    }

    func testMakeValidAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.makeValid()
            } catch {
                XCTFail("Unexpected error for \(g) makeValid() \(error)")
            }
        }
    }

    func testMakeValidUsingLineworkMethodAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.makeValid(method: .linework)
            } catch {
                XCTFail("Unexpected error for \(g) makeValid(method: .linework) \(error)")
            }
        }
    }

    func testMakeValidUsingStructureKeepCollapsedMethodAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.makeValid(method: .structure(keepCollapsed: true))
            } catch {
                XCTFail(
                    "Unexpected error for \(g) makeValid(method: .structure(keepCollapsed: true)) \(error)"
                )
            }
        }
    }

    func testMakeValidUsingStructureDoNotKeepCollapsedMethodAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.makeValid(method: .structure(keepCollapsed: false))
            } catch {
                XCTFail(
                    "Unexpected error for \(g) makeValid(method: .structure(keepCollapsed: false)) \(error)"
                )
            }
        }
    }

    // MARK: - Z Preservation Tests

    func testMakeValidPreservesZ() throws {
        // Test that makeValid() preserves Z coordinates when input has Z
        let polyWithZ = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 1),
            XYZ(2, 0, 2),
            XYZ(1, 1, 3),
            XYZ(0, 2, 4),
            XYZ(2, 2, 5),
            XYZ(1, 1, 6),
            XYZ(0, 0, 1)]))

        let result: Geometry<XYZ> = try polyWithZ.makeValid()

        // Verify the result is XYZ type
        switch result {
        case let .multiPolygon(multiPolygon):
            // Check that we have Z coordinates in the output
            for polygon in multiPolygon.polygons {
                for coord in polygon.exterior.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            }
        default:
            XCTFail("Expected multiPolygon result for invalid polygon, got \(result)")
        }
    }

    func testMakeValidPreservesZForValidGeometry() throws {
        // Test that makeValid() preserves Z for already valid geometry
        let validPolyWithZ = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 10),
            XYZ(1, 0, 20),
            XYZ(1, 1, 30),
            XYZ(0, 1, 40),
            XYZ(0, 0, 10)]))

        let result: Geometry<XYZ> = try validPolyWithZ.makeValid()

        // Verify the result maintains Z coordinates
        switch result {
        case let .polygon(polygon):
            let coords = polygon.exterior.coordinates
            XCTAssertEqual(coords[0].z, 10, accuracy: 0.001)
            XCTAssertEqual(coords[1].z, 20, accuracy: 0.001)
            XCTAssertEqual(coords[2].z, 30, accuracy: 0.001)
            XCTAssertEqual(coords[3].z, 40, accuracy: 0.001)
        default:
            XCTFail("Expected polygon result, got \(result)")
        }
    }

    func testMakeValidPreservesZForPoint() throws {
        // Test that makeValid() preserves Z for points
        let pointWithZ = Point(XYZ(1, 2, 42))

        let result: Geometry<XYZ> = try pointWithZ.makeValid()

        switch result {
        case let .point(point):
            XCTAssertEqual(point.coordinates.z, 42, accuracy: 0.001)
        default:
            XCTFail("Expected point result, got \(result)")
        }
    }

    func testMakeValidPreservesZForLineString() throws {
        // Test that makeValid() preserves Z for line strings
        let lineWithZ = try! LineString(coordinates: [
            XYZ(0, 0, 5),
            XYZ(1, 1, 10),
            XYZ(2, 2, 15)])

        let result: Geometry<XYZ> = try lineWithZ.makeValid()

        switch result {
        case let .lineString(line):
            XCTAssertEqual(line.coordinates[0].z, 5, accuracy: 0.001)
            XCTAssertEqual(line.coordinates[1].z, 10, accuracy: 0.001)
            XCTAssertEqual(line.coordinates[2].z, 15, accuracy: 0.001)
        default:
            XCTFail("Expected lineString result, got \(result)")
        }
    }

    func testMakeValidPreservesZForMultiPoint() throws {
        // Test that makeValid() preserves Z for multi points
        let multiPointWithZ = MultiPoint(points: [
            Point(XYZ(0, 0, 100)),
            Point(XYZ(1, 1, 200)),
            Point(XYZ(2, 2, 300))])

        let result: Geometry<XYZ> = try multiPointWithZ.makeValid()

        switch result {
        case let .multiPoint(multiPoint):
            XCTAssertEqual(multiPoint.points[0].coordinates.z, 100, accuracy: 0.001)
            XCTAssertEqual(multiPoint.points[1].coordinates.z, 200, accuracy: 0.001)
            XCTAssertEqual(multiPoint.points[2].coordinates.z, 300, accuracy: 0.001)
        default:
            XCTFail("Expected multiPoint result, got \(result)")
        }
    }

    func testMakeValidPreservesZForGeometryCollection() throws {
        // Test that makeValid() preserves Z for geometry collections
        let collectionWithZ = GeometryCollection(geometries: [
            Geometry.point(Point(XYZ(0, 0, 50))),
            Geometry.lineString(try! LineString(coordinates: [
                XYZ(1, 1, 60),
                XYZ(2, 2, 70)]))
        ])

        let result: Geometry<XYZ> = try collectionWithZ.makeValid()

        switch result {
        case let .geometryCollection(collection):
            // Check point
            if case let .point(point) = collection.geometries[0] {
                XCTAssertEqual(point.coordinates.z, 50, accuracy: 0.001)
            } else {
                XCTFail("Expected point in collection")
            }
            // Check linestring
            if case let .lineString(line) = collection.geometries[1] {
                XCTAssertEqual(line.coordinates[0].z, 60, accuracy: 0.001)
                XCTAssertEqual(line.coordinates[1].z, 70, accuracy: 0.001)
            } else {
                XCTFail("Expected lineString in collection")
            }
        default:
            XCTFail("Expected geometryCollection result, got \(result)")
        }
    }

    // MARK: - Z Preservation Tests with Methods

    func testMakeValidWithLineworkMethodPreservesZ() throws {
        // Test that makeValid(method: .linework) preserves Z coordinates
        let polyWithZ = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 1),
            XYZ(2, 0, 2),
            XYZ(1, 1, 3),
            XYZ(0, 2, 4),
            XYZ(2, 2, 5),
            XYZ(1, 1, 6),
            XYZ(0, 0, 1)]))

        let result: Geometry<XYZ> = try polyWithZ.makeValid(method: .linework)

        // Verify the result is XYZ type
        switch result {
        case let .multiPolygon(multiPolygon):
            // Check that we have Z coordinates in the output
            for polygon in multiPolygon.polygons {
                for coord in polygon.exterior.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            }
        default:
            XCTFail("Expected multiPolygon result for invalid polygon, got \(result)")
        }
    }

    func testMakeValidWithStructureKeepCollapsedMethodPreservesZ() throws {
        // Test that makeValid(method: .structure(keepCollapsed: true)) preserves Z
        let polyWithZ = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 1),
            XYZ(2, 0, 2),
            XYZ(1, 1, 3),
            XYZ(0, 2, 4),
            XYZ(2, 2, 5),
            XYZ(1, 1, 6),
            XYZ(0, 0, 1)]))

        let result: Geometry<XYZ> = try polyWithZ.makeValid(method: .structure(keepCollapsed: true))

        // Verify the result is XYZ type
        switch result {
        case let .multiPolygon(multiPolygon):
            // Check that we have Z coordinates in the output
            for polygon in multiPolygon.polygons {
                for coord in polygon.exterior.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            }
        default:
            XCTFail("Expected multiPolygon result for invalid polygon, got \(result)")
        }
    }

    func testMakeValidWithStructureDoNotKeepCollapsedMethodPreservesZ() throws {
        // Test that makeValid(method: .structure(keepCollapsed: false)) preserves Z
        let polyWithZ = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 1),
            XYZ(2, 0, 2),
            XYZ(1, 1, 3),
            XYZ(0, 2, 4),
            XYZ(2, 2, 5),
            XYZ(1, 1, 6),
            XYZ(0, 0, 1)]))

        let result: Geometry<XYZ> = try polyWithZ.makeValid(method: .structure(keepCollapsed: false))

        // Verify the result is XYZ type
        switch result {
        case let .multiPolygon(multiPolygon):
            // Check that we have Z coordinates in the output
            for polygon in multiPolygon.polygons {
                for coord in polygon.exterior.coordinates {
                    XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
                }
            }
        default:
            XCTFail("Expected multiPolygon result for invalid polygon, got \(result)")
        }
    }

    func testMakeValidWithLineworkMethodPreservesZForValidGeometry() throws {
        // Test that makeValid(method: .linework) preserves Z for valid geometry
        let validPolyWithZ = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 10),
            XYZ(1, 0, 20),
            XYZ(1, 1, 30),
            XYZ(0, 1, 40),
            XYZ(0, 0, 10)]))

        let result: Geometry<XYZ> = try validPolyWithZ.makeValid(method: .linework)

        // Verify the result maintains Z coordinates
        switch result {
        case let .polygon(polygon):
            let coords = polygon.exterior.coordinates
            XCTAssertEqual(coords[0].z, 10, accuracy: 0.001)
            XCTAssertEqual(coords[1].z, 20, accuracy: 0.001)
            XCTAssertEqual(coords[2].z, 30, accuracy: 0.001)
            XCTAssertEqual(coords[3].z, 40, accuracy: 0.001)
        default:
            XCTFail("Expected polygon result, got \(result)")
        }
    }

    func testMakeValidWithStructureMethodPreservesZForValidGeometry() throws {
        // Test that makeValid(method: .structure) preserves Z for valid geometry
        let validPolyWithZ = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZ(0, 0, 10),
            XYZ(1, 0, 20),
            XYZ(1, 1, 30),
            XYZ(0, 1, 40),
            XYZ(0, 0, 10)]))

        let result: Geometry<XYZ> = try validPolyWithZ.makeValid(method: .structure(keepCollapsed: true))

        // Verify the result maintains Z coordinates (vertices may be reordered by GEOS)
        switch result {
        case let .polygon(polygon):
            let coords = polygon.exterior.coordinates
            // Check that all Z coordinates are preserved (not NaN)
            for coord in coords {
                XCTAssertFalse(coord.z.isNaN, "Z coordinate should not be NaN")
            }
        default:
            XCTFail("Expected polygon result, got \(result)")
        }
    }

    func testMakeValidWithLineworkMethodPreservesZForPoint() throws {
        // Test that makeValid(method: .linework) preserves Z for points
        let pointWithZ = Point(XYZ(1, 2, 42))

        let result: Geometry<XYZ> = try pointWithZ.makeValid(method: .linework)

        switch result {
        case let .point(point):
            XCTAssertEqual(point.coordinates.z, 42, accuracy: 0.001)
        default:
            XCTFail("Expected point result, got \(result)")
        }
    }

    func testMakeValidWithStructureMethodPreservesZForPoint() throws {
        // Test that makeValid(method: .structure) preserves Z for points
        let pointWithZ = Point(XYZ(1, 2, 42))

        let result: Geometry<XYZ> = try pointWithZ.makeValid(method: .structure(keepCollapsed: false))

        switch result {
        case let .point(point):
            XCTAssertEqual(point.coordinates.z, 42, accuracy: 0.001)
        default:
            XCTFail("Expected point result, got \(result)")
        }
    }

    func testMakeValidWithLineworkMethodPreservesZForLineString() throws {
        // Test that makeValid(method: .linework) preserves Z for line strings
        let lineWithZ = try! LineString(coordinates: [
            XYZ(0, 0, 5),
            XYZ(1, 1, 10),
            XYZ(2, 2, 15)])

        let result: Geometry<XYZ> = try lineWithZ.makeValid(method: .linework)

        switch result {
        case let .lineString(line):
            XCTAssertEqual(line.coordinates[0].z, 5, accuracy: 0.001)
            XCTAssertEqual(line.coordinates[1].z, 10, accuracy: 0.001)
            XCTAssertEqual(line.coordinates[2].z, 15, accuracy: 0.001)
        default:
            XCTFail("Expected lineString result, got \(result)")
        }
    }

    func testMakeValidWithStructureMethodPreservesZForLineString() throws {
        // Test that makeValid(method: .structure) preserves Z for line strings
        let lineWithZ = try! LineString(coordinates: [
            XYZ(0, 0, 5),
            XYZ(1, 1, 10),
            XYZ(2, 2, 15)])

        let result: Geometry<XYZ> = try lineWithZ.makeValid(method: .structure(keepCollapsed: true))

        switch result {
        case let .lineString(line):
            XCTAssertEqual(line.coordinates[0].z, 5, accuracy: 0.001)
            XCTAssertEqual(line.coordinates[1].z, 10, accuracy: 0.001)
            XCTAssertEqual(line.coordinates[2].z, 15, accuracy: 0.001)
        default:
            XCTFail("Expected lineString result, got \(result)")
        }
    }
}
