import Foundation
import SwiftUI
import GEOSwift

struct PolygonView: View {
    var identifiablePolygon: IdentifiablePolygon
    var gridGeometry: GeometryProxy
    
    var body: some View {
        let height = gridGeometry.size.height
        var pointsToLabel = [IdentifiablePoint]()
        
        ZStack {
            Path { path in
                path.move(
                    to: CGPoint(
                        x: identifiablePolygon.polygon.exterior.points[0].x,
                        y: height-identifiablePolygon.polygon.exterior.points[0].y
                    )
                )
                identifiablePolygon.polygon.exterior.points.forEach { point in
                    path.addLine(
                        to: CGPoint(
                            x: point.x,
                            y: height-point.y
                        )
                    )
                    pointsToLabel.append(IdentifiablePoint(point: point)) 
                }
            }
            Path { path in
                identifiablePolygon.polygon.holes.forEach{ hole in
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
                        pointsToLabel.append(IdentifiablePoint(point: point))
                    }
                }
            }
        }
    }
}
