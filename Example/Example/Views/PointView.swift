import Foundation
import SwiftUI
import GEOSwift

struct PointView: View {
    var identifiablePoint: IdentifiablePoint
    var gridGeometry: GeometryProxy
    var color: Color
    var selected: Bool
    
    var body: some View {
        let height = gridGeometry.size.height

        Path { path in
            let cartesianPoint = CGPoint(x: identifiablePoint.point.x, y: height - identifiablePoint.point.y)
            path.addEllipse(in: CGRect(x: cartesianPoint.x - 8, y: cartesianPoint.y - 8, width: 8, height: 8))
        }
        .foregroundColor(color)
        .opacity(selected ? 1 : 0.3)
        if selected {
            Text("(\(String(identifiablePoint.point.x.rounded())), \(String(identifiablePoint.point.y.rounded())))").position(x: identifiablePoint.point.x, y: height - identifiablePoint.point.y)
        }
    }
}
