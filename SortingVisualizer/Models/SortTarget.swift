class SortTarget {
    
    typealias RecordDiffHandler = (RecordDiff) -> Void
    
    var recordDiffHandler: RecordDiffHandler?
    
    private(set) var items: [Int]
    private var records = [SortRecord]()
    
    init(items: [Int]) {
        self.items = items
    }
    
    private var currentRecordIndex = 0 {
        didSet {
            guard oldValue != currentRecordIndex else { return }
            
            let oldRecord: SortRecord? = oldValue > -1 ? records[oldValue] : nil
            
            let changed: [Int]
            
            if let oldRecord, currentRecordIndex < oldValue {
                oldRecord.cancel(to: &items)
                changed = oldRecord.affected
            } else {
                currentRecord.apply(to: &items)
                changed = currentRecord.affected
            }
            
            let dehighlighted = oldRecord?.affected ?? []
            let highlighted = currentRecord.affected
            
            let diff = RecordDiff(highlighted: highlighted, dehighlighted: dehighlighted, changed: changed)
            recordDiffHandler?(diff)
        }
    }
    
    var currentRecord: SortRecord {
        records[currentRecordIndex]
    }
    
    func setRecords(with runner: SortRunner) {
        let recordedList = RecordedList(items: items)
        runner.run(with: recordedList)
        
        records = [EmptyRecord()]
        records.append(contentsOf: recordedList.records)
        records.append(EmptyRecord())
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
