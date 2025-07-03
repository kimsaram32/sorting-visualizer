struct MergeSortRunner: SortRunner {
    
    func run(with list: RecordedList) {
        mergeSort(list, low: 0, high: list.count - 1)
    }
    
    func mergeSort(_ list: RecordedList, low: Int, high: Int) {
        guard low < high else { return }
        
        let mid = (low + high) / 2
        mergeSort(list, low: low, high: mid)
        mergeSort(list, low: mid + 1, high: high)
        
        var aux = [Int]()
        for i in low...high {
            aux.append(list.inspect(i))
        }
        var i = low, j = mid + 1, k = low
        
        while i <= mid || j <= high {
            if i > mid {
                list.setElement(at: k, value: aux[j - low])
                j += 1
            } else if j > high {
                list.setElement(at: k, value: aux[i - low])
                i += 1
            } else if list.compare(aux[i - low], aux[j - low]) <= 0 {
                list.setElement(at: k, value: aux[i - low])
                i += 1
            } else {
                list.setElement(at: k, value: aux[j - low])
                j += 1
            }
            
            k += 1
        }
    }
    
}

