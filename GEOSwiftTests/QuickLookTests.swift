//
//  QuickLookTests.swift
//  GEOSwiftTests
//
//  Created by Andrew Hershberger on 7/22/18.
//  Copyright © 2018 GEOSwift. All rights reserved.
//

#if canImport(UIKit)

import XCTest
import MapKit
@testable import GEOSwift

final class QuickLookTests: XCTestCase {
    var waypoint: Waypoint!
    var linearRing: LinearRing!
    var polygon: GEOSwift.Polygon!
    var geometryCollection: GeometryCollection<Geometry>!
    let imageSize = CGSize(width: 400, height: 400)
    var context: CGContext!

    override func setUp() {
        super.setUp()
        waypoint = Waypoint(latitude: 0.5, longitude: 0.5)
        linearRing = LinearRing(points: [Coordinate(x: 1, y: 1),
                                         Coordinate(x: 1, y: -1),
                                         Coordinate(x: -1, y: -1),
                                         Coordinate(x: -1, y: 1),
                                         Coordinate(x: 1, y: 1)])
        polygon = Polygon(shell: linearRing, holes: [])
        geometryCollection = GeometryCollection(geometries: [linearRing, waypoint])

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 1)
        context = UIGraphicsGetCurrentContext()
    }

    override func tearDown() {
        if context != nil {
            UIGraphicsEndImageContext()
            context = nil
        }
        geometryCollection = nil
        polygon = nil
        linearRing = nil
        waypoint = nil
        super.tearDown()
    }

    // Tests the general case of region
    func testRegionOfAPolygon() {
        XCTAssertEqual(polygon.region, MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)))
    }

    // Tests the special case of region for Waypoint
    func testRegionOfAWaypoint() {
        XCTAssertEqual(waypoint.region, MKCoordinateRegion(
            center: CLLocationCoordinate2D(waypoint.coordinate),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    }

    func testDrawWaypoint() {
        let mapRect = makeMapRect(withCenter: waypoint.coordinate, widthInMeters: 400)

        verifyDrawing(with: waypoint, mapRect: mapRect, expected: .waypoint)
    }

    func testDrawLineString() {
        let mapRect = makeMapRect(withCenter: Coordinate(x: 0, y: 0), widthInMeters: 240000)

        verifyDrawing(with: linearRing, mapRect: mapRect, expected: .linearRing)
    }

    func testDrawPolygon() {
        let mapRect = makeMapRect(withCenter: Coordinate(x: 0, y: 0), widthInMeters: 240000)

        verifyDrawing(with: polygon, mapRect: mapRect, expected: .polygon)
    }

    func testDrawGeometryCollection() {
        let mapRect = makeMapRect(withCenter: Coordinate(x: 0, y: 0), widthInMeters: 240000)

        verifyDrawing(with: geometryCollection, mapRect: mapRect, expected: .geometryCollection)
    }

    // MARK: - Helpers

    func makeMapRect(withCenter center: Coordinate, widthInMeters meters: Double) -> MKMapRect {
        let mapRectCenter = MKMapPoint(CLLocationCoordinate2D(center))
        let width = MKMapPointsPerMeterAtLatitude(center.y) * meters
        return MKMapRect(
            origin: MKMapPoint(x: mapRectCenter.x - width / 2, y: mapRectCenter.y - width / 2),
            size: MKMapSize(width: width, height: width))
    }

    /// SnapshotImages are from iPhone XS, so use that simulator when running unit tests
    func verifyDrawing(with geometry: GEOSwiftQuickLook,
                       mapRect: MKMapRect,
                       expected: SnapshotImage,
                       line: UInt = #line) {
        guard let context = context else {
            XCTFail("Unable to create graphics context", line: line)
            return
        }

        geometry.draw(in: context, imageSize: imageSize, mapRect: mapRect)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            XCTFail("Unable to get image", line: line)
            return
        }
        XCTAssertEqual(image.pngData(), expected.data, line: line)
        if expected.data == nil {
            savePNG(with: image, name: expected.name)
        }
    }

    // Use this method to generate new reference PNGs when adding rendering tests.
    // It prints the URL where it saved the image so you can find it and add it to the project.
    // It makes heavy use of force-unwrapping because this should only be used during development.
    func savePNG(with image: UIImage, name: String) {
        let png = image.pngData()!
        let urls = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        let url = urls.first!.appendingPathComponent(name)
        do {
            try png.write(to: url)
            print("Saved PNG to: \(url)")
        } catch {
            print("Could not save PNG because: \(error)")
        }
    }
}

#endif // canImport(UIKit)
