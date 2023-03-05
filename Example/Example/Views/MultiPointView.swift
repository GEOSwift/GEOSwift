import Foundation
import SwiftUI
import GEOSwift

struct MultiPointView: View {
    var multiPoint: IdentifiableMultiPoint
    var gridGeometry: GeometryProxy
    var color: Color
    var selected: Bool
    
    var body: some View {
        ZStack {
            ForEach(multiPoint.points, id: \.id) { point in
                PointView(point: point, gridGeometry: gridGeometry, color: color, selected: selected)
            }
        }
    }
}
