class RecordedList {
    
    private var items: [Int]
    private(set) var records = [SortRecord]()
    
    init(items: [Int]) {
        self.items = items
    }
    
    var count: Int {
        items.count
    }
    
    func swapAt(_ i: Int, _ j: Int) {
        records.append(SwapRecord(i, j))
        items.swapAt(i, j)
    }
    
    func inspect(_ i: Int) -> Int {
        records.append(InspectRecord(i))
        return items[i]
    }
    
    func compare(_ i: Int, _ j: Int) -> Int {
        records.append(CompareRecord(i, j))
        return (items[i] - items[j]).signum()
    }
    
    func inOrder(_ i: Int, _ j: Int) -> Bool {
        records.append(CompareRecord(i, j))
        return items[i] <= items[j]
    }
    
}
