import Foundation
import SwiftUI
import GEOSwift

struct GeometryView: View {
    var identifiableGeometry: IdentifiableGeometry
    var gridGeometry: GeometryProxy
    
    var body: some View {
        switch identifiableGeometry.geometry {
        case let .polygon(geometry):
            PolygonView(polygon: IdentifiablePolygon(polygon: geometry), gridGeometry: gridGeometry, color: colorForUUID(identifiableGeometry.id), selected: identifiableGeometry.selected)
        case let .multiPolygon(geometry):
            MultiPolygonView(multiPolygon: IdentifiableMultiPolygon(multiPolygon: geometry), gridGeometry: gridGeometry, color: colorForUUID(identifiableGeometry.id), selected: identifiableGeometry.selected)
        case let .point(geometry):
            PointView(point: IdentifiablePoint(point: geometry), gridGeometry: gridGeometry, color: colorForUUID(identifiableGeometry.id), selected: identifiableGeometry.selected)
        case let .multiPoint(geometry):
            MultiPointView(multiPoint: IdentifiableMultiPoint(multiPoint: geometry), gridGeometry: gridGeometry, color: colorForUUID(identifiableGeometry.id), selected: identifiableGeometry.selected)
        case let .lineString(geometry):
            LineStringView(lineString: IdentifiableLineString(lineString: geometry), gridGeometry: gridGeometry, color: colorForUUID(identifiableGeometry.id), selected: identifiableGeometry.selected)
        case let .multiLineString(geometry):
            MultiLineStringView(multiLineString: IdentifiableMultiLineString(multiLineString: geometry), gridGeometry: gridGeometry, color: colorForUUID(identifiableGeometry.id), selected: identifiableGeometry.selected)
        case let .geometryCollection(geometry):
            let identifiableGeometryCollection = IdentifiableGeometryCollection(geometryCollection: geometry)
            ForEach(identifiableGeometryCollection.geometries, id: \.id) { geometry in
                GeometryView(identifiableGeometry: geometry, gridGeometry: gridGeometry)
            }
        }
    }
}
