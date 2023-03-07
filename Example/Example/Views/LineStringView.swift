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
            let points = identifiableLineString.lineString.points.map { point in
                IdentifiablePoint(point: point)
            }
            if selected {
                ForEach(points, id: \.id) { identifiablePoint in
                    let isCloseToAnotherPoint = points.contains { otherIdentifiablePoint in
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
