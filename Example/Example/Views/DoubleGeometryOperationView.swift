import SwiftUI

struct DoubleGeometryOperationView: View {
    var geometryModel: GeometryModel
    @Binding var showSheet: Bool
    
    var body: some View {
        Group {
            Button("intersection", action: {
                showSheet = false
                geometryModel.intersection(input: geometryModel.selectedGeometries[0].geometry, secondGeometry: geometryModel.selectedGeometries[1].geometry)
            })
            Button("difference", action: {
                showSheet = false
                geometryModel.difference(input: geometryModel.selectedGeometries[0].geometry, secondGeometry: geometryModel.selectedGeometries[1].geometry)
            })
            Button("union", action: {
                showSheet = false
                geometryModel.union(input: geometryModel.selectedGeometries[0].geometry, secondGeometry: geometryModel.selectedGeometries[1].geometry)
            })
            Button("clear selected", action: {
                showSheet = false
                geometryModel.clear()
            })
        }
    }
}
