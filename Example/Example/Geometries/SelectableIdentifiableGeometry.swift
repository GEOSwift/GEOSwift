import Foundation
import GEOSwift

struct SelectableIdentifiableGeometry: Identifiable, Hashable {
    var identifiableGeometry: IdentifiableGeometry
    var id: UUID
    var selected: Bool
    
    public init(_ identifiableGeometry: IdentifiableGeometry) {
        self.identifiableGeometry = identifiableGeometry
        self.id = identifiableGeometry.id
        self.selected = false
    }
    
    public init(_ geometry: Geometry) {
        self.identifiableGeometry = IdentifiableGeometry(geometry)
        self.id = self.identifiableGeometry.id
        self.selected = false
    }
}
