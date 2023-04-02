import Foundation
import SwiftUI
import GEOSwift

struct MultiPolygonView: View {
    var identifiableMultiPolygon: IdentifiableMultiPolygon
    var gridGeometry: GeometryProxy
    
    var body: some View {
        ZStack {
            ForEach(identifiableMultiPolygon.polygons, id: \.id) { polygon in
                PolygonView(identifiablePolygon: polygon, gridGeometry: gridGeometry)
            }
        }
    }
}
