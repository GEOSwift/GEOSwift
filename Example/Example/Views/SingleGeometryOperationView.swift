import SwiftUI

struct SingleGeometryOperationView: View {
    var geometryModel: GeometryModel
    @Binding var showSheet: Bool
    
    var body: some View {
        Group {
            Button("buffer", action: {
                showSheet = false
                geometryModel.buffer(input: geometryModel.selectedGeometries[0].geometry)
            })
            Button("convexHull", action: {
                showSheet = false
                geometryModel.convexHull(input: geometryModel.selectedGeometries[0].geometry)
            })
            Button("boundary", action: {
                showSheet = false
                geometryModel.boundary(input: geometryModel.selectedGeometries[0].geometry)
            })
            Button("envelope", action: {
                showSheet = false
                geometryModel.envelope(input: geometryModel.selectedGeometries[0].geometry)
            })
            Button("point on surface", action: {
                showSheet = false
                geometryModel.pointOnSurface(input: geometryModel.selectedGeometries[0].geometry)
            })
        }
        Group {
            Button("centroid", action: {
                showSheet = false
                geometryModel.centroid(input: geometryModel.selectedGeometries[0].geometry)
            })
            Button("minimum bounding circle", action: {
                showSheet = false
                geometryModel.minimumBoundingCircle(input: geometryModel.selectedGeometries[0].geometry)
            })
            Button("minimum rotated rectange", action: {
                showSheet = false
                geometryModel.minimumRotatedRectangle(input: geometryModel.selectedGeometries[0].geometry)
            })
            Button("simplify", action: {
                showSheet = false
                geometryModel.simplify(input: geometryModel.selectedGeometries[0].geometry)
            })
            Button("minimum Width", action: {
                showSheet = false
                geometryModel.minimumWidth(input: geometryModel.selectedGeometries[0].geometry)
            })
            Button("Clear selected", action: {
                showSheet = false
                geometryModel.clear()
            })
        }
    }
}
