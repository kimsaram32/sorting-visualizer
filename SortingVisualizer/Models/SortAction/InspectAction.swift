import UIKit

struct InspectAction: SortAction {
    
    var color: UIColor = .systemOrange
    var label = "Inspect"
    
    var affected: [Int]
    
    init(_ affected: Int...) {
        self.affected = affected
    }
    
}
