import SwiftUI

struct GridView: View {
    var gridGeometry: GeometryProxy
    var body: some View {
        VStack {
            // Add the grid view
            Path { path in
                let width = gridGeometry.size.width
                let height = gridGeometry.size.height
                
                // vertical lines
                for i in 0...Int(width / 50) {
                    let x = CGFloat(i) * 50
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: height))
                }
                // horizontal lines
                for i in 0...Int(height / 50) {
                    let y = CGFloat(i) * 50
                    path.move(to: CGPoint(x: 0, y: height-y))
                    path.addLine(to: CGPoint(x: width, y: height-y))
                }
            }
            .stroke(Color.black, lineWidth: 0.5)
            .opacity(0.5)
        }
    }
}
