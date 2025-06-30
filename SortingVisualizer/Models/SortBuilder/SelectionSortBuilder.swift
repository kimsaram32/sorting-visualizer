struct SelectionSortBuilder: SortBuilder {
    
    func build(for array: [some Comparable]) -> [any SortAction] {
        var arr = array
        var actions = [SortAction]()
        
        for i in 0...array.count - 2 {
            actions.append(InspectAction(i))
            var min = i
            for j in i..<array.count {
                actions.append(InspectAction(j))
                if arr[j] < arr[min] {
                    min = j
                }
            }
            actions.append(SwapAction(i, min, performTo: &arr))
        }
        
        return actions
    }
    
}
