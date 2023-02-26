import Foundation
import SwiftUI
import GEOSwift

struct MultiPolygonView: View {
    var multiPolygon: MultiPolygon
    var gridGeometry: GeometryProxy
    var color: Color
    var selected: Bool
    
    var body: some View {
        ZStack {
            ForEach(0..<multiPolygon.polygons.count, id: \.self) {
                PolygonView(polygon: multiPolygon.polygons[$0], gridGeometry: gridGeometry, color: color, selected: selected)
            }
        }
    }
}
