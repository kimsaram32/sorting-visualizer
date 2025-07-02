import UIKit

struct SwapRecord: SortRecord {
    
    let color: UIColor = .systemGreen
    let label = "Swap"
    
    let i: Int
    let j: Int
    
    init(_ i: Int, _ j: Int) {
        self.i = i
        self.j = j
    }
    
    var affected: [Int] {
        [i, j]
    }
    
    func apply(to array: inout [Int]) {
        array.swapAt(i, j)
    }
    
    func cancel(to array: inout [Int]) {
        array.swapAt(i, j)
    }
    
}
