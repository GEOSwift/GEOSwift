//
//  MapboxGLAnnotations.swift
//
//  Created by Andrea Cremaschi on 26/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation
import Mapbox
import MapKit

// MARK: - MGLShape creation convenience function

public protocol GEOSwiftMapboxGL {
    /**
    A convenience method to create a `MGLShape` ready to be added to a `MGLMapView`.
    Mapbox has limited support to GEOS geometry types: be aware that when dealing with polygons, interior rings are not handled by MapBoxGL, we must drop this information while building a polygon shape.

    :returns: A MGLShape representing this geometry.
    */
    func mapboxShape() -> MGLShape
}

extension Geometry : GEOSwiftMapboxGL {
    public func mapboxShape() -> MGLShape {
        
        switch self {
            
        case is Waypoint:
            let pointAnno = MGLPointAnnotation()
            pointAnno.coordinate = CLLocationCoordinate2DFromCoordinate((self as! Waypoint).coordinate)
            return pointAnno
            
        case is LineString:
            var coordinates = (self as! LineString).points.map({ (point: Coordinate) ->
                CLLocationCoordinate2D in
                return CLLocationCoordinate2DFromCoordinate(point)
            })
            let polyline = MGLPolyline(coordinates: &coordinates,
                count: UInt(coordinates.count))
            return polyline
            
        case is Polygon:
            var exteriorRingCoordinates = (self as! Polygon).exteriorRing.points.map({ (point: Coordinate) ->
                CLLocationCoordinate2D in
                return CLLocationCoordinate2DFromCoordinate(point)
            })
            
            // interior rings are not handled by MapBoxGL, we must drop this info!
//            let interiorRings = (self as! Polygon).interiorRings.map({ (linearRing: LinearRing) ->
//                MKPolygon in
//                return MKPolygonWithCoordinatesSequence(linearRing.points)
//            })
            
            let polygon = MGLPolygon(coordinates: &exteriorRingCoordinates, count: UInt(exteriorRingCoordinates.count) /*, interiorPolygons: interiorRings*/)
            return polygon
            
        default:
            let geometryCollectionOverlay = MGLShapesCollection(geometryCollection: (self as! GeometryCollection))
            return geometryCollectionOverlay
        }
    }
}

private func MGLPolygonWithCoordinatesSequence(coordinates: CoordinatesCollection) -> MGLPolygon {
    var coordinates = coordinates.map({ (point: Coordinate) ->
        CLLocationCoordinate2D in
        return CLLocationCoordinate2DFromCoordinate(point)
    })
    return MGLPolygon(coordinates: &coordinates,
        count: UInt(coordinates.count))
    
}

/**
MGLShape subclass for GeometryCollections.
The property `shapes` contains MGLShape subclasses instances. When drawing shapes on a map be careful to the fact that that these shapes could be overlays OR annotations.
*/
public class MGLShapesCollection : MGLShape, MGLOverlay {
    let shapes: Array<MGLShape>
    public let centroid: CLLocationCoordinate2D
    public let overlayBounds: MGLCoordinateBounds
    
    // inserting the where clause in the following generic create some confusion in the precompiler that raise the following error:
    // Cannot invoke initializer for type ... with an argument list of type (geometryCollection: GeometryCollection<T>)
    // 1. Expected an argument list of type (geometryCollection: GeometryCollection<T>)
    required public init<GEOSwiftMapboxGL>(geometryCollection: GeometryCollection<GEOSwiftMapboxGL>) {
        let shapes = geometryCollection.geometries.map({ (geometry: GEOSwiftMapboxGL) ->
            MGLShape in
            return geometry.mapboxShape()
        })
        self.centroid = CLLocationCoordinate2DFromCoordinate(geometryCollection.centroid().coordinate)
        self.shapes = shapes
        
        if let envelope = geometryCollection.envelope() as? Polygon {
            let exteriorRing = envelope.exteriorRing
            let sw = CLLocationCoordinate2DFromCoordinate(exteriorRing.points[0])
            let ne = CLLocationCoordinate2DFromCoordinate(exteriorRing.points[2])
            self.overlayBounds = MGLCoordinateBounds(sw:sw, ne:ne)
        } else {
            let zeroCoord = CLLocationCoordinate2DMake(0, 0)
            self.overlayBounds = MGLCoordinateBounds(sw:zeroCoord, ne:zeroCoord)
        }
    }
    
    override public var coordinate: CLLocationCoordinate2D { get {
        return centroid
        }}
    
    // TODO: implement using "intersect" method (actually it seems that mapboxgl never calls it...)
    public func intersects(_ overlayBounds: MGLCoordinateBounds) -> Bool {
        return true
    }
}
