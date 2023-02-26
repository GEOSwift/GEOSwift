import Foundation
import SwiftUI
import GEOSwift

struct LineStringView: View {
    var lineString: LineString
    var gridGeometry: GeometryProxy
    var color: Color
    var selected: Bool
    
    var body: some View {
        let height = gridGeometry.size.height
        
        ZStack {
            Path { path in
                path.move(
                    to: CGPoint(
                        x: lineString.points[0].x,
                        y: height - lineString.points[0].y
                    )
                )
                lineString.points.forEach { point in
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
                ForEach(0..<lineString.points.count, id: \.self) { index in
                    let point = lineString.points[index]
                    Text("(\(String(point.x.rounded())), \(String(point.y.rounded())))").position(x: point.x + 38, y: height - point.y - 15)
                }
            }
        }
    }
}