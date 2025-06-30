import Foundation

struct InsertionSortBuilder: SortBuilder {
    
    func build(for array: [some Comparable]) -> [SortAction] {
        var arr = array
        var actions = [SortAction]()
        
        for i in 2...array.count {
            for j in stride(from: i - 1, through: 1, by: -1) {
                actions.append(InspectAction(j, j - 1))
                if arr[j] >= arr[j - 1] {
                    break
                }
                actions.append(SwapAction(j, j - 1, performTo: &arr))
            }
        }
        
        return actions
    }
    
}
