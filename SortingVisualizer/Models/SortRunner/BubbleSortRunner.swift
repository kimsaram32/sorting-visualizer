import Foundation

struct BubbleSortRunner: SortRunner {
    
    func run(with list: RecordedList) {
        for i in stride(from: list.count, through: 2, by: -1) {
            var dirty = false
            
            for j in 0..<i - 1 {
                if !list.inOrder(at: j, j + 1) {
                    dirty = true
                    list.swapAt(j, j + 1)
                }
            }
            
            if !dirty {
                break
            }
        }
    }
    
}
