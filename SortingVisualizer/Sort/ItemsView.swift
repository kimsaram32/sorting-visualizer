import UIKit

class ItemsView: UIView {
    
    private let items: [Int]
    
    private lazy var itemViews = [BarView]()

    private lazy var stackView: UIStackView = .make {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .bottom
    }
    
    init(items: [Int]) {
        self.items = items
        super.init(frame: .zero)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureSubviews() {
        addSubview(stackView)
        stackView.pin(to: self)
        
        let max = items.max()!
        let itemRatios = items.map { CGFloat($0) / CGFloat(max) }
        itemViews = itemRatios.map { ratio in
            BarView.make(nil) {
                BarView(ratio: ratio)
            }
        }
        itemViews.forEach(stackView.addArrangedSubview)
        NSLayoutConstraint.activate(zip(itemViews, itemRatios).map {
            $0.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: $1)
        })
    }
    
    func perform(_ action: SortAction) {
        action.perform(to: &itemViews)
        UIView.animate(withDuration: 0.3) {
            for index in action.affected {
                self.stackView.insertArrangedSubview(self.itemViews[index], at: index)
            }
        }
    }

    func revert(_ action: SortAction) {
        action.revert(to: &itemViews)
        for index in action.affected {
            stackView.insertArrangedSubview(itemViews[index], at: index)
        }
    }
    
    func highlight(for action: SortAction) {
        for index in action.affected {
            itemViews[index].highlightColor = action.color
            itemViews[index].highlighted = true
        }
    }
    
    func dehighlight(for action: SortAction) {
        for index in action.affected {
            itemViews[index].highlightColor = action.color
            itemViews[index].highlighted = false
        }
    }

}
