import Foundation
import SwiftUI
import GEOSwift

struct PointView: View {
    var point: Point
    var gridGeometry: GeometryProxy
    var color: Color
    var selected: Bool
    
    var body: some View {
        let height = gridGeometry.size.height

        ZStack {
            Path { path in
                let cartesianPoint = CGPoint(x: point.x, y: height - point.y)
                path.addEllipse(in: CGRect(x: cartesianPoint.x - 8, y: cartesianPoint.y - 8, width: 16, height: 16))
            }
            .foregroundColor(color)
            .opacity(selected ? 1 : 0.3)
            if selected {
                Text("(\(String(point.x.rounded())), \(String(point.y.rounded())))").position(x: point.x + 38, y: height - point.y - 15)
                    .font(.caption)
            }
        }
    }
}
