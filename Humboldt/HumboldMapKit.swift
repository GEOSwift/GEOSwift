//
//  HumboldMapKit.swift
//  HumboldtDemo
//
//  Created by Andrea Cremaschi on 26/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

public func CLLocationCoordinateFromCoordinate(coord: Coordinate) -> CLLocationCoordinate2D {
    let coord = CLLocationCoordinate2DMake(coord.y, coord.x)
    return coord
}

public protocol HumboldtMapKit {
    func mapShape() -> MKShape
}

extension Geometry : HumboldtMapKit {
    public func mapShape() -> MKShape {
        return MKShape()
    }
}

extension Waypoint : HumboldtMapKit {
    override public func mapShape() -> MKShape {
        let pointAnno = MKPointAnnotation()
        pointAnno.coordinate = CLLocationCoordinateFromCoordinate(self.coordinate)
        return pointAnno
    }
}

extension LineString : HumboldtMapKit {
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

extension Polygon : HumboldtMapKit {
    override public func mapShape() -> MKShape {
        var exteriorRingCoordinates = self.exteriorRing.points.map({ (point: Coordinate) ->
            CLLocationCoordinate2D in
            return CLLocationCoordinateFromCoordinate(point)
        })

        let interiorRings = self.interiorRings.map({ (linearRing: LinearRing) ->
            MKPolygon in
            return MKPolygonWithCoordinatesSequence(linearRing.points)
        })
        
        var polygon = MKPolygon(coordinates: &exteriorRingCoordinates, count: exteriorRingCoordinates.count, interiorPolygons: interiorRings)
        return polygon
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
