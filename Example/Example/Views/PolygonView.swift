import Foundation
import SwiftUI
import GEOSwift

struct PolygonView: View {
    var polygon: IdentifiablePolygon
    var gridGeometry: GeometryProxy
    var color: Color
    var selected: Bool
    
    var body: some View {
        let height = gridGeometry.size.height
        var pointsToLabel = [Point]()
        
        ZStack {
            Path { path in
                path.move(
                    to: CGPoint(
                        x: polygon.polygon.exterior.points[0].x,
                        y: height-polygon.polygon.exterior.points[0].y
                    )
                )
                polygon.polygon.exterior.points.forEach { point in
                    path.addLine(
                        to: CGPoint(
                            x: point.x,
                            y: height-point.y
                        )
                    )
                    pointsToLabel.append(point)
                }
            }
            .foregroundColor(color)
            .opacity(selected ? 1 : 0.3)
            Path { path in
                polygon.polygon.holes.forEach{ hole in
                    path.move(
                        to: CGPoint(
                            x: hole.points[0].x,
                            y: height - hole.points[0].y
                        )
                    )
                    hole.points.forEach { point in
                        path.addLine(
                            to: CGPoint(
                                x: point.x,
                                y: height - point.y
                            )
                        )
                        pointsToLabel.append(point)
                    }
                }
            }
            .foregroundColor(color)
            .opacity(selected ? 1 : 0.3)
            if selected {
                ForEach(0..<pointsToLabel.count, id: \.self) { index in
                    let point = pointsToLabel[index]
                    Text("(\(String(point.x.rounded())), \(String(point.y.rounded())))").position(x: point.x + 38, y: height - point.y - 15)
                }
            }
        }
    }
}
