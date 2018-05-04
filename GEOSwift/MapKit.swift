//
//  HumboldMapKit.swift
//
//  Created by Andrea Cremaschi on 26/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation
import MapKit

/**
A convenience method to convert coordinates in the CoreLocation format.

:param: coord the `Coordinate` object

:returns: A CLLocationCoordinate2D
*/
public func CLLocationCoordinate2DFromCoordinate(_ coord: Coordinate) -> CLLocationCoordinate2D {
    let coord = CLLocationCoordinate2DMake(coord.y, coord.x)
    return coord
}

/**
 A convenience method to convert coordinates from the CoreLocation format.
 
 :param: coord the `CLLocationCoordinate2D` object
 
 :returns: A Coordinate
 */
public func CoordinateFromCLLocationCoordinate2D(_ coord: CLLocationCoordinate2D) -> Coordinate {
    let coord = Coordinate(x: coord.longitude, y: coord.latitude)
    return coord
}

// MARK: - MKShape creation convenience function

public protocol GEOSwiftMapKit {
    /**
    A convenience method to create a `MKShape` ready to be added to a `MKMapView`.
    
    :returns: A MKShape representing this geometry.
    */
    func mapShape() -> MKShape
}

// Declarations in extensions cannot override yet (in Swift 2.0)!
// Solve conformance to protocol with an inelegant (but effective) switch case.

extension Geometry : GEOSwiftMapKit {
    public func mapShape() -> MKShape {
        
        switch self {
            
        case is Waypoint:
            let pointAnno = MKPointAnnotation()
            pointAnno.coordinate = CLLocationCoordinate2DFromCoordinate((self as! Waypoint).coordinate)
            return pointAnno
            
        case is LineString:
            var coordinates = (self as! LineString).points.map({ (point: Coordinate) ->
                CLLocationCoordinate2D in
                return CLLocationCoordinate2DFromCoordinate(point)
            })
            let polyline = MKPolyline(coordinates: &coordinates,
                count: coordinates.count)
            return polyline
            
        case is Polygon:
            var exteriorRingCoordinates = (self as! Polygon).exteriorRing.points.map({ (point: Coordinate) ->
                CLLocationCoordinate2D in
                return CLLocationCoordinate2DFromCoordinate(point)
            })
            
            let interiorRings = (self as! Polygon).interiorRings.map({ (linearRing: LinearRing) ->
                MKPolygon in
                return MKPolygonWithCoordinatesSequence(linearRing.points)
            })
            
            let polygon = MKPolygon(coordinates: &exteriorRingCoordinates, count: exteriorRingCoordinates.count, interiorPolygons: interiorRings)
            return polygon
            
        case let gc as GeometryCollection<Waypoint>:
            return MKShapesCollection(geometryCollection: gc)

        case let gc as GeometryCollection<LineString>:
            return MKShapesCollection(geometryCollection: gc)

        case let gc as GeometryCollection<Polygon>:
            return MKShapesCollection(geometryCollection: gc)

        default:
            let geometryCollectionOverlay = MKShapesCollection(geometryCollection: (self as! GeometryCollection))
            return geometryCollectionOverlay
        }
    }
}

private func MKPolygonWithCoordinatesSequence(_ coordinates: CoordinatesCollection) -> MKPolygon {
    var coordinates = coordinates.map({ (point: Coordinate) ->
        CLLocationCoordinate2D in
        return CLLocationCoordinate2DFromCoordinate(point)
    })
    return MKPolygon(coordinates: &coordinates,
        count: coordinates.count)
    
}

/** 
MKShape subclass for GeometryCollections.
The property `shapes` contains MKShape subclasses instances. When drawing shapes on a map be careful to the fact that that these shapes could be overlays OR annotations.
*/
open class MKShapesCollection : MKShape, MKOverlay  {
    open let shapes: Array<MKShape>
    open let centroid: CLLocationCoordinate2D
    open let boundingMapRect: MKMapRect
    
    required public init<T>(geometryCollection: GeometryCollection<T>) {
        let shapes = geometryCollection.geometries.map({ (geometry: T) ->
            MKShape in
                return geometry.mapShape()
        })
        
        if let coordinate = geometryCollection.centroid()?.coordinate {
            self.centroid = CLLocationCoordinate2DFromCoordinate(coordinate)
        } else {
            self.centroid = CLLocationCoordinate2DFromCoordinate(CoordinateFromCLLocationCoordinate2D(CLLocationCoordinate2DMake(0, 0)))
        }
        
        self.shapes = shapes

        if let envelope = geometryCollection.envelope() {
            //let exteriorRing = envelope.exteriorRing
            let bottomLeft = MKMapPointForCoordinate(CLLocationCoordinate2DFromCoordinate(envelope.bottomLeft))
            let topRight = MKMapPointForCoordinate(CLLocationCoordinate2DFromCoordinate(envelope.topRight))
            let mapRect = MKMapRectMake(bottomLeft.x, bottomLeft.y, topRight.x - bottomLeft.x, topRight.y - bottomLeft.y)
            self.boundingMapRect = mapRect
            
        } else {
            self.boundingMapRect = MKMapRectNull
        }
    }
}
