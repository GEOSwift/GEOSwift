import Foundation
import SwiftUI
import GEOSwift

struct GeometryView: View {
    var identifiableGeometry: IdentifiableGeometry
    var gridGeometry: GeometryProxy
    
    var body: some View {
        switch identifiableGeometry.geometry {
        case let .polygon(geometry):
            PolygonView(polygon: geometry, gridGeometry: gridGeometry, color: colorForUUID(identifiableGeometry.id), selected: identifiableGeometry.selected)
        case let .multiPolygon(geometry):
            MultiPolygonView(multiPolygon: geometry, gridGeometry: gridGeometry, color: colorForUUID(identifiableGeometry.id), selected: identifiableGeometry.selected)
        case let .point(geometry):
            PointView(point: geometry, gridGeometry: gridGeometry, color: colorForUUID(identifiableGeometry.id), selected: identifiableGeometry.selected)
        case let .multiPoint(geometry):
            MultiPointView(multiPoint: geometry, gridGeometry: gridGeometry, color: colorForUUID(identifiableGeometry.id), selected: identifiableGeometry.selected)
        case let .lineString(geometry):
            LineStringView(lineString: geometry, gridGeometry: gridGeometry, color: colorForUUID(identifiableGeometry.id), selected: identifiableGeometry.selected)
        case let .multiLineString(geometry):
            MultiLineStringView(multiLineString: geometry, gridGeometry: gridGeometry, color: colorForUUID(identifiableGeometry.id), selected: identifiableGeometry.selected)
        case let .geometryCollection(geometry):
            ForEach(0..<geometry.geometries.count, id: \.self) {
                GeometryView(identifiableGeometry: IdentifiableGeometry(geometry: geometry.geometries[$0]), gridGeometry: gridGeometry)
            }
        }
    }
}
