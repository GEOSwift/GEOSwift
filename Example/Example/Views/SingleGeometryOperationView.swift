import SwiftUI

struct SingleGeometryOperationView: View {
    var geometryModel: GeometryModel
    @Binding var showSheet: Bool
    
    var body: some View {
        Group {
            Button("buffer", action: {
                geometryModel.buffer(input: geometryModel.selectedGeometries[0].geometry)
                showSheet = false
            })
            Button("convexHull", action: {
                geometryModel.convexHull(input: geometryModel.selectedGeometries[0].geometry)
                showSheet = false
            })
            Button("boundary", action: {
                geometryModel.boundary(input: geometryModel.selectedGeometries[0].geometry)
                showSheet = false
            })
            Button("envelope", action: {
                geometryModel.envelope(input: geometryModel.selectedGeometries[0].geometry)
                showSheet = false
            })
            Button("point on surface", action: {
                geometryModel.pointOnSurface(input: geometryModel.selectedGeometries[0].geometry)
                showSheet = false
            })
        }
        Group {
            Button("centroid", action: {
                geometryModel.centroid(input: geometryModel.selectedGeometries[0].geometry)
                showSheet = false
            })
            Button("minimum bounding circle", action: {
                geometryModel.minimumBoundingCircle(input: geometryModel.selectedGeometries[0].geometry)
                showSheet = false
            })
            Button("minimum rotated rectange", action: { geometryModel.minimumRotatedRectangle(input: geometryModel.selectedGeometries[0].geometry)
                showSheet = false
            })
            Button("simplify", action: {
                geometryModel.simplify(input: geometryModel.selectedGeometries[0].geometry)
                showSheet = false
            })
            Button("minimum Width", action: {
                geometryModel.minimumWidth(input: geometryModel.selectedGeometries[0].geometry)
                showSheet = false
            })
            Button("Clear selected", action: {
                geometryModel.clear()
                showSheet = false
            })
        }
    }
}
