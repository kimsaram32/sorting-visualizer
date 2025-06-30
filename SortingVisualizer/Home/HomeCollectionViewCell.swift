import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: HomeCollectionViewCell.self)
    static let height = 100.0
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    private lazy var titleLabel: UILabel = .make {
        $0.font = .preferredFont(forTextStyle: .title2)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemBlue
        layer.cornerRadius = 12
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureSubviews() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
}
