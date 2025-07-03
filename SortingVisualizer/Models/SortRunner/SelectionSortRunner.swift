struct SelectionSortRunner: SortRunner {
    
    func run(with list: RecordedList) {
        for i in 0...list.count - 2 {
            var min = i
            for j in i..<list.count {
                if list.compareElement(at: min, j) > 0 {
                    min = j
                }
            }
            list.swapAt(i, min)
        }
    }
    
}
