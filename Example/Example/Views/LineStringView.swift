import Foundation
import SwiftUI
import GEOSwift

struct LineStringView: View {
    var identifiableLineString: IdentifiableLineString
    var gridGeometry: GeometryProxy
    var color: Color
    var selected: Bool
    
    var body: some View {
        let height = gridGeometry.size.height
        
        ZStack {
            Path { path in
                path.move(
                    to: CGPoint(
                        x: identifiableLineString.lineString.points[0].x,
                        y: height - identifiableLineString.lineString.points[0].y
                    )
                )
                identifiableLineString.lineString.points.forEach { point in
                    path.addLine(
                        to: CGPoint(
                            x: point.x,
                            y: height - point.y
                        )
                    )
                }
            }
            .stroke(lineWidth: 2)
            .foregroundColor(color)
            .opacity(selected ? 1 : 0.3)
            if selected {
                ForEach(identifiableLineString.lineString.points, id: \.self) { point in
                    Text("(\(String(point.x.rounded())), \(String(point.y.rounded())))").position(x: point.x + 38, y: height - point.y - 15)
                }
            }
        }
    }
}
