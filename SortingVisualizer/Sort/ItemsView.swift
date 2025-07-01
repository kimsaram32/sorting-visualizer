import UIKit

class ItemsView: UIView {
    
    private let initialItems: [Int]

    private lazy var itemViews = [BarView]()

    private lazy var stackView: UIStackView = .make {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .bottom
    }
    
    init(items: [Int]) {
        self.initialItems = items
        super.init(frame: .zero)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureSubviews() {
        addSubview(stackView)
        stackView.pin(to: self)
        
        let itemRatios = (1...initialItems.count).map { CGFloat($0) / CGFloat(initialItems.count) }
        itemViews = itemRatios.map { ratio in
            BarView.make(nil) {
                BarView(ratio: ratio)
            }
        }
        
        for item in initialItems {
            stackView.addArrangedSubview(itemViews[item])
        }
        
        NSLayoutConstraint.activate(zip(itemViews, itemRatios).map {
            $0.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: $1)
        })
    }
    
    func change(_ entries: [(Int, Int)], animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            for (index, value) in entries {
                self.stackView.insertArrangedSubview(self.itemViews[value], at: index)
            }
        }
    }

    func highlight(_ index: Int, color: UIColor) {
        if let barView = stackView.arrangedSubviews[index] as? BarView {
            barView.highlightColor = color
        }
    }
    
    func dehighlight(_ index: Int) {
        if let barView = stackView.arrangedSubviews[index] as? BarView {
            barView.highlightColor = nil
        }
    }

}
