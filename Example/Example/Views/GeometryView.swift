import Foundation
import SwiftUI
import GEOSwift

struct GeometryView: View {
    var selectableIdentifiableGeometry: SelectableIdentifiableGeometry
    var gridGeometry: GeometryProxy
    
    var body: some View {
        switch selectableIdentifiableGeometry.identifiableGeometry {
        case let .polygon(polygon):
            PolygonView(identifiablePolygon: polygon, gridGeometry: gridGeometry)
        case let .multiPolygon(MultiPolygon):
            MultiPolygonView(identifiableMultiPolygon: MultiPolygon, gridGeometry: gridGeometry)
        case let .point(point):
            PointView(identifiablePoint: point, gridGeometry: gridGeometry)
        case let .multiPoint(multiPoint):
            MultiPointView(identifiableMultiPoint: multiPoint, gridGeometry: gridGeometry)
        case let .lineString(lineString):
            LineStringView(identifiableLineString: lineString, gridGeometry: gridGeometry)
        case let .multiLineString(multiLineString):
            MultiLineStringView(identifiableMultiLineString: multiLineString, gridGeometry: gridGeometry)
        case let .geometryCollection(geometryCollection):
            GeometryCollectionView(identifiableGeometryCollection: geometryCollection, gridGeometry: gridGeometry)
        }
    }
}
