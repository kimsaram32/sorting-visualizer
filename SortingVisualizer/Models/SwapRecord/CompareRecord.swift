import UIKit

struct CompareRecord: SortRecord {
    
    var color: UIColor = .systemOrange
    var label = "Compare"
    
    let i: Int
    let j: Int
    
    init(_ i: Int, _ j: Int) {
        self.i = i
        self.j = j
    }
    
    var affected: [Int] {
        [i, j]
    }
    
}

