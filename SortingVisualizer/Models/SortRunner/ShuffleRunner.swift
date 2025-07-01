struct ShuffleRunner: SortRunner {
    
    func run(with list: RecordedList) {
        for i in 0...list.count - 2 {
            list.swapAt(i, Int.random(in: 0...(i + 1)))
        }
    }

}
