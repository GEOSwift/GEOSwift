import Foundation
import SwiftUI
import GEOSwift

struct CircleView: View {
    var circle: GEOSwift.Circle
    var body: some View {
        Path { path in
            path.addArc(center: CGPoint(x: circle.center.x, y: circle.center.y), radius: circle.radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: true)
        }
    }
}
