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
public func CLLocationCoordinateFromCoordinate(coord: Coordinate) -> CLLocationCoordinate2D {
    let coord = CLLocationCoordinate2DMake(coord.y, coord.x)
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
            pointAnno.coordinate = CLLocationCoordinateFromCoordinate((self as! Waypoint).coordinate)
            return pointAnno
            
        case is LineString:
            var coordinates = (self as! LineString).points.map({ (point: Coordinate) ->
                CLLocationCoordinate2D in
                return CLLocationCoordinateFromCoordinate(point)
            })
            let polyline = MKPolyline(coordinates: &coordinates,
                count: coordinates.count)
            return polyline
            
        case is Polygon:
            var exteriorRingCoordinates = (self as! Polygon).exteriorRing.points.map({ (point: Coordinate) ->
                CLLocationCoordinate2D in
                return CLLocationCoordinateFromCoordinate(point)
            })
            
            let interiorRings = (self as! Polygon).interiorRings.map({ (linearRing: LinearRing) ->
                MKPolygon in
                return MKPolygonWithCoordinatesSequence(linearRing.points)
            })
            
            let polygon = MKPolygon(coordinates: &exteriorRingCoordinates, count: exteriorRingCoordinates.count, interiorPolygons: interiorRings)
            return polygon
            
        default:
            let geometryCollectionOverlay = MKShapesCollection(geometryCollection: (self as! GeometryCollection))
            return geometryCollectionOverlay
        }
    }
}

private func MKPolygonWithCoordinatesSequence(coordinates: CoordinatesCollection) -> MKPolygon {
    var coordinates = coordinates.map({ (point: Coordinate) ->
        CLLocationCoordinate2D in
        return CLLocationCoordinateFromCoordinate(point)
    })
    return MKPolygon(coordinates: &coordinates,
        count: coordinates.count)
    
}

/** 
MKShape subclass for GeometryCollections.
The property `shapes` contains MKShape subclasses instances. When drawing shapes on a map be careful to the fact that that these shapes could be overlays OR annotations.
*/
public class MKShapesCollection : MKShape, MKOverlay  {
    public let shapes: Array<MKShape>
    public let centroid: CLLocationCoordinate2D
    public let boundingMapRect: MKMapRect
    
    required public init<GEOSwiftMapkit>(geometryCollection: GeometryCollection<GEOSwiftMapkit>) {
        let shapes = geometryCollection.geometries.map({ (geometry: GEOSwiftMapkit) ->
            MKShape in
                return geometry.mapShape()
        })
        self.centroid = CLLocationCoordinateFromCoordinate(geometryCollection.centroid().coordinate)
        self.shapes = shapes

        if let envelope = geometryCollection.envelope() as? Polygon {
            let exteriorRing = envelope.exteriorRing
            let upperLeft = MKMapPointForCoordinate(CLLocationCoordinateFromCoordinate(exteriorRing.points[2]))
            let lowerRight = MKMapPointForCoordinate(CLLocationCoordinateFromCoordinate(exteriorRing.points[0]))
            let mapRect = MKMapRectMake(upperLeft.x, upperLeft.y, lowerRight.x - upperLeft.x, lowerRight.y - upperLeft.y)
            self.boundingMapRect = mapRect
            
        } else {
            self.boundingMapRect = MKMapRectNull
        }
    }
}