import Foundation
import SwiftUI
import GEOSwift

struct GeometryView: View {
    var geometry: Geometry
    var gridGeometry: GeometryProxy
    
    var body: some View {
        switch geometry {
        case let .polygon(geometry):
            PolygonView(polygon: geometry, gridGeometry: gridGeometry)
        case let .multiPolygon(geometry):
            MultiPolygonView(multiPolygon: geometry, gridGeometry: gridGeometry)
        case let .point(geometry):
            PointView(point: geometry, gridGeometry: gridGeometry)
        case let .multiPoint(geometry):
            MultiPointView(multiPoint: geometry, gridGeometry: gridGeometry)
        case let .lineString(geometry):
            LineStringView(lineString: geometry, gridGeometry: gridGeometry)
        case let .multiLineString(geometry):
            MultiLineStringView(multiLineString: geometry, gridGeometry: gridGeometry)
        case let .geometryCollection(geometry):
            ForEach(0..<geometry.geometries.count, id: \.self) {
                GeometryView(geometry: geometry.geometries[$0], gridGeometry: gridGeometry)
            }
        }
    }
}
