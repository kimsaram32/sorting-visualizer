struct SortBuilderMap {
    
    static func builder(ofName name: String) -> any SortBuilder {
        switch name {
        case "BubbleSortBuilder":
            BubbleSortBuilder()
        case "InsertionSortBuilder":
            InsertionSortBuilder()
        case "SelectionSortBuilder":
            SelectionSortBuilder()
        default:
            fatalError("\(String(describing: self)): Unknown sort builder name: \(name)")
        }
    }
    
}

