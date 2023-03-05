import Foundation
import SwiftUI
import GEOSwift

struct MultiPolygonView: View {
    var multiPolygon: IdentifiableMultiPolygon
    var gridGeometry: GeometryProxy
    var color: Color
    var selected: Bool
    
    var body: some View {
        ZStack {
            ForEach(multiPolygon.polygons, id: \.id) { polygon in
                PolygonView(polygon: polygon, gridGeometry: gridGeometry, color: color, selected: selected)
            }
        }
    }
}
