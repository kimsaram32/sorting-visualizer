import UIKit

class BarView: UIView {
    
    let ratio: CGFloat
    var highlighted = false {
        didSet {
            updateBackgroundColor()
        }
    }
    var highlightColor: UIColor?
    
    init(ratio: CGFloat) {
        self.ratio = ratio
        super.init(frame: .zero)
        updateBackgroundColor()
    }
    
    convenience init(ratio: Float) {
        self.init(ratio: CGFloat(ratio))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func updateBackgroundColor() {
        var hue: CGFloat = highlighted ? 30.0 : 0
        if highlighted, let highlightColor {
            highlightColor.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        }
        let saturation = highlighted ? 0.9 : 0
        backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: ratio * 0.85 + 0.1, alpha: 1)
    }
    
}
