import UIKit
import Humboldt
import MapKit

// NOTE: to make the playground work, you have to open the Terminal to Derived Data/Humboldt-Demo...
// and create these symbolic links:
//
//     ln -s Pods/geos.framework geos.framework
//     ln -s Pods/CocoaLumberjack.framework CocoaLumberjack.framework

//: # Humboldt
//: _Topography made simple, in Swift._
//:
//: Handle all kind of geographic objects (points, linestrings, polygons etc.) and all related topographic operations (intersections, overlapping etc.).  
//: Humboldt is basically a MIT-licensed Swift interface to the OSGeo's GEOS library routines*.
//:
//: ### Handle a geographical data model
//:
//:     Point, LineString, Polygon, MultiPoint, MultiLineString, MultiPolygon, GeometryCollection
//:

// Create a POINT from its WKT representation
if  let point = Waypoint(WKT: "POINT(10 45)"),

    // A geometry can be created even using the constructor `Geometry.create(WKT)` and casting the returned value to the desired subclass
    let polygon = Geometry.create("POLYGON((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))") as? Polygon

    // Examples of other valid WKT geometries representations are:
    // LINESTRING(35 10, 45 45, 15 40, 10 20, 35 10)
    // TODO: other WKT examples...

    // TODO: example of WKB initialization
    
// Convert the geometries to a MKShape subclass, ready to be added as annotations to a MKMapView
{
    let shape1 = point.mapShape()
    let shape2 = polygon.mapShape()
    let annotations = [shape1, shape2]

    // Humboldt geometries is integrated with Quicklook!
    // Just stop on the variable with the mouse cursor to see a preview while debugging.
    polygon
}

//: ### Topological operations:
//:
//: Buffer, Boundary, Centroid, ConvexHull, Envelope, PointOnSurface, Intersection, Difference, Union

// TODO: examples

//: ### Predicates:
//: 
//: Intersects, Touches, Disjoint, Crosses, Within, Contains, Overlaps, Equals, Covers

// TODO: examples

//: * [GEOS](http://trac.osgeo.org/geos/) stands for Geometry Engine - Open Source, and is a C++ library, ported from the [Java Topology Suite](http://sourceforge.net/projects/jts-topo-suite/). GEOS implements the OpenGIS [Simple Features for SQL](http://www.opengeospatial.org/standards/sfs) spatial predicate functions and spatial operators. GEOS, now an OSGeo project, was initially developed and maintained by [Refractions Research](http://www.refractions.net/) of Victoria, Canada.
//:
//: Humboldt was released by Andrea Cremaschi ([@andreacremaschi](https://twitter.com/andreacremaschi)) under a MIT license. See LICENSE for more information.
