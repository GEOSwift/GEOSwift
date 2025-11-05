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
                        x: identifiablePolygon.polygon.exterior.coordinates[0].x,
                        y: height-identifiablePolygon.polygon.exterior.coordinates[0].y
                    )
                )
                identifiablePolygon.polygon.exterior.coordinates.forEach { coordinate in
                    path.addLine(
                        to: CGPoint(
                            x: coordinate.x,
                            y: height-coordinate.y
                        )
                    )
                    pointsToLabel.append(IdentifiablePoint(point: Point(coordinate)))
                }
            }
            Path { path in
                identifiablePolygon.polygon.holes.forEach{ hole in
                    path.move(
                        to: CGPoint(
                            x: hole.coordinates[0].x,
                            y: height - hole.coordinates[0].y
                        )
                    )
                    hole.coordinates.forEach { coordinate in
                        path.addLine(
                            to: CGPoint(
                                x: coordinate.x,
                                y: height - coordinate.y
                            )
                        )
                        pointsToLabel.append(IdentifiablePoint(point: Point(coordinate)))
                    }
                }
            }
        }
    }
}
