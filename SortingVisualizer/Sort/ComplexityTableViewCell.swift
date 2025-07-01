import UIKit
import SwiftMath

class ComplexityTableViewCell: UITableViewCell {
    
    // MARK: - Configuration
    
    static let reuseIdentifier = String(describing: ComplexityTableViewCell.self)
    
    var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }
    
    var value: String = "" {
        didSet {
            valueLabel.latex = value
        }
    }
    
    // MARK: - Layout
    
    private lazy var nameLabel: UILabel = .make()
    private lazy var valueLabel: MTMathUILabel = .make {
        $0.textColor = .label
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureSubviews() {
        let margin = 8.0
        
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    
}
