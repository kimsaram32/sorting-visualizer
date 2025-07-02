import Foundation

struct QuickSortRunner: SortRunner {
    
    func run(with list: RecordedList) {
        quickSort(list, low: 0, high: list.count - 1)
    }
    
    private func quickSort(_ list: RecordedList, low: Int, high: Int) {
        var i = low, j = high + 1
        
        while true {
            repeat {
                i += 1
            } while i < high && list.compare(i, low) < 0
            
            repeat {
                j -= 1
            } while list.compare(j, low) > 0
            
            if i >= j {
                break
            }
            
            list.swapAt(i, j)
        }
        
        list.swapAt(low, j)
        
        if low < j - 1 {
            quickSort(list, low: low, high: j - 1)
        }
        if j + 1 < high {
            quickSort(list, low: j + 1, high: high)
        }
    }
    
}

