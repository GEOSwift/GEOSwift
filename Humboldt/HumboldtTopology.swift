//
//  HumboldtTopology.swift
//  HumboldtDemo
//
//  Created by Andrea Cremaschi on 22/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import UIKit
import geos

public extension Geometry {
    /** @name Topological properties */
    
    /** Returns a Polygon that represents all points whose distance from this geometry is less than or equal to the given width.
    */
    func bufferWithWidth(width: Double) -> Polygon {
        let bufferGEOM = GEOSBuffer_r(GEOS_HANDLE, self.geometry, width, 0)
        let buffer = Geometry.create(bufferGEOM, destroyOnDeinit: true) as! Polygon
        return buffer
    }
    
    /** Returns the boundary as a newly allocated Geometry object. */
    func boundary() -> Geometry  {
        let boundaryGEOM = GEOSBoundary_r(GEOS_HANDLE, self.geometry)
        let boundary = Geometry.create(boundaryGEOM, destroyOnDeinit: true)
        return boundary!
    }
    
    /** Returns a Waypoint representing the geometric center of the geometry. The point is not guaranteed to be on the interior of the geometry. */
    func centroid() -> Waypoint {
        let centroidGEOM = GEOSGetCentroid_r(GEOS_HANDLE, self.geometry)
        let centroid = Geometry.create(centroidGEOM, destroyOnDeinit: true) as! Waypoint
        return centroid
    }
    
    /** Returns the smallest Polygon that contains all the points in the geometry.
    */
    func convexHull() -> Polygon {
        let convexHullGEOM = GEOSConvexHull_r(GEOS_HANDLE, self.geometry)
        let convexHull = Geometry.create(convexHullGEOM, destroyOnDeinit: true) as! Polygon
        return convexHull
    }
    
    /** Returns a Polygon that represents the bounding envelope of this geometry.
    */
    func envelope() -> Polygon {
        let envelopeGEOM = GEOSEnvelope_r(GEOS_HANDLE, self.geometry)
        let envelope = Geometry.create(envelopeGEOM, destroyOnDeinit: true) as! Polygon
        return envelope
    }
    
    /** TODO: missing description */
    func pointOnSurface() -> Waypoint {
        let pointOnSurfaceGEOM = GEOSPointOnSurface_r(GEOS_HANDLE, self.geometry)
        let pointOnSurface = Geometry.create(pointOnSurfaceGEOM, destroyOnDeinit: true) as! Waypoint
        return pointOnSurface
    }
    
    /** Returns the DE-9IM intersection matrix (a string) representing the topological relationship between this geometry and the other. */
//    -(NSString *)relationshipWithGeometry:(Geometry *)geometry;
    func relationship(geometry: Geometry) -> String {
        let CString = GEOSRelate_r(GEOS_HANDLE, self.geometry, geometry.geometry)
        return String.fromCString(CString)!
    }
    
    /** Returns a Geometry representing the points shared by this geometry and other. */
    func intersection(geometry: Geometry) -> Geometry  {
        let intersectionGEOM = GEOSIntersection_r(GEOS_HANDLE, self.geometry, geometry.geometry)
        let intersection = Geometry.create(intersectionGEOM, destroyOnDeinit: true)
        return intersection!
    }
    
    /** Returns a Geometry representing the points making up this geometry that do not make up other. */
    func difference(geometry: Geometry) -> Geometry  {
        let differenceGEOM = GEOSDifference_r(GEOS_HANDLE, self.geometry, geometry.geometry)
        let difference = Geometry.create(differenceGEOM, destroyOnDeinit: true)
        return difference!
    }
    
    /** Returns a Geometry representing all the points in this geometry and the other. */
    func union(geometry: Geometry) -> Geometry  {
        let unionGEOM = GEOSIntersection_r(GEOS_HANDLE, self.geometry, geometry.geometry)
        let union = Geometry.create(unionGEOM, destroyOnDeinit: true)
        return union!
    }
}
