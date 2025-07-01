import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Configuration
    
    static let identifier = String(describing: HomeCollectionViewCell.self)
    static let height = 140.0
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var icon: UIImage? {
        didSet {
            iconView.image = icon
        }
    }
    
    // MARK: - Layout
    
    private lazy var titleLabel: UILabel = .make {
        $0.font = .preferredFont(forTextStyle: .title2)
    }
    
    private lazy var iconView: UIImageView = .make {
        $0.tintColor = .secondaryLabel
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var layoutStackView: UIStackView = .make {
        $0.addArrangedSubview(self.iconView)
        $0.addArrangedSubview(self.titleLabel)
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .equalCentering
        $0.spacing = 12
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 24
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureSubviews() {
        let padding = 16.0
        
        addSubview(layoutStackView)
        NSLayoutConstraint.activate([
            layoutStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            layoutStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            layoutStackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            layoutStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 60),
            iconView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
}
