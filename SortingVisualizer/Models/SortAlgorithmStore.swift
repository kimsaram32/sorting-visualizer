import Foundation

class SortAlgorithmStore {
    
    static let shared = SortAlgorithmStore()
    
    private var cached: [SortAlgorithm]?
    
    struct LoadError: Error {}
    
    func algorithms() throws -> [SortAlgorithm] {
        if let cached {
            return cached
        }
        
        do {
            let algorithmsResourcePath = Bundle.main.path(forResource: "algorithms", ofType: "json")!
            let algorithmsData = FileManager.default.contents(atPath: algorithmsResourcePath)!
            let items = try JSONDecoder().decode([SortAlgorithm].self, from: algorithmsData)
            return items
        } catch {
            throw LoadError()
        }
    }

}
