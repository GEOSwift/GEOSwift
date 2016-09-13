//
//  LinearRef.swift
//
//  Created by Andrea Cremaschi on 03/02/16.
//  Copyright (c) 2016 andreacremaschi. All rights reserved.
//

import Foundation

/**
 Linear referencing functions
 */
public extension LineString {
    
    /// - returns: The distance of a point projected on the calling line
    public func distanceFromOriginToProjectionOfPoint(point: Waypoint) -> Double {
        return GEOSProject_r(GEOS_HANDLE, geometry, point.geometry);
    }
    
    public func normalizedDistanceFromOriginToProjectionOfPoint(point: Waypoint) -> Double {
        return GEOSProjectNormalized_r(GEOS_HANDLE, geometry, point.geometry);
    }
    
    /// Return closest point to given distance within geometry
    public func interpolatePoint(distance: Double) -> Waypoint {
        let interpolatedPoint = GEOSInterpolate_r(GEOS_HANDLE, geometry, distance)
        return Waypoint(GEOSGeom: interpolatedPoint!)
    }
    
    public func interpolatePoint(fraction: Double) -> Waypoint {
        let interpolatedPoint = GEOSInterpolateNormalized_r(GEOS_HANDLE, geometry, fraction)
        return Waypoint(GEOSGeom: interpolatedPoint!)
    }
    
    public func middlePoint() -> Waypoint {
        return self.interpolatePoint(fraction: 0.5)
    }
}
