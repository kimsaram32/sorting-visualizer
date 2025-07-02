import UIKit

struct AffectedElement {
    
    let index: Int
    let oldValue: Int
    let newValue: Int
    
}

struct SortRecord: LabelRepresentable, ColorRepresentable {
    
    let affectedElements: [AffectedElement]
    let label: String
    let color: UIColor
    
    init(affected affectedElements: [AffectedElement], label: String, color: UIColor) {
        self.affectedElements = affectedElements
        self.label = label
        self.color = color
    }
    
    var affectedIndices: [Int] {
        affectedElements.map { $0.index }
    }
    
    static func empty() -> SortRecord {
        SortRecord(affected: [], label: " ", color: .black)
    }
    
}
