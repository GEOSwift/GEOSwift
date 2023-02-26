import SwiftUI
import GEOSwift

struct SampleGeometryOperationView: View {
    var geometryModel: GeometryModel
    @Binding var showSheet: Bool
    @Binding var isImporting: Bool
    
    var body: some View {
        Group {
            Button("import", action: {
                isImporting = true
            })
            .fileImporter(isPresented: $isImporting,
                          allowedContentTypes: [.json]) { result in
                geometryModel.importGeometry(result)
                isImporting = false
                showSheet = false
            }
            Button("point", action: {
                geometryModel.geometries.append(IdentifiableGeometry(geometry: .point(Point(x: 3, y: 4))))
                showSheet = false
            })
            Button("multiPoint", action: {
                geometryModel.geometries.append(IdentifiableGeometry(geometry: .multiPoint(MultiPoint(
                    points: [
                        Point(x: 5, y: 9),
                        Point(x: 90, y: 32),
                        Point(x: 59, y: 89)]))))
                showSheet = false
            })
            Button("polygon", action: {
                geometryModel.geometries.append(IdentifiableGeometry(geometry: .polygon(try! Polygon(exterior: Polygon.LinearRing(points: [
                    Point(x: 5, y: 9),
                    Point(x: 90, y: 32),
                    Point(x: 59, y: 89),
                    Point(x: 5, y: 9)])
                ))))
                showSheet = false
            })
            Button("multiPolygon", action: {
                geometryModel.geometries.append(IdentifiableGeometry(geometry: .multiPolygon(MultiPolygon(polygons:
                    [try! Polygon(exterior: Polygon.LinearRing(points: [
                        Point(x: 5, y: 9),
                        Point(x: 90, y: 32),
                        Point(x: 59, y: 89),
                        Point(x: 5, y: 9)])
                    ),
                     try! Polygon(exterior: Polygon.LinearRing(points: [
                        Point(x: 25, y: 29),
                        Point(x: 20, y: 22),
                        Point(x: 29, y: 89),
                        Point(x: 25, y: 29)])
                     )]))))
                showSheet = false
            })
            Button("lineString", action: {
                geometryModel.geometries.append(IdentifiableGeometry(geometry: .lineString(try! LineString(points: [
                    Point(x: 5, y: 9),
                    Point(x: 90, y: 32),
                    Point(x: 59, y: 89),
                    Point(x: 5, y: 9)]))))
                showSheet = false
            })
            Button("multiLineString", action: {
                geometryModel.geometries.append(IdentifiableGeometry(geometry: .multiLineString(MultiLineString(lineStrings:
                    [try! LineString(points: [
                        Point(x: 5, y: 9),
                        Point(x: 90, y: 32),
                        Point(x: 59, y: 89),
                        Point(x: 5, y: 9)]),
                     try! LineString(points: [
                        Point(x: 25, y: 29),
                        Point(x: 20, y: 22),
                        Point(x: 29, y: 89),
                        Point(x: 25, y: 29)])
                    ]))))
                showSheet = false
            })
        }
    }
}
