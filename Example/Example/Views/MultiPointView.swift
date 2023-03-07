import Foundation
import SwiftUI
import GEOSwift

struct MultiPointView: View {
    var identifiableMultiPoint: IdentifiableMultiPoint
    var gridGeometry: GeometryProxy
    var color: Color
    var selected: Bool
    
    var body: some View {
        ZStack {
            ForEach(identifiableMultiPoint.points, id: \.id) { point in
                PointView(identifiablePoint: point, gridGeometry: gridGeometry, color: color, selected: selected)
            }
        }
    }
}
