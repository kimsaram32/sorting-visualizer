protocol SortRecord: LabelRepresentable, ColorRepresentable {
    
    var affected: [Int] { get }
    
    func apply(to array: inout [Int])
    
    func cancel(to array: inout [Int])
    
}

extension SortRecord {
    
    func apply(to array: inout [Int]) {}
    func cancel(to array: inout [Int]) {}
    
}
