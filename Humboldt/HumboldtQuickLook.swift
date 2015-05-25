//
//  HumboldtQuickLook.swift
//  HumboldtDemo
//
//  Created by Andrea Cremaschi on 21/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol HumboldtQuickLook {
    func drawInSnapshot(snapshot: MKMapSnapshot) -> UIImage
}

extension Geometry : HumboldtQuickLook {
    func drawInSnapshot(snapshot: MKMapSnapshot) -> UIImage {
        return snapshot.image
    }
}


public extension Geometry {
    public func debugQuickLookObject() -> AnyObject? {
        
        let centroid = self.centroid()
        let buffer = self.envelope()
        let center = CLLocationCoordinate2DMake(centroid.coordinate.y, centroid.coordinate.x)
        let exteriorRing = buffer.exteriorRing
        let upperLeft = exteriorRing.points[2]
        let lowerRight = exteriorRing.points[0]
        let span = MKCoordinateSpanMake(upperLeft.y - lowerRight.y, upperLeft.x - lowerRight.x)
        let region = MKCoordinateRegionMake(center, span)
        var mapView = MKMapView()
        
        mapView.mapType = .Standard
        mapView.frame = CGRectMake(0, 0, 200, 200)
        mapView.region = region
        
        var options = MKMapSnapshotOptions.new()
        options.region = mapView.region
        options.scale = UIScreen.mainScreen().scale
        options.size = mapView.frame.size
        
        // take a snapshot of the map with MKMapSnapshot:
        // it is designed to work in background, so we have to block the main thread using a semaphore
        var mapViewImage: UIImage!
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        let snapshotter = MKMapSnapshotter(options: options)
        let semaphore = dispatch_semaphore_create(0);
        snapshotter.startWithQueue(backgroundQueue, completionHandler: { (snapshot: MKMapSnapshot!, error: NSError!) -> Void in
            
            // let the single geometry draw itself on the map
            mapViewImage = self.drawInSnapshot(snapshot)
            dispatch_semaphore_signal(semaphore)
        })
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return mapViewImage
    }
}


extension Waypoint : HumboldtQuickLook {
    override func drawInSnapshot(snapshot: MKMapSnapshot) -> UIImage {
        var image = snapshot.image
        
        let finalImageRect = CGRectMake(0, 0, image.size.width, image.size.height)
        let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: "")
        let pinImage = pin.image
        
        UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale);
        
        image.drawAtPoint(CGPointMake(0, 0))
        
        // draw center/home marker
//        let coord = CLLocationCoordinate2DMake(self.coordinate.y, self.coordinate.x)
        let coord = CLLocationCoordinate2DMake(45, 9)
        var homePoint = snapshot.pointForCoordinate(coord)
        pinImage.drawAtPoint(homePoint)

        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
}

extension LineString : HumboldtQuickLook {
    override func drawInSnapshot(snapshot: MKMapSnapshot) -> UIImage {
        var image = snapshot.image
        
        let finalImageRect = CGRectMake(0, 0, image.size.width, image.size.height)
        
        UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale);
        
        image.drawAtPoint(CGPointMake(0, 0))
        
        // draw linestring
        var path = UIBezierPath()
        
        for (i, coordinate) in enumerate(self.points) {
            let coord = CLLocationCoordinate2DMake(coordinate.y, coordinate.x)
            var point = snapshot.pointForCoordinate(coord)
            
            if (CGRectContainsPoint(finalImageRect, point)) {
                if i == 0 {
                    path.moveToPoint(point)
                } else {
                    path.addLineToPoint(point)
                }
            }
        }
        
        UIColor.blueColor().colorWithAlphaComponent(0.7).setStroke()
        
        path.lineWidth = 2.0
        path.stroke()
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
}

extension Polygon : HumboldtQuickLook {
    override func drawInSnapshot(snapshot: MKMapSnapshot) -> UIImage {
        var image = snapshot.image

        let finalImageRect = CGRectMake(0, 0, image.size.width, image.size.height)
        
        UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale);
        
        image.drawAtPoint(CGPointMake(0, 0))
        
        // draw polygon
        var path = UIBezierPath()
        
        for (i, coordinate) in enumerate(self.exteriorRing.points) {
            let coord = CLLocationCoordinate2DMake(coordinate.y, coordinate.x)
            var point = snapshot.pointForCoordinate(coord)
            
            if (CGRectContainsPoint(finalImageRect, point)) {
                if i == 0 {
                    path.moveToPoint(point)
                } else {
                    path.addLineToPoint(point)
                }
            }
        }
        
        path.closePath()
        
        UIColor.blueColor().colorWithAlphaComponent(0.7).setStroke()
        UIColor.cyanColor().colorWithAlphaComponent(0.2).setFill()
        
        path.lineWidth = 2.0
        path.stroke()
        path.fill()
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
}

extension GeometryCollection : HumboldtQuickLook {
    override func drawInSnapshot(snapshot: MKMapSnapshot) -> UIImage {
        var image = snapshot.image
        
        let finalImageRect = CGRectMake(0, 0, image.size.width, image.size.height)
        
        UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale);
        
        image.drawAtPoint(CGPointMake(0, 0))
        
        // draw geometry collection
        var path = UIBezierPath()
        
        for (i, geometry) in enumerate(self.geometries) {
            // TODO: draw geometry
        }
        
        path.closePath()
        
        UIColor.blueColor().colorWithAlphaComponent(0.7).setStroke()
        UIColor.cyanColor().colorWithAlphaComponent(0.2).setFill()
        
        path.lineWidth = 2.0
        path.stroke()
        path.fill()
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
}