import Foundation
import UIKit

struct SortAlgorithm: Decodable {
    
    let name: String
    let complexities: [Complexity]
    let runner: SortRunner
    let icon: UIImage?

    enum CodingKeys: CodingKey {
        case name
        case complexity
        case runner
        case icon
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        
        let complexityDict = try container.decode([String: String].self, forKey: .complexity)
        self.complexities = complexityDict.map { Complexity(name: $0, expression: $1) }

        let runnerString = try container.decode(String.self, forKey: .runner)
        self.runner = SortRunnerMap.runner(ofName: runnerString)
        
        let imageSystemName = try container.decode(String.self, forKey: .icon)
        self.icon = UIImage(systemName: imageSystemName)
    }
    
}
