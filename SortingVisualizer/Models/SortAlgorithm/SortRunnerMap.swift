struct SortRunnerMap {
    
    static func runner(ofName name: String) -> any SortRunner {
        switch name {
        case "BubbleSortRunner":
            BubbleSortRunner()
        case "InsertionSortRunner":
            InsertionSortRunner()
        case "SelectionSortRunner":
            SelectionSortRunner()
        default:
            fatalError("\(String(describing: self)): Unknown sort builder name: \(name)")
        }
    }
    
}

