//
//  QuickLook.swift
//
//  Created by Andrea Cremaschi on 21/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation
import MapKit

protocol GEOSwiftQuickLook {
    func drawInSnapshot(_ snapshot: MKMapSnapshot, mapRect: MKMapRect)
}

public extension Geometry {

    // swiftlint:disable:next function_body_length
    @objc public func debugQuickLookObject() -> AnyObject? {

        let region: MKCoordinateRegion
        if let point = self as? Waypoint {
            let center = CLLocationCoordinate2D(latitude: point.coordinate.y, longitude: point.coordinate.x)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            region = MKCoordinateRegion(center: center, span: span)
        } else if let envelope = self.envelope(), let centroid = envelope.centroid() {
            let center = CLLocationCoordinate2D(latitude: centroid.coordinate.y, longitude: centroid.coordinate.x)
            let exteriorRing = envelope.exteriorRing
            let upperLeft = exteriorRing.points[2]
            let lowerRight = exteriorRing.points[0]
            let span = MKCoordinateSpan(latitudeDelta: upperLeft.y - lowerRight.y,
                                        longitudeDelta: upperLeft.x - lowerRight.x)
            region = MKCoordinateRegion(center: center, span: span)
        } else {
            return nil
        }

        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        mapView.region = region

        let options = MKMapSnapshotOptions()
        options.region = mapView.region
        options.scale = UIScreen.main.scale
        options.size = mapView.frame.size

        // take a snapshot of the map with MKMapSnapshot:
        // it is designed to work in background, so we have to block the main thread using a semaphore
        var mapViewImage: UIImage?
        let backgroundQueue = DispatchQueue.global(qos: .background)
        let snapshotter = MKMapSnapshotter(options: options)
        let semaphore = DispatchSemaphore(value: 0)
        let mapRect = mapView.visibleMapRect

        snapshotter.start(with: backgroundQueue) { snapshot, _ in
            guard let snapshot = snapshot else {
                semaphore.signal()
                return
            }

            // let the single geometry draw itself on the map
            let image = snapshot.image

            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
            image.draw(at: CGPoint(x: 0, y: 0))

            guard let context = UIGraphicsGetCurrentContext() else {
                fatalError("Could not get current context")
            }
            let scaleX = image.size.width / CGFloat(mapRect.size.width)
            let scaleY = image.size.height / CGFloat(mapRect.size.height)
            context.scaleBy(x: scaleX, y: scaleY)
            if let geom = self as? GEOSwiftQuickLook {
                geom.drawInSnapshot(snapshot, mapRect: mapRect)
            }
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            mapViewImage = finalImage

            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .now() + 3)

        // Sometimes this fails.. Fallback to WKT representation
        if let mapViewImage = mapViewImage {
            return mapViewImage
        } else {
            return self.WKT as AnyObject?
        }
    }
}

extension Waypoint: GEOSwiftQuickLook {
    func drawInSnapshot(_ snapshot: MKMapSnapshot, mapRect: MKMapRect) {
        let image = snapshot.image

        let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: "")
        if let pinImage = pin.image {

            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)

            image.draw(at: CGPoint(x: 0, y: 0))

            // draw center/home marker
            let coord = CLLocationCoordinate2D(latitude: self.coordinate.y, longitude: self.coordinate.x)
            let homePoint = snapshot.point(for: coord)
            var rect = CGRect(x: 0, y: 0, width: pinImage.size.width, height: pinImage.size.height)
            rect = rect.offsetBy(dx: homePoint.x-rect.size.width/2.0, dy: homePoint.y-rect.size.height)
            pinImage.draw(in: rect)
        }
    }
}

extension LineString: GEOSwiftQuickLook {
    func drawInSnapshot(_ snapshot: MKMapSnapshot, mapRect: MKMapRect) {

        if let overlay = self.mapShape() as? MKOverlay {
            let zoomScale = snapshot.image.size.width / CGFloat(mapRect.size.width)

            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 2
            renderer.strokeColor = UIColor.blue.withAlphaComponent(0.7)

            if let context = UIGraphicsGetCurrentContext() {
                context.saveGState()

                // the renderer will draw the geometry at 0;0, so offset CoreGraphics by the right measure
                let upperCorner = renderer.mapPoint(for: CGPoint.zero)
                context.translateBy(x: CGFloat(upperCorner.x - mapRect.origin.x),
                                    y: CGFloat(upperCorner.y - mapRect.origin.y))

                renderer.draw(mapRect, zoomScale: zoomScale, in: context)
                context.restoreGState()
            }
        }
    }
}

extension Polygon: GEOSwiftQuickLook {
    func drawInSnapshot(_ snapshot: MKMapSnapshot, mapRect: MKMapRect) {

        if let overlay = self.mapShape() as? MKOverlay {
            let zoomScale = snapshot.image.size.width / CGFloat(mapRect.size.width)

            let polygonRenderer = MKPolygonRenderer(overlay: overlay)
            polygonRenderer.lineWidth = 2
            polygonRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.7)
            polygonRenderer.fillColor = UIColor.cyan.withAlphaComponent(0.2)

            if let context = UIGraphicsGetCurrentContext() {
                context.saveGState()

                // the renderer will draw the geometry at 0;0, so offset CoreGraphics by the right measure
                let upperCorner = polygonRenderer.mapPoint(for: CGPoint.zero)
                context.translateBy(x: CGFloat(upperCorner.x - mapRect.origin.x),
                                    y: CGFloat(upperCorner.y - mapRect.origin.y))

                polygonRenderer.draw(mapRect, zoomScale: zoomScale, in: context)

                context.restoreGState()
            }
        }
    }
}

extension GeometryCollection: GEOSwiftQuickLook {
    func drawInSnapshot(_ snapshot: MKMapSnapshot, mapRect: MKMapRect) {
        for geometry in self.geometries {
            if let geom = geometry as? GEOSwiftQuickLook {
                geom.drawInSnapshot(snapshot, mapRect: mapRect)
            }
        }
    }
}
