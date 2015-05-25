//: Playground - noun: a place where people can play

import UIKit
import Humboldt

//: NOTE: to make the playground work, you have to open the Terminal to Derived Data/Humboldt-Demo...
//: and create these symbolic links:
//:     ln -s Pods/geos.framework geos.framework
//:     ln -s Pods/CocoaLumberjack.framework CocoaLumberjack.framework

//: Create a Point from a Well-Known Text string
//let point = Waypoint(WKT: "POINT(45 9)")
//let coordinate = point?.coordinate


let polygon = Geometry.create("POLYGON((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))") as? Polygon

let linestring = Geometry.create("LINESTRING(35 10, 45 45, 15 40, 10 20, 35 10)") as? LineString

