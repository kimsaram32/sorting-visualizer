class SortTarget {
    
    typealias RecordDiffHandler = (RecordDiff) -> Void
    
    var recordDiffHandler: RecordDiffHandler?
    
    private(set) var items: [Int]
    private var records = [SortRecord]()
    
    init(size: Int) {
        self.items = Array(0..<size)
    }
    
    private var currentRecordIndex = 0
    
    var currentRecord: SortRecord {
        records[currentRecordIndex]
    }
    
    private var previousRecord: SortRecord? {
        currentRecordIndex > 0 ? records[currentRecordIndex - 1] : nil
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
        
        if let previousRecord {
            for affected in previousRecord.affectedElements {
                items[affected.index] = affected.oldValue
            }
        }
        
        let diff = RecordDiff(
            highlighted: currentRecord.affectedIndices,
            dehighlighted: previousRecord?.affectedIndices ?? [],
            changed: previousRecord?.affectedIndices ?? []
        )
        recordDiffHandler?(diff)
    }
    
    var nextAvailable: Bool {
        currentRecordIndex < records.count - 1
    }
    
    func gotoNext() {
        guard nextAvailable else { return }
        
        currentRecordIndex += 1
        
        for affected in currentRecord.affectedElements {
            items[affected.index] = affected.newValue
        }
        
        let diff = RecordDiff(
            highlighted: currentRecord.affectedIndices,
            dehighlighted: previousRecord?.affectedIndices ?? [],
            changed: currentRecord.affectedIndices
        )
        recordDiffHandler?(diff)
    }
    
}
