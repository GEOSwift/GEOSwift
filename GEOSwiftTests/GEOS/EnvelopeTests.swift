//
//  EnvelopeTests.swift
//  GEOSwift
//
//  Created by Andrew Hershberger on 6/30/19.
//  Copyright © 2019 GEOSwift. All rights reserved.
//

import XCTest
@testable import GEOSwift

final class EnvelopeTests: XCTestCase {
    let envelope = Envelope(minX: 0, maxX: 1, minY: 2, maxY: 3)

    func testMinXMaxY() {
        XCTAssertEqual(envelope.minXMaxY, Point(x: 0, y: 3))
    }

    func testMaxXMaxY() {
        XCTAssertEqual(envelope.maxXMaxY, Point(x: 1, y: 3))
    }

    func testMinXMinY() {
        XCTAssertEqual(envelope.minXMinY, Point(x: 0, y: 2))
    }

    func testMaxXMinY() {
        XCTAssertEqual(envelope.maxXMinY, Point(x: 1, y: 2))
    }

    func testGeometry() {
        let expectedPolygon = try! Polygon(exterior: Polygon.LinearRing(
            points: [
                Point(x: 0, y: 2),
                Point(x: 1, y: 2),
                Point(x: 1, y: 3),
                Point(x: 0, y: 3),
                Point(x: 0, y: 2)]))

        XCTAssertEqual(envelope.geometry, expectedPolygon.geometry)
    }

    func testGeometryWhenExpectingAPoint() {
        let envelope = Envelope(minX: 0, maxX: 0, minY: 2, maxY: 2)
        let expectedPoint = Point(x: 0, y: 2)

        XCTAssertEqual(envelope.geometry, expectedPoint.geometry)
    }
}
