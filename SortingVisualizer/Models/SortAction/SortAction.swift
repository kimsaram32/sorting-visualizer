import Foundation

protocol SortAction: LabelRepresentable, ColorRepresentable {
    
    var affected: [Int] { get }
    
    func perform<Element>(to array: inout [Element])
    func revert<Element>(to array: inout [Element])

}

extension SortAction {
    
    func perform<Element>(to array: inout [Element]) {}
    func revert<Element>(to array: inout [Element]) {}

}
