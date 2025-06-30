import UIKit

struct SwapAction: SortAction {
    
    let color: UIColor = .systemGreen
    let label = "Swap"
    
    private let a: Int
    private let b: Int
    
    init(_ a: Int, _ b: Int) {
        self.a = a
        self.b = b
    }
    
    init<Element>(_ a: Int, _ b: Int, performTo array: inout [Element]) {
        self.init(a, b)
        perform(to: &array)
    }
    
    var affected: [Int] {
        [a, b]
    }
    
    func perform<Element>(to array: inout [Element]) {
        array.swapAt(a, b)
    }
    
    func revert<Element>(to array: inout [Element]) {
        array.swapAt(a, b)
    }
    
}
