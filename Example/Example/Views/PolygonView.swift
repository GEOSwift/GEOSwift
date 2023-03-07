import Foundation
import SwiftUI
import GEOSwift

struct PolygonView: View {
    var identifiablePolygon: IdentifiablePolygon
    var gridGeometry: GeometryProxy
    var color: Color
    var selected: Bool
    
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
                    pointsToLabel.append(IdentifiablePoint(point: point))  // TODO: clear this somehow
                }
            }
            .foregroundColor(color)
            .opacity(selected ? 1 : 0.3)
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
            .foregroundColor(color)
            .opacity(selected ? 1 : 0.3)
            if selected {
                ForEach(pointsToLabel, id: \.id) { identifiablePoint in
                    let isCloseToAnotherPoint = pointsToLabel.contains { otherIdentifiablePoint in
                        // Calculate the distance between the two points
                        let distance = sqrt(pow(otherIdentifiablePoint.point.x - identifiablePoint.point.x, 2) + pow(otherIdentifiablePoint.point.y - identifiablePoint.point.y, 2))
                        // Return true if the distance is less than a certain threshold value 5
                        return otherIdentifiablePoint.id != identifiablePoint.id && distance < 5
                    }
                    // Add the Text only if there is no other point close to the current point
                    if !isCloseToAnotherPoint {
                        Text("(\(String(identifiablePoint.point.x.rounded())), \(String(identifiablePoint.point.y.rounded())))")
                            .position(x: identifiablePoint.point.x + 38, y: height - identifiablePoint.point.y - 15)
                    }
                }
            }
        }
    }
}
