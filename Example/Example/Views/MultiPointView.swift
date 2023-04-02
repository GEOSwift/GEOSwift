import Foundation
import SwiftUI
import GEOSwift

struct MultiPointView: View {
    var identifiableMultiPoint: IdentifiableMultiPoint
    var gridGeometry: GeometryProxy
    
    var body: some View {
        ZStack {
            ForEach(identifiableMultiPoint.points, id: \.id) { point in
                PointView(identifiablePoint: point, gridGeometry: gridGeometry)
            }
        }
    }
}
