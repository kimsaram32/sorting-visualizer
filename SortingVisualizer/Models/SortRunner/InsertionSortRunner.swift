import Foundation

struct InsertionSortRunner: SortRunner {
    
    func run(with list: RecordedList) {
        for i in 2...list.count {
            for j in stride(from: i - 1, through: 1, by: -1) {
                if list.inOrder(at: j - 1, j) {
                    break
                }
                list.swapAt(j, j - 1)
            }
        }
    }
    
}
