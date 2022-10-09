import Foundation
import SwiftUI
import GEOSwift

struct ShapeView: View {
    var shape: Shape
    var body: some View {
        switch shape {
        case .circle(let circle):
            CircleView(circle: circle)
        case .geometry(let geometry):
            GeometryView(geometry: geometry)
        }
    }
}

struct ShapeView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeView(shape: .circle(Circle(center: Point(x: 54, y: 34), radius: 34)))
    }
}

public enum Shape: Hashable {
    case circle(GEOSwift.Circle)
    case geometry(Geometry)
}
