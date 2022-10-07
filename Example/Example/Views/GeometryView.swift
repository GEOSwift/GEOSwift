import Foundation
import SwiftUI
import GEOSwift

struct GeometryView: View {
    var geometry: Geometry
    var body: some View {
        switch geometry {
        case let .polygon(tempGeometry):
            PolygonView(polygon: tempGeometry)
        case let .multiPolygon(tempGeometry):
            MultiPolygonView(multiPolygon: tempGeometry)
        case let .point(tempGeometry):
            PointView(point: tempGeometry)
        case let .multiPoint(tempGeometry):
            MultiPointView(multiPoint: tempGeometry)
        case let .lineString(tempGeometry):
            LineStringView(lineString: tempGeometry)
        case let .multiLineString(tempGeometry):
            MultiLineStringView(multiLineString: tempGeometry)
        case let .geometryCollection(tempGeometry):
            ForEach(0..<tempGeometry.geometries.count, id: \.self) {
                GeometryView(geometry: tempGeometry.geometries[$0])
            }
        }
    }
}
