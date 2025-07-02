class SortTarget {
    
    typealias RecordDiffHandler = (RecordDiff) -> Void
    
    var recordDiffHandler: RecordDiffHandler?
    
    private(set) var items: [Int]
    private var records = [NewSortRecord]()
    
    init(items: [Int]) {
        self.items = items
    }
    
    private var currentRecordIndex = 0 {
        didSet {
            guard oldValue != currentRecordIndex else { return }
            
            let oldRecord: NewSortRecord? = oldValue > -1 ? records[oldValue] : nil
            
            let changed: [Int]
            
            if let oldRecord, currentRecordIndex < oldValue {
                for affected in oldRecord.affectedElements {
                    items[affected.index] = affected.oldValue
                }
                changed = oldRecord.affectedIndices
            } else {
                for affected in currentRecord.affectedElements {
                    items[affected.index] = affected.newValue
                }
                changed = currentRecord.affectedIndices
            }
            
            let dehighlighted = oldRecord?.affectedIndices ?? []
            let highlighted = currentRecord.affectedIndices
            
            let diff = RecordDiff(highlighted: highlighted, dehighlighted: dehighlighted, changed: changed)
            recordDiffHandler?(diff)
        }
    }
    
    var currentRecord: NewSortRecord {
        records[currentRecordIndex]
    }
    
    func setRecords(with runner: SortRunner) {
        let recordedList = RecordedList(items: items)
        runner.run(with: recordedList)
        
        records = [.empty()]
        records.append(contentsOf: recordedList.records)
        records.append(.empty())
        currentRecordIndex = 0
    }
    
    var previousAvailable: Bool {
        currentRecordIndex > 0
    }
    
    func gotoPrevious() {
        guard previousAvailable else { return }
        currentRecordIndex -= 1
    }
    
    var nextAvailable: Bool {
        currentRecordIndex < records.count - 1
    }
    
    func gotoNext() {
        guard nextAvailable else { return }
        currentRecordIndex += 1
    }
    
}
