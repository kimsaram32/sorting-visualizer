enum SortOrder {
    
    case ascending
    case descending
    
    func compare(_ a: Int, _ b: Int) -> Int {
        switch self {
        case .ascending:
            return (a - b).signum()
        case .descending:
            return (b - a).signum()
        }
    }
    
}

extension SortOrder {
    
    var label: String {
        switch self {
        case .ascending:
            "Ascending"
        case .descending:
            "Descending"
        }
    }

}
