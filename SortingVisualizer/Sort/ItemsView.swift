import UIKit

class ItemsView: UIView {
    
    private lazy var itemViews = [BarView]()
    
    private var stackView: UIStackView!

    private func createStackView() -> UIStackView {
        let stackView: UIStackView = .make()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .bottom
        return stackView
    }
    
    func setItems(items: [Int]) {
        stackView?.removeFromSuperview()
        stackView = createStackView()
        configureSubviews(with: items)
    }

    private func configureSubviews(with items: [Int]) {
        addSubview(stackView)
        stackView.pin(to: self)
        
        let itemRatios = (1...items.count).map { CGFloat($0) / CGFloat(items.count) }
        itemViews = itemRatios.map { ratio in
            BarView.make(nil) {
                BarView(ratio: ratio)
            }
        }
        
        for item in items {
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
