import Foundation

struct SortAlgorithm: Decodable {
    
    static var items = [SortAlgorithm]()
    
    static func load() {
        do {
            let algorithmsResourcePath = Bundle.main.path(forResource: "algorithms", ofType: "json")!
            let algorithmsData = FileManager.default.contents(atPath: algorithmsResourcePath)!
            items = try JSONDecoder().decode([SortAlgorithm].self, from: algorithmsData)
        } catch {
            print(error)
        }
    }
    
    let name: String
    let complexities: [Complexity]
    let pesudocode: String
    let builder: SortBuilder

    enum CodingKeys: CodingKey {
        case name
        case complexity
        case pesudocode
        case builder
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        let complexityDict = try container.decode([String: String].self, forKey: .complexity)
        self.complexities = complexityDict.map { Complexity(name: $0, expression: $1) }
        self.pesudocode = try container.decode(String.self, forKey: .pesudocode)

        let builderString = try container.decode(String.self, forKey: .builder)
        self.builder = SortBuilderMap.builder(ofName: builderString)
    }
    
}
