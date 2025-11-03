import XCTest
import GEOSwift

// MARK: - Test Value Extensions for XYZM

private extension Point where C == XYZM {
    static let testValue1 = Point(XYZM(1, 2, 0, 0))
    static let testValue3 = Point(XYZM(3, 4, 1, 1))
}

private extension LineString where C == XYZM {
    static let testValue1 = try! LineString(coordinates: [
        Point<XYZM>.testValue1.coordinates,
        Point<XYZM>.testValue3.coordinates
    ])
}

private extension Polygon.LinearRing where C == XYZM {
    // counterclockwise
    static let testValueExterior2 = try! Polygon.LinearRing(coordinates: [
        XYZM(2, 2, 0, 0),
        XYZM(-2, 2, 0, 0),
        XYZM(-2, -2, 0, 0),
        XYZM(2, -2, 0, 0),
        XYZM(2, 2, 1, 1)])

    // clockwise
    static let testValueHole1 = try! Polygon.LinearRing(coordinates: [
        XYZM(1, 1, 0, 0),
        XYZM(1, -1, 0, 0),
        XYZM(-1, -1, 0, 0),
        XYZM(-1, 1, 0, 0),
        XYZM(1, 1, 1, 1)])
}

private extension Polygon where C == XYZM {
    static let testValueWithHole = Polygon(
        exterior: Polygon<XYZM>.LinearRing.testValueExterior2,
        holes: [Polygon<XYZM>.LinearRing.testValueHole1])
}

private extension MultiPoint where C == XYZM {
    static let testValue = MultiPoint(points: [.testValue1, .testValue3])
}

private extension MultiLineString where C == XYZM {
    static let testValue = MultiLineString(
        lineStrings: [.testValue1])
}

private extension MultiPolygon where C == XYZM {
    static let testValue = MultiPolygon(
        polygons: [.testValueWithHole])
}

private extension GeometryCollection where C == XYZM {
    static let testValue = GeometryCollection(
        geometries: [
            Point<XYZM>.testValue1,
            MultiPoint<XYZM>.testValue,
            LineString<XYZM>.testValue1,
            MultiLineString<XYZM>.testValue,
            Polygon<XYZM>.testValueWithHole,
            MultiPolygon<XYZM>.testValue])

    static let testValueWithRecursion = GeometryCollection(
        geometries: [GeometryCollection<XYZM>.testValue])
}

// MARK: - Tests

final class ValidityTests_XYZM: XCTestCase {
    let geometryConvertibles: [any GeometryConvertible<XYZM>] = [
        Point<XYZM>.testValue1,
        Geometry.point(Point<XYZM>.testValue1),
        MultiPoint<XYZM>.testValue,
        Geometry.multiPoint(MultiPoint<XYZM>.testValue),
        LineString<XYZM>.testValue1,
        Geometry.lineString(LineString<XYZM>.testValue1),
        MultiLineString<XYZM>.testValue,
        Geometry.multiLineString(MultiLineString<XYZM>.testValue),
        Polygon<XYZM>.LinearRing.testValueHole1,
        Polygon<XYZM>.testValueWithHole,
        Geometry.polygon(Polygon<XYZM>.testValueWithHole),
        MultiPolygon<XYZM>.testValue,
        Geometry.multiPolygon(MultiPolygon<XYZM>.testValue),
        GeometryCollection<XYZM>.testValue,
        GeometryCollection<XYZM>.testValueWithRecursion,
        Geometry.geometryCollection(GeometryCollection<XYZM>.testValue)]

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
