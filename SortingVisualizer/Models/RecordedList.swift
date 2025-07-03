class RecordedList {
    
    private var items: [Int]
    private var order: SortOrder
    private(set) var records = [SortRecord]()
    
    init(items: [Int], order: SortOrder) {
        self.items = items
        self.order = order
    }
    
    var count: Int {
        items.count
    }
    
    func swapAt(_ i: Int, _ j: Int) {
        records.append(SortRecord(
            affected: [
                changedElement(at: i, newValue: items[j]),
                changedElement(at: j, newValue: items[i])
            ],
            label: "Swap",
            color: .systemGreen
        ))
        items.swapAt(i, j)
    }
    
    func setElement(at i: Int, value: Int) {
        records.append(SortRecord(
            affected: [changedElement(at: i, newValue: value)],
            label: "Overwrite",
            color: .systemGreen
        ))
        items[i] = value
    }
    
    func inspect(_ i: Int) -> Int {
        records.append(SortRecord(
            affected: [unchangedElement(at: i)],
            label: "Inspect",
            color: .systemOrange
        ))
        return items[i]
    }
    
    func compare(_ a: Int, _ b: Int) -> Int {
        return order.compare(a, b)
    }
    
    func compareElement(at i: Int, _ j: Int) -> Int {
        records.append(SortRecord(
            affected: [
                unchangedElement(at: i),
                unchangedElement(at: j)
            ],
            label: "Compare",
            color: .systemOrange
        ))
        return compare(items[i], items[j])
    }
    
    func inOrder(at i: Int, _ j: Int) -> Bool {
        return compareElement(at: i, j) <= 0
    }
    
}

extension RecordedList {
    
    private func unchangedElement(at index: Int) -> AffectedElement {
        AffectedElement(index: index, oldValue: items[index], newValue: items[index])
    }
    
    private func changedElement(at index: Int, newValue: Int) -> AffectedElement {
        AffectedElement(index: index, oldValue: items[index], newValue: newValue)
    }
    
}
