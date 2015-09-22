//
//  QuickLook.swift
//
//  Created by Andrea Cremaschi on 21/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation
import MapKit

protocol GEOSwiftQuickLook {
    func drawInSnapshot(snapshot: MKMapSnapshot, mapRect: MKMapRect)
}

public extension Geometry {
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
        
        mapView.mapType = .Standard
        mapView.frame = CGRectMake(0, 0, 400, 400)
        mapView.region = region
        
        let options = MKMapSnapshotOptions()
        options.region = mapView.region
        options.scale = UIScreen.mainScreen().scale
        options.size = mapView.frame.size
        
        // take a snapshot of the map with MKMapSnapshot:
        // it is designed to work in background, so we have to block the main thread using a semaphore
        var mapViewImage: UIImage?
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        let snapshotter = MKMapSnapshotter(options: options)
        let semaphore = dispatch_semaphore_create(0);
        let mapRect = mapView.visibleMapRect
//        let boundingBox = MKMapRect(region)
        snapshotter.startWithQueue(backgroundQueue, completionHandler: { (snapshot: MKMapSnapshot?, error: NSError?) -> Void in
            
            guard (snapshot != nil) else {
                dispatch_semaphore_signal(semaphore)
                return
            }
            
            // let the single geometry draw itself on the map
            let image = snapshot!.image
//            let finalImageRect = CGRectMake(0, 0, image.size.width, image.size.height)
            
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale);
            image.drawAtPoint(CGPointMake(0, 0))
            
            let context = UIGraphicsGetCurrentContext()
            let scaleX = image.size.width / CGFloat(mapRect.size.width)
            let scaleY = image.size.height / CGFloat(mapRect.size.height)
            //            CGContextTranslateCTM(context, (image.size.width - CGFloat(boundingBox.size.width) * scaleX) / 2, (image.size.height - CGFloat(boundingBox.size.height) * scaleY) / 2)
            CGContextScaleCTM(context, scaleX, scaleY)
            if let geom = self as? GEOSwiftQuickLook {
                geom.drawInSnapshot(snapshot!, mapRect: mapRect)
            }
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            mapViewImage = finalImage
            
            dispatch_semaphore_signal(semaphore)
        })
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_semaphore_wait(semaphore, delayTime)

        // Sometimes this fails.. Fallback to WKT representation
        if let mapViewImage = mapViewImage {
            return mapViewImage
        } else {
            return self.WKT
        }
    }
}

private func MKMapRect(region: MKCoordinateRegion) ->MKMapRect
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
    func drawInSnapshot(snapshot: MKMapSnapshot, mapRect: MKMapRect) {
        let image = snapshot.image
        
//        let finalImageRect = CGRectMake(0, 0, image.size.width, image.size.height)
        let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: "")
        if let pinImage = pin.image {
        
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale);
            
            image.drawAtPoint(CGPointMake(0, 0))
            
            // draw center/home marker
            let coord = CLLocationCoordinate2DMake(self.coordinate.y, self.coordinate.x)
            let homePoint = snapshot.pointForCoordinate(coord)
            var rect = CGRectMake(0, 0, pinImage.size.width, pinImage.size.height)
            rect = CGRectOffset(rect, homePoint.x-rect.size.width/2.0, homePoint.y-rect.size.height)
            pinImage.drawInRect(rect)
        }
    }
}

extension LineString : GEOSwiftQuickLook {
    func drawInSnapshot(snapshot: MKMapSnapshot, mapRect: MKMapRect) {
        
        if let overlay = self.mapShape() as? MKOverlay {
            let zoomScale = snapshot.image.size.width / CGFloat(mapRect.size.width)
            
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 2
            renderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.7)
            
            if let context = UIGraphicsGetCurrentContext() {
                CGContextSaveGState(context);
                
                // the renderer will draw the geometry at 0;0, so offset CoreGraphics by the right measure
                let upperCorner = renderer.mapPointForPoint(CGPointZero)
                CGContextTranslateCTM(context, CGFloat(upperCorner.x - mapRect.origin.x), CGFloat(upperCorner.y - mapRect.origin.y));
                
                renderer.drawMapRect(mapRect, zoomScale: zoomScale, inContext: context)
                CGContextRestoreGState(context);
            }
        }
    }
}

extension Polygon : GEOSwiftQuickLook {
    func drawInSnapshot(snapshot: MKMapSnapshot, mapRect: MKMapRect) {
        
        if let overlay = self.mapShape() as? MKOverlay {
            let zoomScale = snapshot.image.size.width / CGFloat(mapRect.size.width)
            
            let polygonRenderer = MKPolygonRenderer(overlay: overlay)
            polygonRenderer.lineWidth = 2
            polygonRenderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.7)
            polygonRenderer.fillColor = UIColor.cyanColor().colorWithAlphaComponent(0.2)
            
            if let context = UIGraphicsGetCurrentContext() {
                CGContextSaveGState(context);
                
                // the renderer will draw the geometry at 0;0, so offset CoreGraphics by the right measure
                let upperCorner = polygonRenderer.mapPointForPoint(CGPointZero)
                CGContextTranslateCTM(context, CGFloat(upperCorner.x - mapRect.origin.x), CGFloat(upperCorner.y - mapRect.origin.y));
                
                polygonRenderer.drawMapRect(mapRect, zoomScale: zoomScale, inContext: context)

                CGContextRestoreGState(context);
            }
        }
    }
}

extension GeometryCollection : GEOSwiftQuickLook {
    func drawInSnapshot(snapshot: MKMapSnapshot, mapRect: MKMapRect) {
        for geometry in self.geometries {
            if let geom = geometry as? GEOSwiftQuickLook {
                geom.drawInSnapshot(snapshot, mapRect: mapRect)
            }
        }
    }
}
