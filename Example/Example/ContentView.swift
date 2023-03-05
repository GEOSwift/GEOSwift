import SwiftUI
import GEOSwift
import UniformTypeIdentifiers
import Foundation


struct ContentView: View {
    @ObservedObject private var geometryModel = GeometryModel()
    @State private var index = 0
    @State private var isImporting: Bool = false
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            VStack{
                HStack(spacing: 2) {
                    ForEach(geometryModel.geometries, id: \.id) { geometry in
                        VStack {
                            Rectangle()
                                .fill(geometry.selected ? colorForUUID(geometry.id) : colorForUUID(geometry.id).opacity(0.2))
                            .frame(height: 20)
                        }
                        .onTapGesture {
                            if let selectedGeometryIndex = geometryModel.geometries.firstIndex(where: { $0.id == geometry.id }) {
                                var modifiedGeometry = geometry
                                modifiedGeometry.selected.toggle()
                                geometryModel.geometries[selectedGeometryIndex] = modifiedGeometry
                            }
                        }
                    }
                }
                GeometryReader { gridGeometry in
                    ZStack {
                        GridView(gridGeometry: gridGeometry)
                        ForEach(geometryModel.geometries, id: \.id) { geometry in
                            GeometryView(identifiableGeometry: geometry, gridGeometry: gridGeometry)
                        }
                    }
                }
                .border(.gray, width: 1)
            }
            switch geometryModel.selectedGeometries.count {
            case 0:
                Button("Add Sample Geometries") {
                    showSheet = true
                }
                .sheet(isPresented: $showSheet) {
                    List {
                        SampleGeometryOperationView(geometryModel: geometryModel, showSheet: $showSheet, isImporting: $isImporting)
                    }
                }
            case 1:
                Button("Perform Single Geometry Operation") {
                    showSheet = true
                }
                .sheet(isPresented: $showSheet) {
                    List {
                        SingleGeometryOperationView(geometryModel: geometryModel, showSheet: $showSheet)
                    }
                }
            case 2:
                Button("Perform Double Geometry Operation") {
                    showSheet = true
                }
                .sheet(isPresented: $showSheet) {
                    List {
                        DoubleGeometryOperationView(geometryModel: geometryModel, showSheet: $showSheet)
                    }
                }
            default:
                Button("Clear selected", action: {
                    geometryModel.clear()
                })
            }
        }
        .alert(isPresented: $geometryModel.hasError) {
            Alert(title: Text("Geometry Error"), message: Text(geometryModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
