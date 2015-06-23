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

extension Geometry : GEOSwiftMapKit {
    public func mapShape() -> MKShape {
        if let geom = self as? MultiPolygon {
            let geometryCollectionOverlay = MKShapesCollection(geometryCollection: geom)
            return geometryCollectionOverlay
        } else
            if let geom = self as? MultiLineString {
                let geometryCollectionOverlay = MKShapesCollection(geometryCollection: geom)
                return geometryCollectionOverlay
        } else
                if let geom = self as? MultiPoint {
                    let geometryCollectionOverlay = MKShapesCollection(geometryCollection: geom)
                    return geometryCollectionOverlay
            } else
                    if let geom = self as? GeometryCollection {
                        let geometryCollectionOverlay = MKShapesCollection(geometryCollection: geom)
                        return geometryCollectionOverlay
        }
        
        return MKShape()
    }
}

extension Waypoint : GEOSwiftMapKit {
    override public func mapShape() -> MKShape {
        let pointAnno = MKPointAnnotation()
        pointAnno.coordinate = CLLocationCoordinateFromCoordinate(self.coordinate)
        return pointAnno
    }
}

extension LineString : GEOSwiftMapKit {
    override public func mapShape() -> MKShape {
        let pointAnno: MKPolyline = MKPolyline()
        var coordinates = self.points.map({ (point: Coordinate) ->
            CLLocationCoordinate2D in
            return CLLocationCoordinateFromCoordinate(point)
        })
        var polyline = MKPolyline(coordinates: &coordinates,
            count: coordinates.count)
        return polyline
    }
}

extension Polygon : GEOSwiftMapKit {
    override public func mapShape() -> MKShape {
        var exteriorRingCoordinates = self.exteriorRing.points.map({ (point: Coordinate) ->
            CLLocationCoordinate2D in
            return CLLocationCoordinateFromCoordinate(point)
        })

        let interiorRings = self.interiorRings.map({ (linearRing: LinearRing) ->
            MKPolygon in
            return MKPolygonWithCoordinatesSequence(linearRing.points)
        })
        
        let polygon = MKPolygon(coordinates: &exteriorRingCoordinates, count: exteriorRingCoordinates.count, interiorPolygons: interiorRings)
        return polygon
    }
}

//extension GeometryCollection : GEOSwiftMapKit {
//    override public func mapShape() -> MKShape {
//        let geometryCollectionOverlay = MKShapesCollection(geometryCollection: self as! GeometryCollection<Geometry>)
//        return geometryCollectionOverlay
//    }
//}

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
public class MKShapesCollection : MKShape, MKAnnotation, MKOverlay  {
    let shapes: Array<MKShape>
    public let centroid: CLLocationCoordinate2D
    public let boundingMapRect: MKMapRect
    
    required public init<T>(geometryCollection: GeometryCollection<T>) {
        let shapes = geometryCollection.geometries.map({ (geometry: T) ->
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