import SwiftUI

struct SingleGeometryOperationView: View {
    var geometryModel: GeometryModel
    @Binding var showSheet: Bool
    
    var body: some View {
        Group {
            Button("buffer", action: {
                showSheet = false
                geometryModel.buffer(geometryModel.selectedGeometries[0].geometry)
            })
            Button("convexHull", action: {
                showSheet = false
                geometryModel.convexHull(geometryModel.selectedGeometries[0].geometry)
            })
            Button("boundary", action: {
                showSheet = false
                geometryModel.boundary(geometryModel.selectedGeometries[0].geometry)
            })
            Button("envelope", action: {
                showSheet = false
                geometryModel.envelope(geometryModel.selectedGeometries[0].geometry)
            })
            Button("point on surface", action: {
                showSheet = false
                geometryModel.pointOnSurface(geometryModel.selectedGeometries[0].geometry)
            })
        }
        Group {
            Button("centroid", action: {
                showSheet = false
                geometryModel.centroid(geometryModel.selectedGeometries[0].geometry)
            })
            Button("minimum bounding circle", action: {
                showSheet = false
                geometryModel.minimumBoundingCircle(geometryModel.selectedGeometries[0].geometry)
            })
            Button("minimum rotated rectange", action: {
                showSheet = false
                geometryModel.minimumRotatedRectangle(geometryModel.selectedGeometries[0].geometry)
            })
            Button("simplify", action: {
                showSheet = false
                geometryModel.simplify(geometryModel.selectedGeometries[0].geometry)
            })
            Button("minimum Width", action: {
                showSheet = false
                geometryModel.minimumWidth(geometryModel.selectedGeometries[0].geometry)
            })
            Button("clear selected", action: {
                showSheet = false
                geometryModel.clear()
            })
        }
    }
}
