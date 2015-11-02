//
//  GeoJSON.swift
//
//  Created by Andrea Cremaschi on 27/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation

public enum GEOJSONParseError: ErrorType {
    case InvalidJSON
    case InvalidGEOJSON
}

public extension Geometry {
    /**
    Creates an `Array` of `Geometry` instances from a GeoJSON file.
    
    - parameter URL: the URL pointing to the GeoJSON file.
    
    :returns: An optional `Array` of `Geometry` instances.
*/
    public class func fromGeoJSON(URL: NSURL) throws -> Array<Geometry>? {
        
        if let JSONData = NSData(contentsOfURL: URL) {
            
            do {
                // read JSON file
                let parsedObject = try NSJSONSerialization.JSONObjectWithData(JSONData,
                    options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                // is the root a Dictionary with a "type" key of value "FeatureCollection"?
                if let rootObject = parsedObject as? Dictionary<String, AnyObject> {
                    return Geometry.fromGeoJSONDictionary(rootObject)
                } else {
                    throw GEOJSONParseError.InvalidGEOJSON
                }
            } catch _ {
                throw GEOJSONParseError.InvalidJSON
            }
        }
        return nil
    }
    
    /**
    Creates an `Array` of `Geometry` instances from a GeoJSON dictionary.
    
    :param: dictionary a dictionary following GeoJSON format specification.
    
    :returns: An optional `Array` of `Geometry` instances.
    */
    public class func fromGeoJSONDictionary(dictionary: Dictionary<String, AnyObject>) -> Array<Geometry>? {
        return ParseGEOJSONObject(dictionary)
    }
}

// MARK: - Private parsing functions

private func ParseGEOJSONObject(GEOJSONObject: Dictionary<String, AnyObject>) -> Array<Geometry>? {
    
    if let type = GEOJSONObject["type"] as? String {
        
        // is there a "features" key of type NSArray?
        switch (type) {
        case "Feature":
            if let geom = ParseGEOJSONFeature(GEOJSONObject) {
                return [geom]
            }
            
        case "FeatureCollection":
            if let featureCollection = GEOJSONObject["features"] as? NSArray {
                return ParseGEOJSONFeatureCollection(featureCollection)
            }
            
        case "GeometryCollection":
            if let geometryCollection = GEOJSONObject["geometries"] as? NSArray {
                return ParseGEOJSONGeometryCollection(geometryCollection)
            }
            
        default:
            if let coordinates = GEOJSONObject["coordinates"] as? NSArray,
                let geometry = ParseGEOJSONGeometry(type, coordinatesNSArray: coordinates)
            {
                return [geometry]
            }
        }
    }
    return nil
}

private func ParseGEOJSONFeatureCollection(features: NSArray) -> [Geometry]? {
    // map every feature representation to a GEOS geometry
    var geometries = Array<Geometry>()
    for feature in features {
        if let feat1 = feature as? NSDictionary,
            let feat2 = feat1 as? Dictionary<String,AnyObject>,
            let geom = ParseGEOJSONFeature(feat2) {
                geometries.append(geom)
        } else {
            return nil
        }
    }
    return geometries
}

private func ParseGEOJSONFeature(GEOJSONFeature: Dictionary<String, AnyObject>) -> Geometry? {
    if let geometry = GEOJSONFeature["geometry"] as? Dictionary<String,AnyObject>,
//        let properties = GEOJSONFeature["properties"] as? NSDictionary,

        let geometryType = geometry["type"] as? String,
        let geometryCoordinates = geometry["coordinates"] as? NSArray {
        return ParseGEOJSONGeometry(geometryType, coordinatesNSArray: geometryCoordinates)
    }
    return nil
}

private func ParseGEOJSONGeometryCollection(geometries: NSArray) -> [Geometry]? {
    // map every geometry representation to a GEOS geometry
    var GEOSGeometries = Array<Geometry>()
    for geometry in geometries {
        if let geom1 = geometry as? NSDictionary,
            let geom2 = geom1 as? Dictionary<String,AnyObject>,
            let geomType = geom2["type"] as? String,
            let geomCoordinates = geom2["coordinates"] as? NSArray,
            let geom = ParseGEOJSONGeometry(geomType, coordinatesNSArray: geomCoordinates) {
                GEOSGeometries.append(geom)
        } else {
            return nil
        }
    }
    return GEOSGeometries
}

private func ParseGEOJSONGeometry(type: String, coordinatesNSArray: NSArray) -> Geometry? {
    switch type {
    case "Point":
        // For type "Point", the "coordinates" member must be a single position.
        if let coordinates = coordinatesNSArray as? [Double],
            let sequence = GEOJSONSequenceFromArrayRepresentation([coordinates]) {
                let GEOSGeom = GEOSGeom_createPoint_r(GEOS_HANDLE, sequence)
                return Waypoint(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
        }
        
    case "MultiPoint":
        // For type "MultiPoint", the "coordinates" member must be an array of positions.
        var pointArray = Array<Waypoint>()
        if let coordinatesNSArray = coordinatesNSArray as? [[Double]] {
            for singlePointCoordinates in coordinatesNSArray {
                if let sequence = GEOJSONSequenceFromArrayRepresentation([singlePointCoordinates]) {
                    let GEOSGeom = GEOSGeom_createPoint_r(GEOS_HANDLE, sequence)
                    let point = Waypoint(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
                    pointArray.append(point)
                } else {
                    return nil
                }
            }
        }
        return MultiPoint(points: pointArray)
        
    case "LineString":
        // For type "LineString", the "coordinates" member must be an array of two or more positions.
        if let coordinates = coordinatesNSArray as? [[Double]],
            let sequence = GEOJSONSequenceFromArrayRepresentation(coordinates) {
                let GEOSGeom = GEOSGeom_createLineString_r(GEOS_HANDLE, sequence)
                return LineString(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
        }
        
    case "MultiLineString":
        // For type "MultiLineString", the "coordinates" member must be an array of LineString coordinate arrays.
        if let linestringsRepresentation = coordinatesNSArray as? [[[Double]]] {
            var linestrings: Array<LineString> = []
            for coordinates in linestringsRepresentation {
                if let sequence = GEOJSONSequenceFromArrayRepresentation(coordinates) {
                    let GEOSGeom = GEOSGeom_createLineString_r(GEOS_HANDLE, sequence)
                    let linestring = LineString(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
                    linestrings.append(linestring)
                } else {
                    return nil
                }
            }
            return MultiLineString(linestrings: linestrings)
        }
        return nil
        
    case "Polygon":
        return GEOJSONCreatePolygonFromRepresentation(coordinatesNSArray)
        
    case "MultiPolygon":
        // For type "MultiPolygon", the "coordinates" member must be an array of Polygon coordinate arrays.
        var polygons = Array<Polygon>()
        for representation in coordinatesNSArray {
            if let multiPolyRepresentation = representation as? [NSArray] {
                for polyRepresentation in multiPolyRepresentation {
                    if let geom = GEOJSONCreatePolygonFromRepresentation(polyRepresentation) {
                        polygons.append(geom)
                    } else {
                        return nil
                    }
                }
            } else {
                return nil
            }
        }
        return MultiPolygon(polygons: polygons)
    
    default:
        return nil
    }
    
    return nil
}

// MARK:

private func GEOJSONGeometryFromDictionaryRepresentation(dictionary: Dictionary<String,AnyObject>) -> Geometry? {

    if  let geometryDict = dictionary["geometry"] as? Dictionary<String,AnyObject>,
        let geometryType = geometryDict["type"] as? String {
            
            switch geometryType {
                
                case "GeometryCollection":
                    // A GeoJSON object with type "GeometryCollection" is a geometry object which represents a collection of geometry objects.
                    // A geometry collection must have a member with the name "geometries". The value corresponding to "geometries" is an array. Each element in this array is a GeoJSON geometry object.
                    
                    if let geometriesNSArray = geometryDict["geometries"] as? NSArray,
                        let geometriesArray = geometriesNSArray as? Array<NSDictionary> {
                            
                        var geometries = Array<Geometry>()
                        for geometryNSDictionary in geometriesArray {
                            if let geometryType = geometryNSDictionary["type"] as? String,
                                let coordinatesNSArray = geometryNSDictionary["coordinates"] as? NSArray,
                                let geometry = ParseGEOJSONGeometry(geometryType, coordinatesNSArray: coordinatesNSArray) {
                                    geometries.append(geometry)
                            } else {
                                return nil
                            }
                        }
                        return GeometryCollection(geometries: geometries)
                }
                
                default:
                    if let coordinatesNSArray = geometryDict["coordinates"] as? NSArray {
                        return ParseGEOJSONGeometry(geometryType, coordinatesNSArray: coordinatesNSArray)
                }
            }
            
    }
    return nil
}

private func GEOJSONCoordinatesFromArrayRepresentation(array: [[Double]]) -> [Coordinate]? {
    return array.map {
        (var coordinatePair) -> Coordinate in
        return Coordinate(x: coordinatePair[0], y: coordinatePair[1])
    }
}

private func GEOJSONSequenceFromArrayRepresentation(representation: [[Double]]) -> COpaquePointer? {
    if let coordinates = GEOJSONCoordinatesFromArrayRepresentation(representation) {
        let sequence = GEOSCoordSeq_create_r(GEOS_HANDLE, UInt32(coordinates.count), 2)
        for (index, coord) in coordinates.enumerate() {
            if (GEOSCoordSeq_setX_r(GEOS_HANDLE, sequence, UInt32(index), coord.x) == 0) ||
                (GEOSCoordSeq_setY_r(GEOS_HANDLE, sequence, UInt32(index), coord.y) == 0) {
                    return nil
            }
        }
        return sequence
    }
    return nil
}

private func GEOJSONCreateLinearRingFromRepresentation(representation: [[Double]]) -> LinearRing? {
    if let sequence = GEOJSONSequenceFromArrayRepresentation(representation) {
        let GEOSGeom = GEOSGeom_createLinearRing_r(GEOS_HANDLE, sequence)
        return LinearRing(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }
    return nil
}

private func GEOJSONCreatePolygonFromRepresentation(representation: NSArray) -> Polygon? {
    
    // For type "Polygon", the "coordinates" member must be an array of LinearRing coordinate arrays. For Polygons with multiple rings, the first must be the exterior ring and any others must be interior rings or holes.
    
    if let coordinates = representation as? [[Double]] {
        // array of LinearRing coordinate arrays
        if let shell = GEOJSONCreateLinearRingFromRepresentation(coordinates) {
            let polygon = Polygon(shell: shell, holes: nil)
            return polygon
        }
    } else {
        guard let ringsCoords = representation as? [[[Double]]]
            where ringsCoords.count > 0 else { return nil }
        
        // Polygons with multiple rings
        var rings: Array<LinearRing> = ringsCoords.map({
            (ringCoords: [[Double]]) -> LinearRing in
            let linearRing: LinearRing
            if let sequence = GEOJSONSequenceFromArrayRepresentation(ringCoords) {
                let GEOSGeom = GEOSGeom_createLinearRing_r(GEOS_HANDLE, sequence)
                linearRing = LinearRing(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
            } else {
                let GEOSGeom = GEOSGeom_createEmptyLineString_r(GEOS_HANDLE)
                linearRing = LinearRing(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
            }
            return linearRing
        })
        let shell = rings[0]
        rings.removeAtIndex(0)
        let polygon = Polygon(shell: shell, holes: rings)
        return polygon
    
    }
    return nil
}
