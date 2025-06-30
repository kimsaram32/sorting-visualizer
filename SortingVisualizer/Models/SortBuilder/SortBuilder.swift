import Foundation

protocol SortBuilder {
    
    func build(for array: [some Comparable]) -> [SortAction]
    
}
