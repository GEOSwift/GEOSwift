import XCTest
import GEOSwift

// MARK: - Tests

final class ValidityTests_XYZM: XCTestCase {
    // Use XYZM fixtures directly
    let point1 = Fixtures.point1
    let lineString1 = Fixtures.lineString1
    let linearRingHole1 = Fixtures.linearRingHole1
    let polygonWithHole = Fixtures.polygonWithHole
    let multiPoint = Fixtures.multiPoint
    let multiLineString = Fixtures.multiLineString
    let multiPolygon = Fixtures.multiPolygon
    let geometryCollection = Fixtures.geometryCollection
    let recursiveGeometryCollection = Fixtures.recursiveGeometryCollection

    // Geometry convertibles array
    lazy var geometryConvertibles: [any GeometryConvertible<XYZM>] = [
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
        let validPoint = Point(XYZM(0, 0, 0, 0))

        XCTAssertTrue(try validPoint.isValid())

        let invalidPoint = Point(XYZM(.nan, 0, 0, 0))

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
        let validPoint = Point(XYZM(0, 0, 0, 0))

        XCTAssertEqual(try validPoint.isValidReason(), "Valid Geometry")

        let invalidPoint = Point(XYZM(.nan, 0, 0, 0))

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
        let validPoint = Point(XYZM(0, 0, 0, 0))

        XCTAssertEqual(try validPoint.isValidDetail(), .valid)

        let invalidPoint = Point(XYZM(.nan, 0, 0, 0))

        let result = try invalidPoint.isValidDetail()
        guard case let .invalid(.some(reason), .some(.point(location))) = result else {
            XCTFail("Received unexpected isValidDetail result: \(result)")
            return
        }
        XCTAssertEqual(reason, "Invalid Coordinate")
        XCTAssertTrue(location.x.isNaN) // A naïve comparison of location and result fails because NaN != NaN
        XCTAssertEqual(location.y, invalidPoint.y)
    }

    func testIsValidDetail_AllowSelfTouchingRingFormingHole() {
        let polyWithSelfTouchingRingFormingHole = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(0, 0, 0, 0),
            XYZM(0, 4, 0, 0),
            XYZM(4, 0, 0, 0),
            XYZM(0, 0, 0, 0),
            XYZM(2, 1, 0, 0),
            XYZM(1, 2, 0, 0),
            XYZM(0, 0, 0, 0)]))
        XCTAssertEqual(
            try polyWithSelfTouchingRingFormingHole.isValidDetail(allowSelfTouchingRingFormingHole: true),
            .valid
        )

        guard
            let result = try? polyWithSelfTouchingRingFormingHole.isValidDetail(
                allowSelfTouchingRingFormingHole: false
            ),
            case let .invalid(reason, .some(.point(location))) = result,
            reason == "Ring Self-intersection",
            // A naïve comparison of location and result fails because NaN != NaN
            XY(location.coordinates) == XY(0, 0) && location.coordinates.z.isNaN &&
                location.coordinates.m.isNaN
        else {
            XCTFail("Did not receive expected validation error.")
            return
        }
    }

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
            XYZM(0, 0, 0, 0),
            XYZM(2, 0, 0, 0),
            XYZM(1, 1, 0, 0),
            XYZM(0, 2, 0, 0),
            XYZM(2, 2, 0, 0),
            XYZM(1, 1, 0, 0),
            XYZM(0, 0, 0, 0)]))

        let expectedPoly1 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(1, 1, 0, 0),
            XYZM(2, 0, 0, 0),
            XYZM(0, 0, 0, 0),
            XYZM(1, 1, 0, 0)]))

        let expectedPoly2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
            XYZM(1, 1, 0, 0),
            XYZM(0, 2, 0, 0),
            XYZM(2, 2, 0, 0),
            XYZM(1, 1, 0, 0)]))

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
}
