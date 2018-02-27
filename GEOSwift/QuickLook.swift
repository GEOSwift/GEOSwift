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

    @objc
    public func debugQuickLookObject() -> AnyObject? {
        
        let region: MKCoordinateRegion
        if let point = self as? Waypoint {
            let center = CLLocationCoordinate2DMake(point.coordinate.y, point.coordinate.x)
            let span = MKCoordinateSpanMake(0.1, 0.1)
            region = MKCoordinateRegionMake(center,span)
        } else {
            if let envelope = self.envelope() as? Polygon {
                let centroid = envelope.centroid()
                let center = CLLocationCoordinate2DMake(centroid.coordinate.y, centroid.coordinate.x)
                let exteriorRing = envelope.exteriorRing
                let upperLeft = exteriorRing.points[2]
                let lowerRight = exteriorRing.points[0]
                let span = MKCoordinateSpanMake(upperLeft.y - lowerRight.y, upperLeft.x - lowerRight.x)
                region = MKCoordinateRegionMake(center, span)
            } else {
                return nil
            }
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
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        let snapshotter = MKMapSnapshotter(options: options)
        let semaphore = DispatchSemaphore(value: 0);
        let mapRect = mapView.visibleMapRect
//        let boundingBox = MKMapRect(region)
            
        snapshotter.start(with: backgroundQueue) { snapshot, error in
            guard let snapshot = snapshot else {
                semaphore.signal()
                return
            }
            
            // let the single geometry draw itself on the map
            let image = snapshot.image
//            let finalImageRect = CGRectMake(0, 0, image.size.width, image.size.height)
            
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale);
            image.draw(at: CGPoint(x: 0, y: 0))
            
            guard let context = UIGraphicsGetCurrentContext() else {
                fatalError("Could not get current context")
            }
            let scaleX = image.size.width / CGFloat(mapRect.size.width)
            let scaleY = image.size.height / CGFloat(mapRect.size.height)
            //            CGContextTranslateCTM(context, (image.size.width - CGFloat(boundingBox.size.width) * scaleX) / 2, (image.size.height - CGFloat(boundingBox.size.height) * scaleY) / 2)
            context.scaleBy(x: scaleX, y: scaleY)
            if let geom = self as? GEOSwiftQuickLook {
                geom.drawInSnapshot(snapshot, mapRect: mapRect)
            }
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            mapViewImage = finalImage
            
            semaphore.signal()
        }
        let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        let _ = semaphore.wait(timeout: delayTime)

        // Sometimes this fails.. Fallback to WKT representation
        if let mapViewImage = mapViewImage {
            return mapViewImage
        } else {
            return self.WKT as AnyObject?
        }
    }
}

private func MKMapRect(_ region: MKCoordinateRegion) ->MKMapRect
{
    let a = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
        region.center.latitude + region.span.latitudeDelta / 2,
        region.center.longitude - region.span.longitudeDelta / 2));
    let b = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
        region.center.latitude - region.span.latitudeDelta / 2,
        region.center.longitude + region.span.longitudeDelta / 2));
    return MKMapRectMake(min(a.x,b.x), min(a.y,b.y), abs(a.x-b.x), abs(a.y-b.y));
}

extension Waypoint : GEOSwiftQuickLook {
    func drawInSnapshot(_ snapshot: MKMapSnapshot, mapRect: MKMapRect) {
        let image = snapshot.image
        
//        let finalImageRect = CGRectMake(0, 0, image.size.width, image.size.height)
        let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: "")
        if let pinImage = pin.image {
        
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale);
            
            image.draw(at: CGPoint(x: 0, y: 0))
            
            // draw center/home marker
            let coord = CLLocationCoordinate2DMake(self.coordinate.y, self.coordinate.x)
            let homePoint = snapshot.point(for: coord)
            var rect = CGRect(x: 0, y: 0, width: pinImage.size.width, height: pinImage.size.height)
            rect = rect.offsetBy(dx: homePoint.x-rect.size.width/2.0, dy: homePoint.y-rect.size.height)
            pinImage.draw(in: rect)
        }
    }
}

extension LineString : GEOSwiftQuickLook {
    func drawInSnapshot(_ snapshot: MKMapSnapshot, mapRect: MKMapRect) {
        
        if let overlay = self.mapShape() as? MKOverlay {
            let zoomScale = snapshot.image.size.width / CGFloat(mapRect.size.width)
            
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 2
            renderer.strokeColor = UIColor.blue.withAlphaComponent(0.7)
            
            if let context = UIGraphicsGetCurrentContext() {
                context.saveGState();
                
                // the renderer will draw the geometry at 0;0, so offset CoreGraphics by the right measure
                let upperCorner = renderer.mapPoint(for: CGPoint.zero)
                context.translateBy(x: CGFloat(upperCorner.x - mapRect.origin.x), y: CGFloat(upperCorner.y - mapRect.origin.y));
                
                renderer.draw(mapRect, zoomScale: zoomScale, in: context)
                context.restoreGState();
            }
        }
    }
}

extension Polygon : GEOSwiftQuickLook {
    func drawInSnapshot(_ snapshot: MKMapSnapshot, mapRect: MKMapRect) {
        
        if let overlay = self.mapShape() as? MKOverlay {
            let zoomScale = snapshot.image.size.width / CGFloat(mapRect.size.width)
            
            let polygonRenderer = MKPolygonRenderer(overlay: overlay)
            polygonRenderer.lineWidth = 2
            polygonRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.7)
            polygonRenderer.fillColor = UIColor.cyan.withAlphaComponent(0.2)
            
            if let context = UIGraphicsGetCurrentContext() {
                context.saveGState();
                
                // the renderer will draw the geometry at 0;0, so offset CoreGraphics by the right measure
                let upperCorner = polygonRenderer.mapPoint(for: CGPoint.zero)
                context.translateBy(x: CGFloat(upperCorner.x - mapRect.origin.x), y: CGFloat(upperCorner.y - mapRect.origin.y));
                
                polygonRenderer.draw(mapRect, zoomScale: zoomScale, in: context)

                context.restoreGState();
            }
        }
    }
}

extension GeometryCollection : GEOSwiftQuickLook {
    func drawInSnapshot(_ snapshot: MKMapSnapshot, mapRect: MKMapRect) {
        for geometry in self.geometries {
            if let geom = geometry as? GEOSwiftQuickLook {
                geom.drawInSnapshot(snapshot, mapRect: mapRect)
            }
        }
    }
}
