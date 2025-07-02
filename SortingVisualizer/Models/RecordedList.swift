class RecordedList {
    
    private var items: [Int]
    private(set) var records = [NewSortRecord]()
    
    init(items: [Int]) {
        self.items = items
    }
    
    var count: Int {
        items.count
    }
    
    func swapAt(_ i: Int, _ j: Int) {
        records.append(NewSortRecord(
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
        records.append(NewSortRecord(
            affected: [changedElement(at: i, newValue: value)],
            label: "Overwrite",
            color: .systemGreen
        ))
        items[i] = value
    }
    
    func inspect(_ i: Int) -> Int {
        records.append(NewSortRecord(
            affected: [unchangedElement(at: i)],
            label: "Inspect",
            color: .systemOrange
        ))
        return items[i]
    }
    
    func compare(a: Int, b: Int) -> Int {
        return (a - b).signum()
    }
    
    func compare(_ i: Int, _ j: Int) -> Int {
        records.append(NewSortRecord(
            affected: [
                unchangedElement(at: i),
                unchangedElement(at: j)
            ],
            label: "Compare",
            color: .systemOrange
        ))
        return compare(a: items[i], b: items[j])
    }
    
    func inOrder(_ i: Int, _ j: Int) -> Bool {
        return compare(i, j) <= 0
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
