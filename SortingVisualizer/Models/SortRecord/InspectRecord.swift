import UIKit

struct InspectRecord: SortRecord {
    
    var color: UIColor = .systemOrange
    var label = "Inspect"
    
    let i: Int
    
    init(_ i: Int) {
        self.i = i
    }
    
    var affected: [Int] {
        [i]
    }
    
}
