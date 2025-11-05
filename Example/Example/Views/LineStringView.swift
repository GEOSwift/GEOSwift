import Foundation
import SwiftUI
import GEOSwift

struct LineStringView: View {
    var identifiableLineString: IdentifiableLineString
    var gridGeometry: GeometryProxy
    
    var body: some View {
        let height = gridGeometry.size.height
        
        ZStack {
            Path { path in
                path.move(
                    to: CGPoint(
                        x: identifiableLineString.lineString.coordinates[0].x,
                        y: height - identifiableLineString.lineString.coordinates[0].y
                    )
                )
                identifiableLineString.lineString.coordinates.forEach { coordinate in
                    path.addLine(
                        to: CGPoint(
                            x: coordinate.x,
                            y: height - coordinate.y
                        )
                    )
                }
            }
            .stroke(lineWidth: 2)
        }
    }
}
