import UIKit
import SwiftMath

class ComplexityTableViewCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = .make()
    lazy var valueLabel: MTMathUILabel = .make()
    
    static let reuseIdentifier = String(describing: ComplexityTableViewCell.self)
    
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
    
    // MARK: - Cell configuration
    
    func configure(name: String, value: String) {
        nameLabel.text = name
        valueLabel.latex = value
    }
    
}
