import Foundation

struct BubbleSortBuilder: SortBuilder {
    
    func build(for array: [some Comparable]) -> [SortAction] {
        var arr = array
        var actions = [SortAction]()
        
        for i in stride(from: arr.count, through: 2, by: -1) {
            var dirty = false
            
            for j in 0..<i - 1 {
                actions.append(InspectAction(j, j + 1))
                
                if arr[j] > arr[j + 1] {
                    dirty = true
                    actions.append(SwapAction(j, j + 1))
                    arr.swapAt(j, j + 1)
                }
            }
            
            if !dirty {
                break
            }
        }
        
        return actions
    }
    
}

