import UIKit

protocol SortRecord: LabelRepresentable, ColorRepresentable {
    
    var affected: [Int] { get }
    
    func apply(to array: inout [Int])
    
    func cancel(to array: inout [Int])
    
}

extension SortRecord {
    
    func apply(to array: inout [Int]) {}
    func cancel(to array: inout [Int]) {}
    
}

struct AffectedElement {
    
    let index: Int
    let oldValue: Int
    let newValue: Int
    
}

struct NewSortRecord: LabelRepresentable, ColorRepresentable {
    
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
    
    static func empty() -> NewSortRecord {
        NewSortRecord(affected: [], label: " ", color: .black)
    }
    
}
